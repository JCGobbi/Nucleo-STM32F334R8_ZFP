--  Package in charge of implementing clock and timer functionalities

pragma Restrictions (No_Elaboration_Code);
--  The kernel initialization routine needs to execute before elaboration.
--  Consequently, packages used by this code cannot require elaboration.

with System;
with Sys.CPU_Clock;

package Sys.Real_Time with
  SPARK_Mode,
  Abstract_State => (Clock_Time with Synchronous),
  Initializes    => Clock_Time
is
   --  This file has definitions and routines from the following files:
   --  s-bbtime, s-bbcppr, s-bbbosu, a-reatim

   ----------
   -- Time --
   ----------

   type Word is mod 2**System.Word_Size;

   Ticks_Per_Second : constant Integer := Sys.CPU_Clock.Main_Clock_Frequency;
   --  Number of clock ticks per second,
   --  May be extracted from STM32.Devices.System_Clock_Frequencies.HCLK.

   pragma Assert (Ticks_Per_Second >= 50_000,
      "Ada RM D.8 (30) requires " &
      "that Time_Unit shall be less than or equal to 20 microseconds");

   type Time is private;
   Time_First : constant Time;
   Time_Last  : constant Time;

   Time_Unit : constant Float := 1.0 / Float (Ticks_Per_Second);
   --  The BB platforms use a time stamp counter driven by the system clock,
   --  where the duration of the clock tick (Time_Unit) depends on the speed
   --  of the underlying hardware. The system clock frequency is used here to
   --  determine Time_Unit.

   type Time_Span is private;
   Time_Span_First : constant Time_Span;
   Time_Span_Last  : constant Time_Span;

   Tick : constant Time_Span;

   type Timer_Interval is mod 2 ** 32;
   for Timer_Interval'Size use 32;
   --  This type represents any interval that we can measure within a
   --  Clock_Interrupt_Period. Even though this type is always 32 bits, its
   --  actual allowed range is 0 .. Max_Timer_Interval, which may be less,
   --  depending on the target.

   --  As ARMv7M does not directly provide a single-shot alarm timer, and
   --  we have to use Sys_Tick for that, we need to have this clock generate
   --  interrupts at a relatively high rate. To avoid unnecessary overhead
   --  when no alarms are requested, we'll only call the alarm handler if
   --  the current time exceeds the Alarm_Time by at most half the modulus
   --  of Timer_Interval.

   function "<"  (Left, Right : Time) return Boolean
     with Global => null;
   function "<=" (Left, Right : Time) return Boolean
     with Global => null;
   function ">"  (Left, Right : Time) return Boolean
     with Global => null;
   function ">=" (Left, Right : Time) return Boolean
     with Global => null;

   function "<"  (Left, Right : Time_Span) return Boolean
     with Global => null;
   function "<=" (Left, Right : Time_Span) return Boolean
     with Global => null;
   function ">"  (Left, Right : Time_Span) return Boolean
     with Global => null;
   function ">=" (Left, Right : Time_Span) return Boolean
     with Global => null;

   function "+" (Left : Time; Right : Time_Span) return Time
     with Global => null;
   function "-" (Left : Time; Right : Time_Span) return Time
     with Global => null;
   function "-" (Left, Right : Time) return Time_Span
     with Global => null;

   function "+" (Left : Time_Span; Right : Time) return Time is
     (Right + Left)
     with Global => null;

   function "+" (Left, Right : Time_Span) return Time_Span
     with Global => null;
   function "-" (Left, Right : Time_Span) return Time_Span
     with Global => null;
   function "-" (Right : Time_Span) return Time_Span
     with Global => null;
   function "*" (Left : Time_Span; Right : Integer) return Time_Span
     with Global => null;
   function "*" (Left : Integer; Right : Time_Span) return Time_Span
     with Global => null;
   function "/" (Left, Right : Time_Span) return Integer
     with Global => null;
   function "/" (Left : Time_Span; Right : Integer) return Time_Span
     with Global => null;

   function "abs" (Right : Time_Span) return Time_Span
     with Global => null;

   function Nanoseconds  (NS : Integer) return Time_Span
     with Global => null;

   function Microseconds (US : Integer) return Time_Span
     with Global => null;

   function Milliseconds (MS : Integer) return Time_Span
     with Global => null;

   function Seconds (S : Integer) return Time_Span
     with Global => null;
   pragma Ada_05 (Seconds);

   function Minutes (M : Integer) return Time_Span
     with Global => null;
   pragma Ada_05 (Minutes);

   procedure Delay_Until (T : Time);
   --  Suspend the calling thread until the absolute time specified by T

   procedure Initialize_SysTick;
   --  Procedure that performs the hardware initialization of the SysTick
   --  counter. Should be called before any other operations in this package.

   function Max_Timer_Interval return Timer_Interval;
   pragma Inline (Max_Timer_Interval);
   --  The maximum value of the hardware clock. The is the maximum value
   --  that Read_Clock may return, and the longest interval that Set_Alarm
   --  may use. The hardware clock period is Max_Timer_Interval + 1 clock
   --  ticks. An interrupt occurs after this number of ticks.

   procedure Initialize_Timers;
   --  Initialize this package (clock and alarm handlers). Must be called
   --  before any other functions.

   function Read_Clock return Time;
   --  Read the value contained in the clock hardware counter, and return
   --  the number of ticks elapsed since the last clock interrupt, that is,
   --  since the clock counter was last reloaded.

   procedure Update_Clock;
   --  This procedure has to be executed at least once each period of the
   --  hardware clock. We also require that this procedure be called with
   --  interrupts disabled, to ensure no stale values will be written. Given
   --  that limitation, it is fine to do concurrent updates on SMP systems:
   --  no matter which update ultimately prevails, it can't be old. While, on
   --  SMP systems, the Period_Counter may not always be monotone, the time
   --  returned by Update_Clock and Clock is.

   function Clock return Time with
     Volatile_Function,
     Global => Clock_Time;
   --  Get the number of ticks elapsed since startup

   function Epoch return Time;
   --  Get the reference startup time

private
   pragma SPARK_Mode (Off);

   type Time is mod 2 ** 64;
   for Time'Size use 64;
   --  Representation of the time in the underlying tasking system

   Time_First : constant Time := Time'First;
   Time_Last  : constant Time := Time'Last;

   ------------------
   -- Time keeping --
   ------------------

   --  Time is represented at this level as a 64-bit unsigned number. We assume
   --  that the Board_Support.Read_Clock function provides access to a hardware
   --  clock with a resolution of 20 microseconds or better, counting from
   --  0 to Board_Support.Max_Timer_Interval over a period of at least 0.735
   --  seconds, and returning a value of the 32-bit Timer_Interval type. The
   --  clock resolution should be an integral number of nanoseconds between 1
   --  and 20_000.

   --  The Time package uses these facilities to keep a 64-bit clock that will
   --  allow a program to keep track of up to 50 years in the future without
   --  having the most significant bit set. This means it is always safe to
   --  subtract two Clock readings to determine a Time_Span without overflow.

   --  We need to support a clock running for 50 years, so this requires
   --  a hardware clock period of at least 1_577_880_000 / 2**31 or 0.735
   --  seconds. As comparison, a LEON2 at 80 MHz with 24-bit clock and the
   --  minimum prescale factor of 4, has a period of 2**24 / (80E6 / 4) = 0.839
   --  seconds, while a 200 MHz LEON3 has a period of 2**32 / (200E6 / 5) =
   --  107 seconds. For faster clocks or smaller clock width, higher prescaler
   --  values may be needed to achieve 50 year run time. The prescale factor
   --  should be chosen such that the period between clock ticks is an integral
   --  number of nanoseconds between 1 and 20_000.

   type Time_Span is range -2 ** 63 .. 2 ** 63 - 1;
   for Time_Span'Size use 64;
   --  Time_Span represents the length of time intervals, and it is defined as
   --  a 64-bit signed integer.

   Time_Span_First : constant Time_Span := Time_Span'First;
   Time_Span_Last  : constant Time_Span := Time_Span'Last;

   Time_Span_Zero  : constant Time_Span := 0;
   Time_Span_Unit  : constant Time_Span := 1;

   Tick : constant Time_Span := 1;

   pragma Import (Intrinsic, "<");
   pragma Import (Intrinsic, "<=");
   pragma Import (Intrinsic, ">");
   pragma Import (Intrinsic, ">=");
   pragma Import (Intrinsic, "abs");

   pragma Inline (Clock);
   pragma Inline (Epoch);

   pragma Inline (Microseconds);
   pragma Inline (Milliseconds);
   pragma Inline (Nanoseconds);
   pragma Inline (Seconds);
   pragma Inline (Minutes);

   procedure SysTick_Handler;
   pragma Export (Asm, SysTick_Handler, "SysTick_Handler");

end Sys.Real_Time;
