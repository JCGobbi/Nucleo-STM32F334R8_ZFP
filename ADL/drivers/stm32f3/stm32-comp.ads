
--  This file provides interfaces for the comparators on the
--  STM32F3 (ARM Cortex M4F) microcontrollers from ST Microelectronics.

with System; use System;

package STM32.COMP is

   type Comparator is limited private;

   procedure Enable (This : in out Comparator)
     with Post => Enabled (This);

   procedure Disable (This : in out Comparator)
     with Post => not Enabled (This);

   function Enabled (This : Comparator) return Boolean;

   type Inverting_Input_Port is
     (One_Quarter_Vrefint,
      One_Half_Vrefint,
      Three_Quarter_Vrefint,
      Vrefint,
      PA4_DAC1_CH1,
      DAC1_CH2,
      Option_7,
      Option_8,
      DAC2_CH1)
     with Size => 4;
   --  These bits allows to select the source connected to the inverting input
   --  of the comparator:
   --  Option  COMP2     COMP4     COMP6
   --  7         PA2
   --  8                   PB2      PB15

   procedure Set_Inverting_Input_Port
     (This  : in out Comparator;
      Input : Inverting_Input_Port)
     with Post => Read_Inverting_Input_Port (This) = Input;
   --  Select the source connected to the inverting input of the comparator.

   function Read_Inverting_Input_POrt
     (This : Comparator) return Inverting_Input_Port;
   --  Return the source connected to the inverting input of the comparator.

   type Output_Selection is
     (No_Selection,
      TIM1_BRK_ACTH,
      TIM1_BRK2,
      Option_7,
      Option_8,
      Option_9,
      Option_10,
      Option_11,
      Option_12)
     with Size => 4;
   --  These bits select which Timer input must be connected with the
   --  comparator output:
   --  Option         COMP2            COMP4            COMP6
   --  7     TIM1_OCREF_CLR        TIM3_CAP3        TIM2_CAP2
   --  8          TIM1_CAP1
   --  9          TIM2_CAP4       TIM15_CAP2   TIM2_OCREF_CLR
   --  10    TIM2_OCREF_CLR                   TIM16_OCREF_CLR
   --  11         TIM3_CAP1  TIM15_OCREF_CLR       TIM16_CAP1
   --  12    TIM3_OCREF_CLR   TIM3_OCREF_CLR

   for Output_Selection use
     (No_Selection  => 2#0000#,
      TIM1_BRK_ACTH => 2#0001#,
      TIM1_BRK2     => 2#0010#,
      Option_7      => 2#0110#,
      Option_8      => 2#0111#,
      Option_9      => 2#1000#,
      Option_10     => 2#1001#,
      Option_11     => 2#1010#,
      Option_12     => 2#1011#);

   procedure Set_Output_Timer
     (This   : in out Comparator;
      Output : Output_Selection)
     with Post => Read_Output_Timer (This) = Output;
   --  Select which Timer input must be connected with the comparator output.

   function Read_Output_Timer (This : Comparator) return Output_Selection;
   --  Return which Timer input is connected with the comparator output.

   type Output_Polarity is
     (Not_Inverted,
      Inverted);
   --  This bit is used to invert the comparator output.

   procedure Set_Output_Polarity
     (This  : in out Comparator;
      Output : Output_Polarity)
     with Post => Read_Output_Polarity (This) = Output;
   --  Used to invert the comparator output.

   function Read_Output_Polarity (This : Comparator) return Output_Polarity;
   --  Return the comparator output polarity.

   type Output_Blanking is
     (No_Blanking,
      Option_2,
      Option_3,
      Option_4,
      Option_5)
     with Size => 3;
   --  These bits select which Timer output controls the comparator output
   --  blanking:
   --  Option  COMP2     COMP4     COMP6
   --  2    TIM1_OC5  TIM3_OC4
   --  3    TIM2_OC3
   --  4    TIM3_OC3 TIM15_OC1  TIM2_OC4
   --  5                       TIM15_OC2

   procedure Set_Output_Blanking
     (This  : in out Comparator;
      Output : Output_Blanking)
     with Post => Read_Output_Blanking (This) = Output;
   --  Select which Timer output controls the comparator output blanking.

   function Read_Output_Blanking (This : Comparator) return Output_Blanking;
   --  Return which Timer output controls the comparator output blanking.

   type Comparator_Output is (Low, High);

   function Read_Comparator_Output (This : Comparator) return Comparator_Output;
   --  Read the comparator output:
   --  Low = non-inverting input is below inverting input,
   --  High = (non-inverting input is above inverting input

   procedure Set_Lock_Comparator (This : in out Comparator)
     with Post => Read_Lock_Comparator (This) = True;
   --  Allows to have COMPx_CSR register as read-only. It can only be cleared
   --  by a system reset.

   function Read_Lock_Comparator (This : Comparator) return Boolean;
   --  Return the comparator lock bit state.

private

   --  representation for Comparator 2, 4 and 6 Control and Status Registers  ----------

   subtype COMPx_CSR_COMPxINMSEL_Field is HAL.UInt3;
   subtype COMPx_CSR_COMPxOUTSEL_Field is HAL.UInt4;
   subtype COMPx_CSR_COMPx_BLANKING_Field is HAL.UInt3;

   --  control and status register
   type COMPx_CSR_Register is record
      --  Comparator 2 enable
      COMPxEN        : Boolean := False;
      --  unspecified
      Reserved_1_3   : HAL.UInt3 := 16#0#;
      --  Comparator 2 inverting input selection
      COMPxINMSEL    : COMPx_CSR_COMPxINMSEL_Field := 16#0#;
      --  unspecified
      Reserved_7_9   : HAL.UInt3 := 16#0#;
      --  Comparator 2 output selection
      COMPxOUTSEL    : COMPx_CSR_COMPxOUTSEL_Field := 16#0#;
      --  unspecified
      Reserved_14_14 : HAL.Bit := 16#0#;
      --  Comparator 2 output polarity
      COMPxPOL       : Boolean := False;
      --  unspecified
      Reserved_16_17 : HAL.UInt2 := 16#0#;
      --  Comparator 2 blanking source
      COMPx_BLANKING : COMPx_CSR_COMPx_BLANKING_Field := 16#0#;
      --  unspecified
      Reserved_21_21 : HAL.Bit := 16#0#;
      --  Comparator 1 inverting input selection
      COMPxINMSEL_3  : Boolean := False;
      --  unspecified
      Reserved_23_29 : HAL.UInt7 := 16#0#;
      --  Read-only. Comparator 2 output
      COMPxOUT       : Boolean := False;
      --  Comparator 2 lock
      COMPxLOCK      : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMPx_CSR_Register use record
      COMPxEN        at 0 range 0 .. 0;
      Reserved_1_3   at 0 range 1 .. 3;
      COMPxINMSEL    at 0 range 4 .. 6;
      Reserved_7_9   at 0 range 7 .. 9;
      COMPxOUTSEL    at 0 range 10 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      COMPxPOL       at 0 range 15 .. 15;
      Reserved_16_17 at 0 range 16 .. 17;
      COMPx_BLANKING at 0 range 18 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      COMPxINMSEL_3  at 0 range 22 .. 22;
      Reserved_23_29 at 0 range 23 .. 29;
      COMPxOUT       at 0 range 30 .. 30;
      COMPxLOCK      at 0 range 31 .. 31;
   end record;

   --  representation for the whole Comparator type  -----------------

   type Comparator is limited record
      CSR : COMPx_CSR_Register;
   end record with Volatile, Size => 1 * 32;

   for Comparator use record
      CSR at 16#00# range  0 .. 31;
   end record;

end STM32.COMP;
