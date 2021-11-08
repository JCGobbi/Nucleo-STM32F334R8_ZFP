pragma Restrictions (No_Task_Hierarchy);

with STM32.Device;  use STM32;

with SYS.CPU_Clock; use SYS;
with SYS.Real_Time; use SYS.Real_Time;
with SYS.Int.Names;

with STM_Board;     use STM_Board;
with Inverter_PWM;  use Inverter_PWM;

with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

procedure Demo_Inverter is
   --  This demonstration program only initializes the GPIOs and PWM timer and
   --  presents on the output of the full-bridge a sinusoidal wave of 60 Hz.
   --  There is no initialization for ADC and timer, so there is no analog
   --  monitoring.

begin

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

   --  Initialize the SysTick downcounter timer
   Initialize_SysTick;
   Initialize_Timers;

   --  Set TIM1 clock source to 144 MHz
   Device.Write_Clock_Source (PWM_Timer, Device.PLLCLK);

   --  Initialize GPIO ports
   Initialize_GPIO;

   --  Select the AC frequency of the inverter
   PWM_Frequency_Hz := 30_000.0;

   --  Select gain = 1.0 to see only sine table sinusoid
   Sine_Gain := 1.0;

   --  Disable PWM gate drivers because some gate drivers enable with
   --  low level.
   Set_PWM_Gate_Power (False);

   --  Initialize PWM generator
   Initialize_PWM (Frequency => PWM_Frequency_Hz,
                   Deadtime  => PWM_Deadtime,
                   Alignment => Center);

   --  Test if all peripherals are correctly initialized
   while not (STM_Board.Is_Initialized and Inverter_PWM.Is_Initialized) loop
      Set_Toggle (Green_LED);
      Delay_Until (Clock + Seconds (3));
   end loop;

   --  Enable PWM gate drivers
   Set_PWM_Gate_Power (True);

   --  Start generating the sinusoid
   Start_PWM;

   --  Enter steady state
   loop
      --  null;
      Set_Toggle (Green_LED);
      Delay_Until (Clock + Seconds (2));
   end loop;

end Demo_Inverter;
