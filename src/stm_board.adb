package body STM_Board is

   ---------------------
   -- Initialize_GPIO --
   ---------------------

   procedure Initialize_GPIO is
      Configuration  : GPIO_Port_Configuration;
      All_PP_Outputs : constant GPIO_Points :=
        (Green_LED, Buzzer);
      All_PP_Inputs  : constant GPIO_Points :=
        (AC_Frequency_Pin, Button);
   begin
      --  Output LEDs and buzzer pins
      Enable_Clock (All_PP_Outputs);
      Configuration := (Mode        => Mode_Out,
                        Output_Type => Push_Pull,
                        Speed       => Speed_100MHz,
                        Resistors   => Floating);
      Configure_IO (All_PP_Outputs, Configuration);

      --  Output gate driver pin. This depends on the electronic circuit.
      --  If the driver already has a pull-up resistor, then it is open-drain.
      Enable_Clock (PWM_Gate_Power);
      Configuration := (Mode        => Mode_Out,
                        Output_Type => Open_Drain,
                        Speed       => Speed_100MHz,
                        Resistors   => Floating);
      Configure_IO (PWM_Gate_Power, Configuration);

      --  Input frequency pin. This depends on the electronic circuit. If
      --  the pin already has pull-up resistor, then it is floating.
      Enable_Clock (All_PP_Inputs);
      Configuration := (Mode      => Mode_In,
                        Resistors => Floating);
      Configure_IO (All_PP_Inputs, Configuration);

      --  Connect the button's pin to the External Interrupt Handler
      Configure_Trigger (Button, Trigger => Interrupt_Falling_Edge);

      Initialized := True;
   end Initialize_GPIO;

   ----------------
   -- Read_Input --
   ----------------

   function Read_Input (This : GPIO_Point) return Boolean is
     (not This.Set);

   -------------
   -- Turn_On --
   -------------

   procedure Turn_On (This : in out GPIO_Point) is
   begin
      Set (This);
   end Turn_On;

   --------------
   -- Turn_Off --
   --------------

   procedure Turn_Off (This : in out GPIO_Point) is
   begin
      Clear (This);
   end Turn_Off;

   ----------------
   -- Set_Toggle --
   ----------------

   procedure Set_Toggle (This : in out GPIO_Point) is
   begin
      Toggle (This);
   end Set_Toggle;

   ------------------
   -- All_LEDs_Off --
   ------------------

   procedure All_LEDs_Off is
   begin
      Clear (All_LEDs);
   end All_LEDs_Off;

   -----------------
   -- All_LEDs_On --
   -----------------

   procedure All_LEDs_On is
   begin
      Set (All_LEDs);
   end All_LEDs_On;

   -----------------
   -- Toggle_LEDs --
   -----------------

   procedure Toggle_LEDs (These : in out GPIO_Points) is
   begin
      Toggle (These);
   end Toggle_LEDs;

   --------------------
   -- Is_Initialized --
   --------------------

   function Is_Initialized
      return Boolean is (Initialized);

   --------------------
   -- Button_Handler --
   --------------------

   procedure Button_Handler is
      I : Integer := 0;
   begin
      if External_Interrupt_Pending (Button_EXTI_Line) then
         -- Debouce
         while I < 360000 loop
            I := I + 1;
         end loop;

         -- Key pressed => GPIO = 0; not pressed => GPIO = 1.
         if not Button.Set then
            Set_Toggle (Green_LED);
         end if;

         --  Clear the raised interrupt by writing "Occurred" to the correct
         --  position in the EXTI Pending Register.
         Clear_External_Interrupt (Button_EXTI_Line);
      end if;

   end Button_Handler;

end STM_Board;
