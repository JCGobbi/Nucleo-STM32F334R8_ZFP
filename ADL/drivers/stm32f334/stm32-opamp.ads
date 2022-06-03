with System; use System;

package STM32.OPAMP is

   type Operational_Amplifier is limited private;

   procedure Enable (This : in out Operational_Amplifier)
     with Post => Enabled (This);

   procedure Disable (This : in out Operational_Amplifier)
     with Post => not Enabled (This);

   function Enabled (This : Operational_Amplifier) return Boolean;

   type NI_Input_Mode is (Normal_Mode, Calibration_Mode);

   procedure Set_NI_Input_Mode
     (This  : in out Operational_Amplifier;
      Input : NI_Input_Mode)
     with Post => Get_NI_Input_Mode (This) = Input;
   --  Select a calibration reference voltage on non-inverting input and
   --  disables external connections.

   function Get_NI_Input_Mode
     (This : Operational_Amplifier) return NI_Input_Mode;
   --  Return the source connected to the non-inverting input of the
   --  operational amplifier.

   type NI_Input_Port is (PB14, PB0, PA7);

   for NI_Input_Port use
     (PB14 => 2#01#,
      PB0  => 2#10#,
      PA7  => 2#11#);

   procedure Set_NI_Input_Port
     (This  : in out Operational_Amplifier;
      Input : NI_Input_Port)
     with Post => Get_NI_Input_Port (This) = Input;
   --  Select the source connected to the non-inverting input of the
   --  operational amplifier.

   function Get_NI_Input_Port
     (This : Operational_Amplifier) return NI_Input_Port;
   --  Return the source connected to the non-inverting input of the
   --  operational amplifier.

   type NI_Sec_Input_Port is (PB14, PB0, PA7);

   for NI_Sec_Input_Port use
     (PB14 => 2#01#,
      PB0  => 2#10#,
      PA7  => 2#11#);

   procedure Set_NI_Sec_Input_Port
     (This  : in out Operational_Amplifier;
      Input : NI_Sec_Input_Port)
     with Post => Get_NI_Sec_Input_Port (This) = Input;
   --  Select the secondary source connected to the non-inverting input
   --  of the operational amplifier.

   function Get_NI_Sec_Input_Port
     (This : Operational_Amplifier) return NI_Sec_Input_Port;
   --  Return the secondary source connected to the non-inverting input
   --  of the operational amplifier.

   type I_Input_Port is
     (PC5_VM0,
      PA5_VM1,
      Feedback_Resistor_PGA_Mode,
      Follower_Mode);

   procedure Set_I_Input_Port
     (This  : in out Operational_Amplifier;
      Input : I_Input_Port)
     with Post => Get_I_Input_Port (This) = Input;
   --  Select the source connected to the inverting input of the
   --  operational amplifier.

   function Get_I_Input_Port
     (This : Operational_Amplifier) return I_Input_Port;
   --  Return the source connected to the inverting input of the
   --  operational amplifier.

   type I_Sec_Input_Port is (PC5_VM0, PA5_VM1);

   procedure Set_I_Sec_Input_Port
     (This  : in out Operational_Amplifier;
      Input : I_Sec_Input_Port)
     with Post => Get_I_Sec_Input_Port (This) = Input;
   --  Select the secondary source connected to the inverting input of the
   --  operational amplifier.

   function Get_I_Sec_Input_Port
     (This : Operational_Amplifier) return I_Sec_Input_Port;
   --  Return the secondary source connected to the inverting input of the
   --  operational amplifier.

   type Input_Mux_Mode is (Manual, Automatic);
   --  Timer controlled mux mode.

   procedure Set_Input_Mux_Mode
     (This  : in out Operational_Amplifier;
      Input : Input_Mux_Mode)
     with Post => Get_Input_Mux_Mode (This) = Input;
   --  Select automatically the switch between the default selection
   --  (VP_SEL and VM_SEL) and the secondary selection (VPS_SEL and VMS_SEL)
   --  of the inverting and non inverting inputs of the operational amplifier.

   function Get_Input_Mux_Mode
     (This : Operational_Amplifier) return Input_Mux_Mode;
   --  Return the selection of the selection between the default and the
   --  secondary inputs of the inverting and non inverting inputs of the
   --  operational amplifier.

   type PGA_Mode_Gain is
     (NI_Gain_2,
      NI_Gain_4,
      NI_Gain_8,
      NI_Gain_16,
      NI_Gain_2_Internal_Feedback_VM0,
      NI_Gain_4_Internal_Feedback_VM0,
      NI_Gain_8_Internal_Feedback_VM0,
      NI_Gain_16_Internal_Feedback_VM0,
      NI_Gain_2_Internal_Feedback_VM1,
      NI_Gain_4_Internal_Feedback_VM1,
      NI_Gain_8_Internal_Feedback_VM1,
      NI_Gain_16_Internal_Feedback_VM1);
   --  Gain in PGA mode.

   for PGA_Mode_Gain use
     (NI_Gain_2                        => 2#0000#,
      NI_Gain_4                        => 2#0001#,
      NI_Gain_8                        => 2#0010#,
      NI_Gain_16                       => 2#0011#,
      NI_Gain_2_Internal_Feedback_VM0  => 2#1000#,
      NI_Gain_4_Internal_Feedback_VM0  => 2#1001#,
      NI_Gain_8_Internal_Feedback_VM0  => 2#1010#,
      NI_Gain_16_Internal_Feedback_VM0 => 2#1011#,
      NI_Gain_2_Internal_Feedback_VM1  => 2#1100#,
      NI_Gain_4_Internal_Feedback_VM1  => 2#1101#,
      NI_Gain_8_Internal_Feedback_VM1  => 2#1110#,
      NI_Gain_16_Internal_Feedback_VM1 => 2#1111#);

   procedure Set_PGA_Mode_Gain
     (This  : in out Operational_Amplifier;
      Input : PGA_Mode_Gain)
     with Post => Get_PGA_Mode_Gain (This) = Input;
   --  Select the gain in PGA mode.

   function Get_PGA_Mode_Gain
     (This : Operational_Amplifier) return PGA_Mode_Gain;
   --  Return the gain in PGA mode.

   procedure Set_User_Trimming
     (This   : in out Operational_Amplifier;
      Enabled : Boolean)
     with Post => Get_User_Trimming (This) = Enabled;
   --  Enable/disable user trimming.

   function Get_User_Trimming
     (This : Operational_Amplifier) return Boolean;
   --  Return the state of user trimming.

   type Differential_Pair is (NMOS, PMOS);

   procedure Set_Offset_Trimming
     (This  : in out Operational_Amplifier;
      Pair  : Differential_Pair;
      Input : UInt5)
     with Post => Get_Offset_Trimming (This, Pair) = Input;
   --  Select the offset trimming value for NMOS or PMOS.

   function Get_Offset_Trimming
     (This : Operational_Amplifier;
      Pair : Differential_Pair) return UInt5;
   --  Return the offset trimming value for NMOS or PMOS.

   type Init_Parameters is record
      Input_Minus     : I_Input_Port;
      Input_Sec_Minus : I_Sec_Input_Port;
      Input_Plus      : NI_Input_Port;
      Input_Sec_Plus  : NI_Sec_Input_Port;
      Mux_Mode        : Input_Mux_Mode;
      PGA_Mode        : PGA_Mode_Gain;
   end record;

   procedure Configure_Opamp
     (This  : in out Operational_Amplifier;
      Param : Init_Parameters);

   procedure Set_Calibration_Mode
     (This   : in out Operational_Amplifier;
      Enabled : Boolean)
     with Post => Get_Calibration_Mode (This) = Enabled;
   --  Select the calibration mode connecting VM and VP to the OPAMP
   --  internal reference voltage.

   function Get_Calibration_Mode
     (This : Operational_Amplifier) return Boolean;
   --  Return the calibration mode.

   type Calibration_Value is
     (VREFOPAMP_Is_3_3_VDDA, --  3.3%
      VREFOPAMP_Is_10_VDDA, --  10%
      VREFOPAMP_Is_50_VDDA, --  50%
      VREFOPAMP_Is_90_VDDA --  90%
      );
   --  Offset calibration bus to generate the internal reference voltage.

   procedure Set_Calibration_Value
     (This  : in out Operational_Amplifier;
      Input : Calibration_Value)
     with Post => Get_Calibration_Value (This) = Input;
   --  Select the offset calibration bus used to generate the internal
   --  reference voltage when CALON = 1 or FORCE_VP = 1.

   function Get_Calibration_Value
     (This : Operational_Amplifier) return Calibration_Value;
   --  Return the offset calibration bus voltage.

   procedure Calibrate (This : in out Operational_Amplifier);
   --  Calibrate the NMOS and PMOS differential pair. This routine
   --  is described in the RM0364 pg. 355. The offset trim time,
   --  during calibration, must respect the minimum time needed
   --  between two steps to have 1 mV accuracy.

   type Internal_VRef_Output is
     (VRef_Is_Output,
      VRef_Is_Not_Output);

   procedure Set_Internal_VRef_Output
     (This  : in out Operational_Amplifier;
      Input : Internal_VRef_Output)
     with Post => Get_Internal_VRef_Output (This) = Input;
   --  Output the internal reference voltage (VREFOPAMPx).

   function Get_Internal_VRef_Output
     (This : Operational_Amplifier) return Internal_VRef_Output;
   --  Return the internal output reference voltage state.

   type Output_Status_Flag is
     (NI_Lesser_Then_I,
      NI_Greater_Then_I);

   function Get_Output_Status_Flag
     (This : Operational_Amplifier) return Output_Status_Flag;
   --  Return the output status flag when the OPAMP is used as comparator
   --  during calibration.

   procedure Set_Lock_OpAmp (This : in out Operational_Amplifier)
     with Post => Get_Lock_OpAmp (This) = True;
   --  Allows to have OPAMPx_CSR register as read-only. It can only be cleared
   --  by a system reset.

   function Get_Lock_OpAmp (This : Operational_Amplifier) return Boolean;
   --  Return the OPAMP lock bit state.

private

   --  representation for OpAmp x Control and Status Registers  ----------

   subtype OPAMPx_CSR_VP_SEL_Field is HAL.UInt2;
   subtype OPAMPx_CSR_VM_SEL_Field is HAL.UInt2;
   subtype OPAMPx_CSR_VPS_SEL_Field is HAL.UInt2;
   subtype OPAMPx_CSR_CALSEL_Field is HAL.UInt2;
   subtype OPAMPx_CSR_PGA_GAIN_Field is HAL.UInt4;
   subtype OPAMPx_CSR_TRIMOFFSETP_Field is HAL.UInt5;
   subtype OPAMPx_CSR_TRIMOFFSETN_Field is HAL.UInt5;

   --  OPAMPx control register
   type OPAMPx_CSR_Register is record
      --  OPAMPx enable
      OPAMPxEN     : Boolean := False;
      --  FORCE_VP
      FORCE_VP     : Boolean := False;
      --  OPAMPx Non inverting input selection
      VP_SEL       : OPAMPx_CSR_VP_SEL_Field := 16#0#;
      --  unspecified
      Reserved_4_4 : HAL.Bit := 16#0#;
      --  OPAMPx inverting input selection
      VM_SEL       : OPAMPx_CSR_VM_SEL_Field := 16#0#;
      --  Timer controlled Mux mode enable
      TCM_EN       : Boolean := False;
      --  OPAMPx inverting input secondary selection
      VMS_SEL      : Boolean := False;
      --  OPAMPx Non inverting input secondary selection
      VPS_SEL      : OPAMPx_CSR_VPS_SEL_Field := 16#0#;
      --  Calibration mode enable
      CALON        : Boolean := False;
      --  Calibration selection
      CALSEL       : OPAMPx_CSR_CALSEL_Field := 16#0#;
      --  Gain in PGA mode
      PGA_GAIN     : OPAMPx_CSR_PGA_GAIN_Field := 16#0#;
      --  User trimming enable
      USER_TRIM    : Boolean := False;
      --  Offset trimming value (PMOS)
      TRIMOFFSETP  : OPAMPx_CSR_TRIMOFFSETP_Field := 16#0#;
      --  Offset trimming value (NMOS)
      TRIMOFFSETN  : OPAMPx_CSR_TRIMOFFSETN_Field := 16#0#;
      --  TSTREF
      TSTREF       : Boolean := False;
      --  Read-only. OPAMP x ouput status flag
      OUTCAL       : Boolean := False;
      --  OPAMP x lock
      LOCK         : Boolean := False;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for OPAMPx_CSR_Register use record
      OPAMPxEN     at 0 range  0 .. 0;
      FORCE_VP     at 0 range  1 .. 1;
      VP_SEL       at 0 range  2 .. 3;
      Reserved_4_4 at 0 range  4 .. 4;
      VM_SEL       at 0 range  5 .. 6;
      TCM_EN       at 0 range  7 .. 7;
      VMS_SEL      at 0 range  8 .. 8;
      VPS_SEL      at 0 range  9 .. 10;
      CALON        at 0 range 11 .. 11;
      CALSEL       at 0 range 12 .. 13;
      PGA_GAIN     at 0 range 14 .. 17;
      USER_TRIM    at 0 range 18 .. 18;
      TRIMOFFSETP  at 0 range 19 .. 23;
      TRIMOFFSETN  at 0 range 24 .. 28;
      TSTREF       at 0 range 29 .. 29;
      OUTCAL       at 0 range 30 .. 30;
      LOCK         at 0 range 31 .. 31;
   end record;

   --  representation for the whole Operationa Amplifier type  -----------------

   type Operational_Amplifier is limited record
      CSR : OPAMPx_CSR_Register;
   end record with Volatile, Size => 1 * 32;

   for Operational_Amplifier use record
      CSR at 16#00# range  0 .. 31;
   end record;

end STM32.OPAMP;
