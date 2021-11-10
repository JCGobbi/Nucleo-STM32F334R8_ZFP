with System.Machine_Code; use System;
with HAL;                 use HAL;

with STM32_SVD.STK;       use STM32_SVD.STK;
with STM32_SVD.SCB;       use STM32_SVD.SCB;

with SYS.Int;

package body SYS.Real_Time with
  SPARK_Mode => Off
is
   pragma Suppress (Overflow_Check);
   --  This package has careful manual overflow checks, and unsuppresses them
   --  where appropriate. This default enables compilation with checks enabled
   --  on Ravenscar SFP, where 64-bit multiplication with overflow checking is
   --  not available.

   -----------------------
   -- Local definitions --
   -----------------------

   subtype LLI is Long_Long_Integer;

   Max_Pos_Time_Span : constant := UInt64 (Time_Span'Last);
   pragma Unreferenced (Max_Pos_Time_Span);

   Max_Neg_Time_Span : constant := UInt64 (2 ** 63);
   --  Absolute value of Time_Span_Last and Time_Span_First. Used in overflow
   --  checks. Note that we avoid using abs on Time_Span_First everywhere.

   --  We use the SysTick timer as a periodic timer with 1 kHz rate. This
   --  is a trade-off between accurate delays, limited overhead and maximum
   --  time that interrupts may be disabled.

   Tick_Period : constant Timer_Interval :=
     Timer_Interval (Ticks_Per_Second / 1_000);

   Reload_Value_Last : constant := 2**24 - 1;
   pragma Assert (Tick_Period <= Reload_Value_Last + 1);

   Next_Tick_Time : Timer_Interval with Volatile;
   --  Time when systick will expire. This gives the high digits of the time.

   subtype Clock_Interval is Timer_Interval;

   type Clock_Periods is mod 2 ** 32;
   for Clock_Periods'Size use 32;

   Periods_In_Epoch   : constant Clock_Periods := 1;
   --  Have epoch start at 1, so Unsynchronized_Clock can ignore updates and
   --  just return an early time instead.

   type Composite_Time is record
      MSP : Clock_Periods  := Periods_In_Epoch;
      pragma Atomic (MSP);
      LSP : Clock_Interval := 0;
      pragma Atomic (LSP);
   end record;
   --  Time representation used for the software clock, allowing concurrent
   --  updates and reads, see Update_Clock.
   --
   --  Include a default expression for component LSP, even when not needed, to
   --  prevent the need for elaboration code to initialize default-initialized
   --  objects of this type (note that this package has a restriction
   --  No_Elaboration_Code).

   Software_Clock : Composite_Time;
   --  Clock with same time-base as hardware clock, but allowing a larger
   --  range. This is always behind the actual time by less than one hardware
   --  clock period. See Update_Clock for read and update protocol.

   -----------------------
   -- Local subprograms --
   -----------------------

   function Rounded_Div (L, R : LLI) return LLI;
   pragma Inline (Rounded_Div);
   --  Return L / R rounded to the nearest integer, away from zero if exactly
   --  halfway between; required to implement ARM D.8 (26). Assumes R > 0.

   function "&" (Left : Clock_Periods; Right : Clock_Interval) return Time is
     (Time (Left) * (Time (Max_Timer_Interval) + Time (1)) + Time (Right));
   --  Combine MSP and LSP of clock to form time

   -----------------
   -- Rounded_Div --
   -----------------

   function Rounded_Div (L, R : LLI) return LLI is
      Left : LLI;
   begin
      if L >= 0 then
         Left := L + R / 2;
      else
         Left := L - R / 2;
      end if;

      return Left / R;
   end Rounded_Div;

   ---------
   -- "+" --
   ---------

   function "+" (Left : Time; Right : Time_Span) return Time is
   begin
      --  Overflow checks are performed by hand assuming that Time and
      --  Time_Span are 64-bit unsigned and signed integers respectively.
      --  Otherwise these checks would need an intermediate type with more
      --  than 64 bits.

      if Right >= 0
        and then UInt64 (Time'Last) - UInt64 (Left) >= UInt64 (Right)
      then
         return Time (UInt64 (Left) + UInt64 (Right));

      --  The case of Right = Time_Span'First needs to be treated differently
      --  because the absolute value of -2 ** 63 is not within the range of
      --  Time_Span.

      elsif Right = Time_Span_First and then Left >= Max_Neg_Time_Span then
         return Time (UInt64 (Left) - Max_Neg_Time_Span);

      elsif Right < 0 and then Right > Time_Span_First
        and then Left >= Time (abs (Right))
      then
         return Time (UInt64 (Left) - UInt64 (abs (Right)));

      else
         raise Constraint_Error;
      end if;
   end "+";

   overriding
   function "+" (Left, Right : Time_Span) return Time_Span is
      pragma Unsuppress (Overflow_Check);
   begin
      return Time_Span (LLI (Left) + LLI (Right));
   end "+";

   -----------------
   -- Nanoseconds --
   -----------------

   function Nanoseconds (NS : Integer) return Time_Span is
   begin
      --  Overflow can't happen (Ticks_Per_Second is Natural)
      return
        Time_Span (Rounded_Div (LLI (NS) * LLI (Ticks_Per_Second), 1E9));
   end Nanoseconds;

   ------------------
   -- Microseconds --
   ------------------

   function Microseconds (US : Integer) return Time_Span is
   begin
      --  Overflow can't happen (Ticks_Per_Second is Natural)
      return
        Time_Span (Rounded_Div (LLI (US) * LLI (Ticks_Per_Second), 1E6));
   end Microseconds;

   ------------------
   -- Milliseconds --
   ------------------

   function Milliseconds (MS : Integer) return Time_Span is
   begin
      --  Overflow can't happen (Ticks_Per_Second is Natural)
      return
        Time_Span (Rounded_Div (LLI (MS) * LLI (Ticks_Per_Second), 1E3));
   end Milliseconds;

   -------------
   -- Seconds --
   -------------

   function Seconds (S : Integer) return Time_Span is
   begin
      --  Overflow can't happen (Ticks_Per_Second is Natural)
      return Time_Span (LLI (S) * LLI (Ticks_Per_Second));
   end Seconds;

   -------------
   -- Minutes --
   -------------

   function Minutes (M : Integer) return Time_Span is
      Min_M : constant LLI := LLI'First / LLI (Ticks_Per_Second);
      Max_M : constant LLI := LLI'Last  / LLI (Ticks_Per_Second);
      --  Bounds for Sec_M. Note that we can't use unsuppress overflow checks,
      --  as this would require the use of arit64.

      Sec_M : constant LLI := LLI (M) * 60;
      --  M converted to seconds

   begin
      if Sec_M < Min_M or else Sec_M > Max_M then
         raise Constraint_Error;
      else
         return Time_Span (Sec_M * LLI (Ticks_Per_Second));
      end if;
   end Minutes;

   -----------------
   -- Delay_Until --
   -----------------

   procedure Delay_Until (T : Time) is
   begin
      while Clock < T loop
         --  Wait for interrupt.
         Int.Wait_For_Interrupt;
      end loop;
   end Delay_Until;

   ------------------------
   -- Initialize_SysTick --
   ------------------------

   procedure Initialize_SysTick is
   begin
      --  Mask interrupts
      Int.Disable_Interrupts;

      --  Because we operate the SysTick clock as a periodic timer, and 24 bits
      --  at 72 MHz is sufficient for that, use the unscaled system clock.

      --  To initialize the Sys_Tick timer, first disable the clock, then
      --  program it and finally enable it. This way an accidentally
      --  misconfigured timer will not cause pending interrupt while
      --  reprogramming.

      STK_Periph.CTRL.ENABLE := False;

      --  Set the SysTick reload value to get 1 ms, set current value of the
      --  counter to 0, select AHB bus clock source without division by 8
      --  and enable SysTick peripheral.
      STK_Periph.LOAD.RELOAD := UInt24 (Tick_Period - 1);
      STK_Periph.VAL.CURRENT := 0;
      STK_Periph.CTRL.CLKSOURCE := True;
      STK_Periph.CTRL.ENABLE := True;

      Next_Tick_Time := Tick_Period;

      --  Enable SysTick interrupt
      STK_Periph.CTRL.TICKINT := True;

      --  Unmask interrupts
      Int.Enable_Interrupts;

   end Initialize_SysTick;

   ------------------------
   -- Max_Timer_Interval --
   ------------------------

   function Max_Timer_Interval return Timer_Interval is
     (Timer_Interval'Last - 1);

   -----------------------
   -- Initialize_Timers --
   -----------------------

   procedure Initialize_Timers is
   begin
      --  It is important to initialize the software LSP with the value coming
      --  from the hardware. There is no guarantee that this hardware value is
      --  close to zero (it may have been initialized by monitor software with
      --  any value and at any moment in time). With this initialization we
      --  ensure that the value in the software LSP is less than a period away
      --  from the actual value in hardware).
      Software_Clock.LSP := Clock_Interval (Read_Clock);

   end Initialize_Timers;

   ----------------
   -- Read_Clock --
   ----------------

   function Read_Clock return Time is
      PRIMASK : Word;
      Flag    : Boolean;
      Count   : Timer_Interval;
      Res     : Timer_Interval;

   begin
      --  As several registers and variables need to be read or modified, do
      --  it atomically.

      Machine_Code.Asm ("mrs %0, PRIMASK",
                        Outputs => Word'Asm_Output ("=&r", PRIMASK),
                        Volatile => True);
      Machine_Code.Asm ("msr PRIMASK, %0",
                        Inputs  => Word'Asm_Input  ("r", 1),
                        Volatile => True);

      --  We must read the counter register before the flag
      Count := Timer_Interval (STK_Periph.VAL.CURRENT);

      --  If we read the flag first, a reload can occur just after the read
      --  and the count register would wrap around. We'd end up with a Count
      --  value close to the Tick_Period value but a flag at zero and
      --  therefore miss the reload and return a wrong clock value.

      --  This flag is set when the counter has reached zero. Next_Tick_Time
      --  has to be incremented. This will trigger an interrupt very soon
      --  (or has just triggered the interrupt), so count is either zero or
      --  not far from Tick_Period.

      Flag := STK_Periph.CTRL.COUNTFLAG;

      if Flag then
         --  Systick counter has just reached zero, pretend it is still zero

         --  This function is called by the interrupt handler that is
         --  executed when the counter reaches zero. Therefore, we signal
         --  that the next interrupt will happen within a period. Note that
         --  reading the Control and Status register (SYST_CSR) clears the
         --  COUNTFLAG bit, so even if we have sequential calls to this
         --  function, the increment of Next_Tick_Time will happen only
         --  once.

         Res := Next_Tick_Time;
         Next_Tick_Time := Next_Tick_Time + Tick_Period;

      else
         --  The counter is decremented, so compute the actual time
         Res := Next_Tick_Time - Count;
      end if;

      --  Restore interrupt mask
      Machine_Code.Asm ("msr PRIMASK, %0",
                        Inputs => Word'Asm_Input ("r", PRIMASK),
                        Volatile => True);

      return Time (Res);
   end Read_Clock;

   ------------------
   -- Update_Clock --
   ------------------

   --  Must be called from within Kernel (interrupts disabled).

   procedure Update_Clock is
      Update_MSP : constant Clock_Periods := Software_Clock.MSP;
      Update_LSP : constant Clock_Interval := Software_Clock.LSP;
      Now_LSP    : constant Clock_Interval := Clock_Interval (Read_Clock);
      Now_MSP    : Clock_Periods;

   begin
      if Now_LSP < Update_LSP then
         Now_MSP := Update_MSP + 1;

         --  Need to do "atomic" update of both parts of the clock

         --  Mark Software_Clock.MSP as invalid during updates. The read
         --  protocol is to read Software_Clock.MSP both before and after
         --  reading Software_Clock.LSP. Only consider the MSP as that
         --  belonging to the LSP if both values are the same and not equal
         --  to the special Update_In_Progress value.

         Software_Clock.LSP := Now_LSP;
         Software_Clock.MSP := Now_MSP;

      else
         --  Only need to change the LSP, so we can do this atomically
         Software_Clock.LSP := Now_LSP;
      end if;
   end Update_Clock;

   -----------
   -- Clock --
   -----------

   function Clock return Time is
      First_MSP  : Clock_Periods;
      Before_MSP : Clock_Periods;
      Before_LSP : Clock_Interval;
      Now_LSP    : Clock_Interval;
      After_MSP  : Clock_Periods;

   begin
      --  Reading the clock needs to access to the software and the hardware
      --  clock. In a multiprocessor, masking interrupts is not enough because
      --  the software clock can be updated by another processor. Therefore, we
      --  keep reading until we get a consistent value (no updates of the
      --  software MSP while we read the hardware clock).

      --  We can limit the iterations in the loop to 3. In the worst case, if
      --  the MSP keeps increasing within the loop, it means that we are
      --  spending an extremely long time in this function (we get preempted
      --  all the time). If the first time we read 1, and then the MSP gets
      --  increased, we know that the time is between 1 & X and 2 & X (because
      --  the software clock can be behind the actual time by at most one
      --  hardware clock period). It means that the actual time when we entered
      --  this function was before 3 & 0. In the second iteration we can read
      --  2 and then get increased again. Hence actual time is between 2 & X
      --  and 3 & X. Hence, the actual time when we leave function clock is at
      --  least 2 & 0. However, we do not know when between 2 & 0 and 3 & 0.
      --  Hence we read a third time, and if we read 3 and then a change, it
      --  means that the actual time is between 3 & X and 4 & X (so at least
      --  3 & 0). Hence, at the end of the third iteration, we can return 3 & 0
      --  as a safe value that is between the beginning and end of the
      --  execution of this call to Clock.

      for Iteration in 1 .. 3 loop

         Before_MSP := Software_Clock.MSP;
         --  Before_MSP cannot be equal to Update_In_Progress because the
         --  update is done atomically.

         Before_LSP := Software_Clock.LSP;

         Now_LSP := Clock_Interval (Read_Clock);

         After_MSP := Software_Clock.MSP;

         --  If the MSP in Software_Clock has changed (or is changing), we
         --  do not know the time at which the software clock was updated. It
         --  is important to note that the implementation does not force the
         --  software clock to be updated at a time close to the LSP wraparound
         --  (it needs to be done at least once per hardware clock period, but
         --  we do not know when). Hence, returning (Before_MSP + 1) & 0 is
         --  not correct because the updated LSP in the Software_Clock does
         --  not need to be close to zero.

         --  Normal case, no updates in MSP

         if Before_MSP = After_MSP then

            --  If we know the value of the software clock at the time of the
            --  read of the hardware clock, we know the time of that read,
            --  because the software clock can never be more than one period
            --  behind. Hence, we build a Time value from two consecutive
            --  readings of the hardware clock (Before_LSP and Now_LSP) and one
            --  reading of the MSP from the Software_Clock (and we know that
            --  the MSP did not change between the two readings of Before_LSP
            --  and Now_LSP).

            return
              Before_MSP + (if Now_LSP < Before_LSP then 1 else 0) & Now_LSP;

            --  After the first unsuccessful iteration we store the first MSP
            --  value read to have a reference of the initial time when we
            --  entered the clock function (before First_MSP + 2 & 0).

         elsif Iteration = 1 then
            First_MSP := Before_MSP;

            --  During the second or third iteration, if the clock has been
            --  increased by two or more then Before_MSP & 0 is certainly within
            --  the beginning and end of the execution of this call to Clock.

         elsif Before_MSP - First_MSP >= 2 then
            exit;
         end if;
      end loop;

      pragma Assert (Before_MSP - First_MSP >= 2);

      return Before_MSP & 0;
   end Clock;

   -----------
   -- Epoch --
   -----------

   function Epoch return Time is
   begin
      return Periods_In_Epoch & 0;
   end Epoch;

   ---------------------
   -- SysTick_Handler --
   ---------------------

   procedure SysTick_Handler is
   begin
      Int.Disable_Interrupts;

      --  Actualize value of MSP & LSP of software clock.
      Update_Clock;

      Int.Enable_Interrupts;
   end SysTick_Handler;

end SYS.Real_Time;
