pragma Restrictions (No_Task_Hierarchy);

with SYS.CPU_Clock; use SYS;
with STM_Board;     use STM_Board;

procedure Test_LED is
   I : Integer := 0;
begin

   --  Configure the CPU clock from HSI clock (8 MHz) to HSE + PLL (72 MHz).
   --  If the two instructions bellow are disabled, the LED will flash with
   --  ~1 second period, otherwise it will flash 9 times faster.
   CPU_Clock.Reset_Clocks;
   CPU_Clock.Initialize_Clocks;

   --  Initialize GPIO ports
   Initialize_GPIO;

   --  Enter steady state
   loop
      Set_Toggle (Green_LED);
      while I < 360000 loop
         I := I + 1;
      end loop;
      I := 0;
   end loop;

end Test_LED;
