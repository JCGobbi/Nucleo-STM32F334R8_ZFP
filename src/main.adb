pragma Restrictions (No_Task_Hierarchy);

with Sys.Real_Time; use Sys.Real_Time;
with STM_Board;     use STM_Board;
with Startup;

with Last_Chance_Handler; pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

procedure Main is
begin

   --  Set CPU clock and global and NVIC interrupts
   Startup.Initialize;

   --  Start-up GPIOs, ADCs, Timer and PWM
   Startup.Initialize_Inverter;

   Startup.Start_Inverter;

   --  Enter steady state
   loop
      Set_Toggle (Green_LED);
      Delay_Until (Clock + Seconds (2));
   end loop;

end Main;
