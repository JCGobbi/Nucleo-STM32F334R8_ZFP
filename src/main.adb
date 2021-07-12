pragma Restrictions (No_Task_Hierarchy);

with SYS.Real_Time; use SYS.Real_Time;
with STM_Board;     use STM_Board;
with Startup;

with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

procedure Main is
begin

   --  Set CPU clock and global and NVIC interrupts
   StartUp.Initialize;

   --  Start-up GPIOs, ADCs, Timer and PWM
   StartUp.Initialize_Inverter;

   StartUp.Start_Inverter;

   --  Enter steady state
   loop
      --  null;
      Set_Toggle (Green_LED);
      Delay_Until (Clock + Seconds (2));
   end loop;

end Main;
