with STM32.Device; use STM32.Device;
with STM32.Timers; use STM32.Timers;

package body Inverter_ADC is

   procedure Initialize_ADC_Timer;
   --  Initialize the timer to start ADCs convertions.

   --------------------
   -- Initialize_ADC --
   --------------------

   procedure Initialize_ADC is

      All_Regular_Conversions : constant Regular_Channel_Conversions :=
        (1 => (Channel     => ADC_Battery_V_Point.Channel,
               Sample_Time => Sample_19P5_Cycles),
         2 => (Channel     => ADC_Battery_I_Point.Channel,
               Sample_Time => Sample_19P5_Cycles),
         3 => (Channel     => ADC_Output_V_Point.Channel,
               Sample_Time => Sample_19P5_Cycles));

   begin

      --  Initialize GPIO for analog input
      for Reading of ADC_Reading_Settings loop
         STM32.Device.Enable_Clock (Reading.GPIO_Entry);
         Reading.GPIO_Entry.Configure_IO
           (Config => GPIO_Port_Configuration'(Mode   => Mode_Analog,
                                               others => <>));
      end loop;

      --  Initialize ADC mode
      Enable_Clock (Sensor_ADC.all);
      Reset_All_ADC_Units;

      Configure_Common_Properties
        (Mode           => Independent,
         Clock_Mode     => PCLK2_Div_2,
         DMA_Mode       => Disabled,
         Sampling_Delay => Sampling_Delay_5_Cycles);  --  arbitrary

      --  Enable the used ADCs to configure conversions.
      Enable (Sensor_ADC.all);

      Configure_Unit
        (Sensor_ADC.all,
         Resolution => ADC_Resolution_12_Bits,
         Alignment  => Right_Aligned);

      --  Conversions are triggered by Sensor Timer.
      Configure_Regular_Conversions
        (Sensor_ADC.all,
         Continuous  => False, --  externally triggered
         Trigger     => (Enabler => Trigger_Rising_Edge,
                         Event   => Sensor_Trigger_Event),
         Conversions => All_Regular_Conversions);
      --  Either rising or falling edge should work. Note that the Event must
      --  match the timer used!

      --  Each conversion generates an interrupt signalling conversion complete.
      Enable_Interrupts (Sensor_ADC.all,
                         Source => Regular_Channel_Conversion_Complete);

      --  ADSTART need to be set (RM3064 pg. 230 chapter 13.3.18) for hardware
      --  trigger operation.
      Start_Conversion (Sensor_ADC.all);

      --  Start the timer that trigger ADC conversions
      Initialize_ADC_Timer;

      Initialized := True;
   end Initialize_ADC;

   --------------------------
   -- Initialize_ADC_Timer --
   --------------------------

   procedure Initialize_ADC_Timer is
      ADC_Timer : constant access Timer := Sensor_Timer'Access;
      Computed_Prescaler : UInt32;
      Computed_Period    : UInt32;
   begin
      --  Initialize the sensor timer
      Enable_Clock (ADC_Timer.all);

      Compute_Prescaler_And_Period
        (ADC_Timer,
         Requested_Frequency => Sensor_Frequency_Hz,
         Prescaler           => Computed_Prescaler,
         Period              => Computed_Period);

      Computed_Period := Computed_Period - 1;

      Configure
        (ADC_Timer.all,
         Prescaler     => UInt16 (Computed_Prescaler),
         Period        => Computed_Period,
         Clock_Divisor => Div1,
         Counter_Mode  => Up);

      Select_Output_Trigger (ADC_Timer.all, Update);

      Enable (ADC_Timer.all);

   end Initialize_ADC_Timer;

   ----------------
   -- Get_Sample --
   ----------------

   function Get_Sample (Reading : in ADC_Reading)
      return Voltage is
   begin
      --  Convert the UInt16 ADC value to Voltage (Float).
      return Voltage (Float (Regular_Samples (Reading)) * ADC_V_Per_Lsb);
   end Get_Sample;

   ------------------
   -- Battery_Gain --
   ------------------

   function Battery_Gain
     (V_Setpoint : Battery_V_Range := Battery_V_Range'First;
      V_Actual   : Voltage := Get_Sample (V_Battery))
      return Gain_Range
   is
   begin
      if (V_Actual / Battery_Relation < Battery_V_Range'First) or
        (V_Actual / Battery_Relation > Battery_V_Range'Last)
      then
         --  Protect the inverter disabling the power stage.
         Inverter_PWM.Safe_State;
         return 0.0;
         --  Call other routine to visually indicate that the power stage was
         --  disabled.
      else
         return V_Setpoint / V_Actual;
      end if;
   end Battery_Gain;

   --------------------
   -- Test_V_Battery --
   --------------------

   function Test_V_Battery return Boolean is
      V_Actual : constant Voltage := Get_Sample (Reading => V_Battery);
   begin
      if (V_Actual / Battery_Relation < Battery_V_Range'First or
          V_Actual / Battery_Relation > Battery_V_Range'Last)
      then
         return False;
      else
         return True;
      end if;
   end Test_V_Battery;

   --------------------
   -- Test_I_Battery --
   --------------------

   function Test_I_Battery return Boolean is
      V_Actual : constant Voltage := Get_Sample (Reading => I_Battery);
   begin
      if V_Actual > Battery_I_Range'Last then
         return False;
      else
         return True;
      end if;
   end Test_I_Battery;

   -------------------
   -- Test_V_Output --
   -------------------

   function Test_V_Output return Boolean is
      V_Actual : constant Voltage := Get_Sample (Reading => V_Output);
   begin
      if (V_Actual / Output_Relation < Output_V_Range'First or
          V_Actual / Output_Relation > Output_V_Range'Last)
      then
         return False;
      else
         return True;
      end if;
   end Test_V_Output;

   --------------------
   -- Is_Initialized --
   --------------------

   function Is_Initialized
      return Boolean is (Initialized);

   ------------------------
   -- Sensor_ADC_Handler --
   ------------------------

   procedure Sensor_ADC_Handler is
   begin
      if Status (Sensor_ADC.all,
                 Flag => Regular_Channel_Conversion_Completed)
      then
         if Interrupt_Enabled
              (Sensor_ADC.all,
               Source => Regular_Channel_Conversion_Complete)
         then
            Clear_Interrupt_Pending
              (Sensor_ADC.all,
               Source => Regular_Channel_Conversion_Complete);

            --  Save the ADC values into a buffer
            Regular_Samples (Rank) := Conversion_Value (Sensor_ADC.all);
            if Rank = ADC_Reading'Last then
               Rank := ADC_Reading'First;
            else
               Rank := ADC_Reading'Succ (Rank);
            end if;

            --  Calculate the new Sine_Gain based on battery voltage
            --  Sine_Gain := Battery_Gain;
            --  Actually is disabled because there is no signal at the ADC.

            --  Testing the 5 kHz output with 1 Hz LED blinking. Because
            --  there are three regular channel conversions, this frequency
            --  will be three times greater.
            --  if Counter = 2_500 then
            --     Set_Toggle (Green_LED);
            --     Counter := 0;
            --  end if;
            --  Counter := Counter + 1;

         end if;
      end if;
   end Sensor_ADC_Handler;

end Inverter_ADC;
