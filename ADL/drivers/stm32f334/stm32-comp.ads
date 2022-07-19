private with STM32_SVD.SYSCFG;

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
     with Post => Get_Inverting_Input_Port (This) = Input;
   --  Select the source connected to the inverting input of the comparator.

   function Get_Inverting_Input_Port
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

   procedure Select_Output
     (This   : in out Comparator;
      Output : Output_Selection)
     with Post => Get_Output_Selection (This) = Output;
   --  Select which Timer input must be connected with the comparator output.

   function Get_Output_Selection (This : Comparator) return Output_Selection;
   --  Return which Timer input is connected with the comparator output.

   type Output_Polarity is
     (Not_Inverted,
      Inverted);
   --  This bit is used to invert the comparator output.

   procedure Set_Output_Polarity
     (This  : in out Comparator;
      Output : Output_Polarity)
     with Post => Get_Output_Polarity (This) = Output;
   --  Used to invert the comparator output.

   function Get_Output_Polarity (This : Comparator) return Output_Polarity;
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
     with Post => Get_Output_Blanking (This) = Output;
   --  Select which Timer output controls the comparator output blanking.

   function Get_Output_Blanking (This : Comparator) return Output_Blanking;
   --  Return which Timer output controls the comparator output blanking.

   type Init_Parameters is record
      Input_Minus     : Inverting_Input_Port;
      Output_Sel      : Output_Selection;
      Output_Pol      : Output_Polarity;
      Blanking_Source : Output_Blanking;
   end record;

   procedure Configure_Comparator
     (This  : in out Comparator;
      Param : in     Init_Parameters);

   type Comparator_Output is (Low, High);

   function Get_Comparator_Output (This : Comparator) return Comparator_Output;
   --  Read the comparator output:
   --  Low = non-inverting input is below inverting input,
   --  High = (non-inverting input is above inverting input

   procedure Set_Lock_Comparator (This : in out Comparator)
     with Post => Get_Lock_Comparator (This) = True;
   --  Allows to have COMPx_CSR register as read-only. It can only be cleared
   --  by a system reset.

   function Get_Lock_Comparator (This : Comparator) return Boolean;
   --  Return the comparator lock bit state.

private

   --  representation for the whole Comparator type  -----------------

   type Comparator is limited record
      CSR : STM32_SVD.SYSCFG.COMP2_CSR_Register;
   end record with Volatile, Size => 1 * 32;

   for Comparator use record
      CSR at 16#00# range  0 .. 31;
   end record;

end STM32.COMP;
