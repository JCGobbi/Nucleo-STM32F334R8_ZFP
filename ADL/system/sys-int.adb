--  This version is for ARM bareboard targets using the ARMv7-M targets,
--  which only use Thumb2 instructions.

with System.Machine_Code;

with STM32_SVD.SCB;            use STM32_SVD.SCB;
with STM32_SVD.NVIC;           use STM32_SVD.NVIC;
                               use STM32_SVD;
with STM32_SVD.STK;            use STM32_SVD.STK;

package body SYS.Int is

   NL : constant String := ASCII.LF & ASCII.HT;
   --  New line separator in Asm templates

   Has_VTOR : constant Boolean := True;
   --  Set True if the core has a Vector Table Offset Register (VTOR).
   --  VTOR is implemented in armv7-m architecture or Cortex-M0+, Cortex_M4
   --  and above.

   --  Has_OS_Extensions : constant Boolean := True;
   --  Set True if the core implements the armv6-m OS extensions (PendSV,
   --  MSP, PSP etc.). The OS extensions are optional for the Cortex-M1.

   --  Is_ARMv6m : constant Boolean := False;
   --  Set True if the core is an armv6-m architecture (Cortex-M0, Cortex-M0+,
   --  Cortex-M1).

   System_Vectors : constant System.Address;
   pragma Import (Asm, System_Vectors, "__vectors");

   --------------------
   -- Initialize_CPU --
   --------------------

   procedure Initialize_CPU is

      VTOR : Address with Volatile, Address => SCB_Periph.VTOR'Address;
      --  16#E000_ED08#; -- Vector Table Offset Register
   begin

      if Has_VTOR then
         --  Initialize vector table offset
         VTOR := System_Vectors'Address;
      end if;

      --  Set configuration: stack is 8 byte aligned, trap on divide by 0,
      --  no trap on unaligned access, can enter thread mode from any level.
      SCB_Periph.CCR.STKALIGN := True;
      SCB_Periph.CCR.DIV_0_TRP := True;
      SCB_Periph.CCR.UNALIGN_TRP := False;
      SCB_Periph.CCR.NONBASETHRDENA := True;

      --  Enable usage, bus and memory management faults
      SCB_Periph.SHCSR.USGFAULTENA := True;
      SCB_Periph.SHCSR.BUSFAULTENA := True;
      SCB_Periph.SHCSR.MEMFAULTENA := True;

      --  Unmask Fault
      Machine_Code.Asm (Template => "cpsie f", Volatile => True);

   end Initialize_CPU;

   ------------------------------
   -- Enable_Interrupt_Request --
   ------------------------------

   procedure Enable_Interrupt_Request (Interrupt : Interrupt_ID)
   is
   begin
      if Interrupt = Alarm_Interrupt_ID then
         --  Clear alarm (SysTick) interrupt
         SCB_Periph.ICSR.PENDSTCLR := True;
         --  Enable alarm (SysTick) interrupt
         STK_Periph.CTRL.TICKINT := True;
      else
         declare
            pragma Assert (Interrupt >= 0);
            IRQ    : constant Natural := Interrupt;
            Regofs : constant Natural := IRQ / 32; --  register offset
            Regbit : constant Word := 2** (IRQ mod 32);  -- bit offset
            NVIC_ISER : array (0 .. 15) of Word
              with Volatile, Address => NVIC_Periph.ISER0'Address;

            --  Many NVIC registers use 16 words of 32 bits each to serve as a
            --  bitmap for all interrupt channels. Regofs indicates register
            --  offset (0 .. 15), and Regbit indicates the mask required for
            --  addressing the bit.

         begin
            NVIC_ISER (Regofs) := Regbit; --  Set enable register
         end;
      end if;
   end Enable_Interrupt_Request;

   -------------------------------
   -- Disable_Interrupt_Request --
   -------------------------------

   procedure Disable_Interrupt_Request (Interrupt : Interrupt_ID)
   is
   begin
      if Interrupt = Alarm_Interrupt_ID then
         --  Clear alarm (SysTick) interrupt
         SCB_Periph.ICSR.PENDSTCLR := True;
         --  Disable alarm (SysTick) interrupt
         STK_Periph.CTRL.TICKINT := False;
      else
         declare
            pragma Assert (Interrupt >= 0);
            IRQ       : constant Natural := Interrupt;
            Regofs    : constant Natural := IRQ / 32; --  register offset
            Regbit    : constant Word := 2** (IRQ mod 32);  -- bit offset
            NVIC_ICER : array (0 .. 15) of Word
              with Volatile, Address => NVIC_Periph.ICER0'Address;
            NVIC_ICPR : array (0 .. 15) of Word
              with Volatile, Address => NVIC_Periph.ICPR0'Address;

            --  Many NVIC registers use 16 words of 32 bits each to serve as a
            --  bitmap for all interrupt channels. Regofs indicates register
            --  offset (0 .. 15), and Regbit indicates the mask required for
            --  addressing the bit.

         begin
            NVIC_ICPR (Regofs) := Regbit; --  Clear pending register
            NVIC_ICER (Regofs) := Regbit; --  Clear enable register
         end;
      end if;
   end Disable_Interrupt_Request;

   -----------------------
   -- Enable_Interrupts --
   -----------------------

   procedure Enable_Interrupts is
   begin
      --  Enabling interrupts will cause any pending interrupts to take
      --  effect. The instruction barrier is required by the architecture
      --  to ensure subsequent instructions are executed with interrupts
      --  enabled and at the right hardware priority level.

      Machine_Code.Asm
        (Template => "cpsie i" & NL & "dsb" & NL & "isb",
         Clobber  => "memory",
         Volatile => True);
   end Enable_Interrupts;

   ------------------------
   -- Disable_Interrupts --
   ------------------------

   procedure Disable_Interrupts is
   begin
      Machine_Code.Asm (Template => "cpsid i", Volatile => True);
   end Disable_Interrupts;

   ----------------
   -- Power_Down --
   ----------------

   procedure Power_Down is
   begin
      Machine_Code.Asm (Template => "wfi", Volatile => True);
   end Power_Down;

   -----------
   -- Traps --
   -----------

   Reset_Vector             : constant Vector_Id :=  1;
   NMI_Vector               : constant Vector_Id :=  2;
   Hard_Fault_Vector        : constant Vector_Id :=  3;
   --  Mem_Manage_Vector    : constant Vector_Id :=  4; --  Never referenced
   Bus_Fault_Vector         : constant Vector_Id :=  5;
   Usage_Fault_Vector       : constant Vector_Id :=  6;
   SV_Call_Vector           : constant Vector_Id := 11;
   --  Debug_Mon_Vector     : constant Vector_Id := 12; --  Never referenced
   Pend_SV_Vector           : constant Vector_Id := 14;
   --  Sys_Tick_Vector      : constant Vector_Id := 15;

   ------------------------
   -- GNAT_Error_Handler --
   ------------------------

   procedure GNAT_Error_Handler (Trap : Vector_Id) is
   begin
      case Trap is
         when Reset_Vector =>
            raise Program_Error with "unexpected reset";
         when NMI_Vector =>
            raise Program_Error with "non-maskable interrupt";
         when Hard_Fault_Vector =>
            raise Program_Error with "hard fault";
         when Bus_Fault_Vector  =>
            raise Program_Error with "bus fault";
         when Usage_Fault_Vector =>
            raise Constraint_Error with "usage fault";
         when others =>
            raise Program_Error with "unhandled trap";
      end case;
   end GNAT_Error_Handler;

   -------------------
   -- Reset_Handler --
   -------------------

   --  procedure Reset_Handler is
   --  begin
   --     GNAT_Error_Handler (Reset_Vector);
   --  end Reset_Handler;

   -----------------
   -- NMI_Handler --
   -----------------

   procedure NMI_Handler is
   begin
      GNAT_Error_Handler (NMI_Vector);
   end NMI_Handler;

   ------------------------
   -- Hard_Fault_Handler --
   ------------------------

   procedure Hard_Fault_Handler is
   begin
      GNAT_Error_Handler (Hard_Fault_Vector);
   end Hard_Fault_Handler;

   -----------------------
   -- Bus_Fault_Handler --
   -----------------------

   procedure Bus_Fault_Handler is
   begin
      GNAT_Error_Handler (Bus_Fault_Vector);
   end Bus_Fault_Handler;

   -------------------------
   -- Usage_Fault_Handler --
   -------------------------

   procedure Usage_Fault_Handler is
   begin
      GNAT_Error_Handler (Usage_Fault_Vector);
   end Usage_Fault_Handler;

   ---------------------
   -- SV_Call_Handler --
   ---------------------

   procedure SV_Call_Handler is
   begin
      GNAT_Error_Handler (SV_Call_Vector);
   end SV_Call_Handler;

   ---------------------
   -- Pend_SV_Handler --
   ---------------------

   procedure Pend_SV_Handler is
   begin
      GNAT_Error_Handler (Pend_SV_Vector);
   end Pend_SV_Handler;

end SYS.Int;
