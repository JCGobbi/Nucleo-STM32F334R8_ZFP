with STM32.Device;  use STM32;

with Sys.CPU_Clock; use Sys;
with Sys.Int.Names;
with Sys.Real_Time; use Sys.Real_Time;

with STM_Board;     use STM_Board;
with Inverter_ADC;  use Inverter_ADC;
with Inverter_PWM;  use Inverter_PWM;

package body Startup is

   --  procedure Wait_Until_V_Battery;
   --  Wait until battery voltage is between minimum and maximum.
   --  Enable this routine when the hardware is connected to ADC.

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      --  Perform some basic hardware initialization (clock, timer, and
      --  interrupt handlers).

      --  Configure the CPU clock
      --  Change from HSI clock (8 MHz) to HSE + PLL (72 MHz)
      CPU_Clock.Reset_Clocks;
      CPU_Clock.Initialize_Clocks;

      --  Enable global interrupt
      Int.Enable_Interrupts;

      --  Enable NVIC interrupts
      Int.Enable_Interrupt_Request (Int.Names.TIM1_UP_TIM16_Interrupt);
      --  Enable PWM_Interrupt ID (TIM1 Update interrupt);

      Int.Enable_Interrupt_Request (Int.Names.EXTI15_10_Interrupt);
      --  Enable Button interrupt ID;

      Int.Enable_Interrupt_Request (Int.Names.ADC1_2_Interrupt);
      --  Enable ADC interrupt ID;

      --  For testing the timer (Sensor_Timer) that starts ADC conversions.
      --  This is not needed in the final project.
      --  Int.Enable_Interrupt_Request (Int.Names.TIM3_Interrupt);
      --  Enable sensor timer interrupt ID;

      --  Then the CPU (which set interrupt stack pointer)
      Int.Initialize_CPU;

      --  Then the devices
      Real_Time.Initialize_SysTick;
      Real_Time.Initialize_Timers;

   end Initialize;

   -------------------------
   -- Initialize_Inverter --
   -------------------------

   procedure Initialize_Inverter is
   begin
      --  Initialize GPIO ports
      Initialize_GPIO;

      --  Select the AC frequency of the inverter
      if Read_Input (AC_Frequency_Pin) then -- 50 Hz
         PWM_Frequency_Hz := 25_000.0;
      else -- 60 Hz
         PWM_Frequency_Hz := 30_000.0;
      end if;

      --  Select gain = 1.0 to see only sine table sinusoid
      Set_Sine_Gain (1.0);

      --  Initialize sensors ADC
      Initialize_ADC;

      --  Do not start while the battery voltage is outside maximum and minimum
      --  Wait_Until_V_Battery;

      --  Set PWM generator (TIM1) clock source to 144 MHz
      Device.Select_Clock_Source (PWM_Timer, Device.PLLCLK);

      --  Disable PWM gate drivers because some gate drivers enable with
      --  low level.
      Set_PWM_Gate_Power (False);

      --  Initialize PWM generator
      Initialize_PWM (Frequency => PWM_Frequency_Hz,
                      Deadtime  => PWM_Deadtime,
                      Alignment => Center);

      Initialized :=
         STM_Board.Is_Initialized and
         Inverter_ADC.Is_Initialized and
         Inverter_PWM.Is_Initialized;

   end Initialize_Inverter;

   --------------------
   -- Start_Inverter --
   --------------------

   procedure Start_Inverter is
   begin
      --  Test if all peripherals are correctly initialized
      while not Initialized  loop
         Set_Toggle (Green_LED);
         Delay_Until (Clock + Seconds (1));
      end loop;

      --  Enable PWM gate drivers
      Set_PWM_Gate_Power (True);

      --  Start generating the sinusoid
      Start_PWM;

   end Start_Inverter;

   --------------------------
   -- Wait_Until_V_Battery --
   --------------------------

   --  procedure Wait_Until_V_Battery is
   --     Period : constant Time_Span := Milliseconds (1);
   --     Next_Release : Time := Clock;
   --     Counter : Integer := 0;
   --  begin
   --     loop
   --        exit when Test_V_Battery;
   --        Next_Release := Next_Release + Period;
   --        Delay_Until (Next_Release);
   --        Counter := Counter + 1;
   --        if (Counter > 1_000) then
   --           Set_Toggle (Red_LED);
   --           Counter := 0;
   --        end if;
   --     end loop;
   --     Turn_Off (Red_LED);
   --  end Wait_Until_V_Battery;

   --------------------
   -- Is_Initialized --
   --------------------

   function Is_Initialized return Boolean is
   begin
      return Initialized;
   end Is_Initialized;

end Startup;
