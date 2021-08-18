with STM32.Device; use STM32.Device;
with STM32.GPIO;   use STM32.GPIO;
with STM32.EXTI;   use STM32.EXTI;
with STM32.Timers; use STM32.Timers;
with STM32.ADC;    use STM32.ADC;

package STM_Board is

   ---------------
   -- Constants --
   ---------------

   subtype Frequency_Hz is Float;

   ---------------------
   -- PWM Full-bridge --
   ---------------------

   PWM_Timer     : Timer renames Timer_1;
   --  Timer for reading sine table values.
   PWM_Interrupt : constant String := "__TIM1_UP_TIM16_handler";
   --  TIM1_UP_TIM16 interrupt vector

   PWM_A_Channel : Timer_Channel renames Channel_1;
   PWM_A_H_Pin   : GPIO_Point renames PA8;
   PWM_A_L_Pin   : GPIO_Point renames PA7;
   PWM_A_GPIO_AF : STM32.GPIO_Alternate_Function renames GPIO_AF_TIM1_6;

   PWM_B_Channel : Timer_Channel renames Channel_2;
   PWM_B_H_Pin   : GPIO_Point renames PA9;
   PWM_B_L_Pin   : GPIO_Point renames PB0;
   PWM_B_GPIO_AF : STM32.GPIO_Alternate_Function renames GPIO_AF_TIM1_6;

   PWM_Gate_Power : GPIO_Point renames PA11;
   --  Output for the FET/IGBT gate drivers.

   ------------------------------
   -- Voltage and Current ADCs --
   ------------------------------

   Sensor_ADC : constant access Analog_To_Digital_Converter := ADC_1'Access;
   Sensor_Trigger_Event : External_Events_Regular_Group := Timer6_TRGO_Event;
   Sensor_ADC_Interrupt : constant String := "__ADC1_2_handler";
   --  This interrupt vector is declared inside crt0.S file.

   ADC_Battery_V_Point : constant ADC_Point := (Sensor_ADC, Channel => 6);
   ADC_Battery_V_Pin   : GPIO_Point renames PC0;

   ADC_Battery_I_Point : constant ADC_Point := (Sensor_ADC, Channel => 7);
   ADC_Battery_I_Pin   : GPIO_Point renames PC1;

   ADC_Output_V_Point : constant ADC_Point := (Sensor_ADC, Channel => 8);
   ADC_Output_V_Pin   : GPIO_Point renames PC2;

   --------------
   -- ADC Timer --
   ---------------

   --  To syncronize A/D conversion and timers, the ADCs could be triggered
   --  by any of TIM1, TIM2, TIM3, TIM6, TIM7, TIM15, TIM16 or TIM17 timer.
   Sensor_Timer : Timer renames Timer_6;

   -------------------------
   -- Other GPIO Channels --
   -------------------------

   AC_Frequency_Pin : GPIO_Point renames PA0;
   --  Input for AC frequency select jumper.

   Button : GPIO_Point renames PC13;
   --  B1 user button input
   Button_Interrupt : constant String := "__EXTI15_10_handler";
   --  This interrupt vector is declared inside crt0.S file.
   Button_EXTI_Line : constant External_Line_Number :=
     Button.Interrupt_Line_Number;

   Green_LED : GPIO_Point renames PA5; -- LD1
   --  Output for OK indication in the nucleo board.

   Red_LED   : GPIO_Point renames PB1; -- LD3
   --  Output for problem indication in the nucleo board.
   LCH_LED   : GPIO_Point renames Green_LED;
   --  Last chance handler led.

   All_LEDs  : GPIO_Points := Green_LED & Red_LED;

   Buzzer    : GPIO_Point renames PB2;
   --  Output for buzzer alarm.

   ------------------------------
   -- Procedures and functions --
   ------------------------------

   procedure Initialize_GPIO;
   --  Initialize GPIO inputs and outputs.

   function Read_Input (This : GPIO_Point) return Boolean
   with
      Pre => Is_Initialized;
   --  Read the specified input.

   procedure Turn_On (This : in out GPIO_Point)
   with
      Pre => Is_Initialized and (This /= PWM_Gate_Power);
   --  Turns ON the specified output.

   procedure Turn_Off (This : in out GPIO_Point)
   with
      Pre => Is_Initialized and (This /= PWM_Gate_Power);
   --  Turns OFF the specified output.

   procedure Set_Toggle (This : in out GPIO_Point)
   with
      Pre => Is_Initialized and (This /= PWM_Gate_Power);
   --  Toggle the specified output.

   procedure All_LEDs_Off
   with
      Pre => Is_Initialized;
   --  Turns OFF all LEDs.

   procedure All_LEDs_On
   with
      Pre => Is_Initialized;
   --  Turns ON all LEDs.

   procedure Toggle_LEDs (These : in out GPIO_Points)
   with
      Pre => Is_Initialized;
   --  Toggle the specified LEDs.

   function Is_Initialized return Boolean;
   --  Returns True if the board specifics are initialized.

private

   Initialized : Boolean := False;

   procedure Button_Handler;
   pragma Export (Asm, Button_Handler, Button_Interrupt);

end STM_Board;
