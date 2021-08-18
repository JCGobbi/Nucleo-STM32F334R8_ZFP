pragma Restrictions (No_Task_Hierarchy);

with SYS.CPU_Clock; use SYS;
with SYS.Real_Time; use SYS.Real_Time;
with STM_Board;     use STM_Board;

procedure Test_LED_RT is
begin

   --  Configure the CPU clock
   --  Change from HSI clock (8 MHz) to HSE + PLL (72 MHz)
   CPU_Clock.Reset_Clocks;
   CPU_Clock.Initialize_Clocks (HSE_Enabled  => True,
                                Activate_PLL => True);

   --  Initialize the SysTick downcounter timer
   Initialize_SysTick;
   Initialize_Timers;

   --  Initialize GPIO ports
   Initialize_GPIO;

   --  Enter steady state
   loop
      Set_Toggle (Green_LED);
      Delay_Until (Clock + Seconds (3));
   end loop;

end Test_LED_RT;
