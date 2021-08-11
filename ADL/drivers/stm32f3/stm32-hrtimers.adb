
with STM32.Device;

package body STM32.HRTimers is

   ----------------------------------------------------------------------------

   --  HRTimer Master functions -----------------------------------------------

   ----------------------------------------------------------------------------

   ------------
   -- Enable --
   ------------

   procedure Enable (Counter : HRTimer) is
   begin
      case Counter is
         when HRTimer_A =>
            HRTIM_Master_Periph.MCR.TACEN := True;
         when HRTimer_B =>
            HRTIM_Master_Periph.MCR.TBCEN := True;
         when HRTimer_C =>
            HRTIM_Master_Periph.MCR.TCCEN := True;
         when HRTimer_D =>
            HRTIM_Master_Periph.MCR.TDCEN := True;
         when HRTimer_E =>
            HRTIM_Master_Periph.MCR.TECEN := True;
         when HRTimer_M => -- Master
            HRTIM_Master_Periph.MCR.MCEN := True;
      end case;
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable (Counter : HRTimer) is
   begin
      case Counter is
         when HRTimer_A =>
            -- Test if HRTimer A has no outputs enabled.
            if not (HRTimer_Common_Periph.OENR.TA1OEN or
                      HRTimer_Common_Periph.OENR.TA2OEN)
            then
               HRTIM_Master_Periph.MCR.TACEN := False;
            end if;

         when HRTimer_B =>
            -- Test if HRTimer B has no outputs enabled.
            if not (HRTimer_Common_Periph.OENR.TB1OEN or
                      HRTimer_Common_Periph.OENR.TB2OEN)
            then
               HRTIM_Master_Periph.MCR.TBCEN := False;
            end if;

         when HRTimer_C =>
            -- Test if HRTimer C has no outputs enabled.
            if not (HRTimer_Common_Periph.OENR.TC1OEN or
                      HRTimer_Common_Periph.OENR.TC2OEN)
            then
               HRTIM_Master_Periph.MCR.TCCEN := False;
            end if;

         when HRTimer_D =>
            -- Test if HRTimer D has no outputs enabled.
            if not (HRTimer_Common_Periph.OENR.TD1OEN or
                      HRTimer_Common_Periph.OENR.TD2OEN)
            then
               HRTIM_Master_Periph.MCR.TDCEN := False;
            end if;

         when HRTimer_E =>
            -- Test if HRTimer E has no outputs enabled.
            if not (HRTimer_Common_Periph.OENR.TE1OEN or
                      HRTimer_Common_Periph.OENR.TE2OEN)
            then
               HRTIM_Master_Periph.MCR.TECEN := False;
            end if;

         when HRTimer_M => -- Master
            --  Test if HRTimer A to E has no outputs enabled
            if not (HRTimer_Common_Periph.OENR.TA1OEN or
              HRTimer_Common_Periph.OENR.TA2OEN) and
              not (HRTimer_Common_Periph.OENR.TB1OEN or
              HRTimer_Common_Periph.OENR.TB2OEN) and
              not (HRTimer_Common_Periph.OENR.TC1OEN or
              HRTimer_Common_Periph.OENR.TC2OEN) and
              not (HRTimer_Common_Periph.OENR.TD1OEN or
              HRTimer_Common_Periph.OENR.TD2OEN) and
              not (HRTimer_Common_Periph.OENR.TE1OEN or
              HRTimer_Common_Periph.OENR.TE2OEN)
            then
               HRTIM_Master_Periph.MCR.MCEN := False;
            end if;
      end case;
   end Disable;

   -------------
   -- Enabled --
   -------------

   function Enabled (Counter : HRTimer) return Boolean is
   begin
      case Counter is
         when HRTimer_A =>
            return HRTIM_Master_Periph.MCR.TACEN;
         when HRTimer_B =>
            return HRTIM_Master_Periph.MCR.TBCEN;
         when HRTimer_C =>
            return HRTIM_Master_Periph.MCR.TCCEN;
         when HRTimer_D =>
            return HRTIM_Master_Periph.MCR.TDCEN;
         when HRTimer_E =>
            return HRTIM_Master_Periph.MCR.TECEN;
         when HRTimer_M => -- Master
            return HRTIM_Master_Periph.MCR.MCEN;
      end case;
   end Enabled;

   -------------
   -- Enabled --
   -------------

   function Enabled (Counter : HRTimer_Master) return Boolean
   is
      pragma Unreferenced (Counter);
   begin
      return HRTIM_Master_Periph.MCR.MCEN;
   end Enabled;

   ------------
   -- Enable --
   ------------

   procedure Enable (Counters : HRTimer_List) is
      Value : UInt6 := 2#000000#;
   begin
      for Counter of Counters loop
         Value := Value or Counter'Enum_Rep;
      end loop;
      Counter_Enable_Field.TxCEN := Counter_Enable_Field.TxCEN or Value;
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable (Counters : HRTimer_List) is
      Value : UInt6 := 2#111111#;
   begin
      for Counter of Counters loop
         case Counter is
            when HRTimer_A =>
               -- Test if HRTimer A has no outputs enabled.
               if not (HRTimer_Common_Periph.OENR.TA1OEN or
                         HRTimer_Common_Periph.OENR.TA2OEN)
               then
                  Value := Value and not Counter'Enum_Rep;
               end if;

            when HRTimer_B =>
               -- Test if HRTimer B has no outputs enabled.
               if not (HRTimer_Common_Periph.OENR.TB1OEN or
                         HRTimer_Common_Periph.OENR.TB2OEN)
               then
                  Value := Value and not Counter'Enum_Rep;
               end if;

            when HRTimer_C =>
               -- Test if HRTimer C has no outputs enabled.
               if not (HRTimer_Common_Periph.OENR.TC1OEN or
                         HRTimer_Common_Periph.OENR.TC2OEN)
               then
                  Value := Value and not Counter'Enum_Rep;
               end if;

            when HRTimer_D =>
               -- Test if HRTimer D has no outputs enabled.
               if not (HRTimer_Common_Periph.OENR.TD1OEN or
                         HRTimer_Common_Periph.OENR.TD2OEN)
               then
                  Value := Value and not Counter'Enum_Rep;
               end if;

            when HRTimer_E =>
               -- Test if HRTimer E has no outputs enabled.
               if not (HRTimer_Common_Periph.OENR.TE1OEN or
                         HRTimer_Common_Periph.OENR.TE2OEN)
               then
                  Value := Value and not Counter'Enum_Rep;
               end if;

            when HRTimer_M => -- Master
               --  Test if HRTimer A to E has no outputs enabled
               if not (HRTimer_Common_Periph.OENR.TA1OEN or
                 HRTimer_Common_Periph.OENR.TA2OEN) and
                 not (HRTimer_Common_Periph.OENR.TB1OEN or
                 HRTimer_Common_Periph.OENR.TB2OEN) and
                 not (HRTimer_Common_Periph.OENR.TC1OEN or
                 HRTimer_Common_Periph.OENR.TC2OEN) and
                 not (HRTimer_Common_Periph.OENR.TD1OEN or
                 HRTimer_Common_Periph.OENR.TD2OEN) and
                 not (HRTimer_Common_Periph.OENR.TE1OEN or
                 HRTimer_Common_Periph.OENR.TE2OEN)
               then
                  Value := Value and not Counter'Enum_Rep;
               end if;
         end case;
      end loop;

      Counter_Enable_Field.TxCEN := Counter_Enable_Field.TxCEN and Value;
   end Disable;

   ------------------------
   -- Set_Preload_Enable --
   ------------------------

   procedure Set_Preload_Enable
     (This   : in out HRTimer_Master;
      Enable : Boolean)
   is
   begin
      This.MCR.PREEN := Enable;
   end Set_Preload_Enable;

   -------------------------
   -- Configure_Prescaler --
   -------------------------

   procedure Configure_Prescaler
     (This        : in out HRTimer_Master;
      Prescaler   : UInt3)
   is
   begin
      This.MCR.CKPSC := Prescaler;
   end Configure_Prescaler;

   -----------------------
   -- Current_Prescaler --
   -----------------------

   function Current_Prescaler (This : HRTimer_Master) return UInt3 is
   begin
      return This.MCR.CKPSC;
   end Current_Prescaler;

   -------------------------------------
   -- Configure_Synchronization_Input --
   -------------------------------------

   procedure Configure_Synchronization_Input
     (This   : in out HRTimer_Master;
      Source : Synchronization_Input_Source;
      Reset  : Boolean;
      Start  : Boolean)
   is
   begin
      This.MCR.SYNCIN := Source'Enum_Rep;
      This.MCR.SYNCRSTM := Reset;
      This.MCR.SYNCSTRTM := Start;
   end Configure_Synchronization_Input;

   --------------------------------------
   -- Configure_Synchronization_Output --
   --------------------------------------

   procedure Configure_Synchronization_Output
     (This   : in out HRTimer_Master;
      Source : Synchronization_Output_Source;
      Event  : Synchronization_Output_Event)
   is
   begin
      This.MCR.SYNCSRC := Source'Enum_Rep;
      This.MCR.SYNCOUT := Event'Enum_Rep;
   end Configure_Synchronization_Output;

   -------------------------------------------
   -- Configure_DAC_Synchronization_Trigger --
   -------------------------------------------

   procedure Configure_DAC_Synchronization_Trigger
     (This    : in out HRTimer_Master;
      Trigger : DAC_Synchronization_Trigger)
   is
   begin
      This.MCR.DACSYNC := Trigger'Enum_Rep;
   end Configure_DAC_Synchronization_Trigger;

   ----------------------------
   -- Configure_Timer_Update --
   ----------------------------

   procedure Configure_Timer_Update
     (This       : in out HRTimer_Master;
      Repetition : Boolean;
      Burst_DMA  : Burst_DMA_Update_Mode)
   is
   begin
      This.MCR.MREPU := Repetition;
      This.MCR.BRSTDMA := Burst_DMA'Enum_Rep;
   end Configure_Timer_Update;

   -------------------------
   -- Set_HalfPeriod_Mode --
   -------------------------

   procedure Set_HalfPeriod_Mode
     (This : in out HRTimer_Master;
      Mode : Boolean)
   is
   begin
      This.MCR.HALF := Mode;
   end Set_HalfPeriod_Mode;

   ----------------
   -- Set_Period --
   ----------------

   procedure Set_Period (This : in out HRTimer_Master;  Value : UInt16) is
   begin
      This.MPER.MPER := Value;
   end Set_Period;

   --------------------
   -- Current_Period --
   --------------------

   function Current_Period (This : HRTimer_Master) return UInt16 is
   begin
      return This.MPER.MPER;
   end Current_Period;

   --------------------------------
   -- Set_Counter_Operating_Mode --
   --------------------------------

   procedure Set_Counter_Operating_Mode
     (This : in out HRTimer_Master;
      Mode : Counter_Operating_Mode)
   is
   begin
      case Mode is
         when SingleShot_NonRetriggerable =>
            This.MCR.CONT := False;
            This.MCR.RETRIG := False;
         when SingleShot_Retriggerable =>
            This.MCR.CONT := False;
            This.MCR.RETRIG := True;
         when Continuous =>
            This.MCR.CONT := True;
            This.MCR.RETRIG := False;
      end case;
   end Set_Counter_Operating_Mode;

   -----------------
   -- Set_Counter --
   -----------------

   procedure Set_Counter (This : in out HRTimer_Master; Value : UInt16) is
   begin
      This.MCNTR.MCNT := Value;
   end Set_Counter;

   ---------------------
   -- Current_Counter --
   ---------------------

   function Current_Counter (This : HRTimer_Master) return UInt16 is
   begin
      return This.MCNTR.MCNT;
   end Current_Counter;

   ----------------------------
   -- Set_Repetition_Counter --
   ----------------------------

   procedure Set_Repetition_Counter
     (This : in out HRTimer_Master;
      Value : UInt8) is
   begin
      This.MREP.MREP := Value;
   end Set_Repetition_Counter;

   --------------------------------
   -- Current_Repetition_Counter --
   --------------------------------

   function Current_Repetition_Counter
     (This : HRTimer_Master) return UInt8 is
   begin
      return This.MREP.MREP;
   end Current_Repetition_Counter;

   ----------------------------------
   -- Configure_Repetition_Counter --
   ----------------------------------

   procedure Configure_Repetition_Counter
     (This        : in out HRTimer_Master;
      Counter     : UInt8;
      Interrupt   : Boolean;
      DMA_Request : Boolean)
   is
   begin
      This.MREP.MREP := Counter;
      This.MDIER.MREPIE := Interrupt;
      This.MDIER.MREPDE := DMA_Request;
   end Configure_Repetition_Counter;

   -----------------------
   -- Set_Compare_Value --
   -----------------------

   procedure Set_Compare_Value
     (This   : in out HRTimer_Master;
      Number : HRTimer_Compare_Number;
      Value  : in out UInt16)
   is
      pragma Unreferenced (This);

      --  The minimum value for timer compare is 3 periods of fHRTIM clock,
      --  that is  0x60 if CKPSC[2:0] = 0, 0x30 if CKPSC[2:0] = 1, 0x18 if
      --  CKPSC[2:0] = 2,... See chapter 21.5.8 at pg. 724 in RM0364 rev. 4.
      Prescaler : constant UInt3 := HRTIM_Master_Periph.MCR.CKPSC;
      Pre_Value : constant UInt16 := UInt16 (2 ** Natural (Prescaler));
      Min_Value : constant UInt16 := 16#60# / Pre_Value;
   begin
      if Value > Min_Value then
         Value := Min_Value;
      end if;

      case Number is
         when Compare_1 =>
            HRTIM_Master_Periph.MCMP1R.MCMP1 := Value;
         when Compare_2 =>
            HRTIM_Master_Periph.MCMP2R.MCMP2 := Value;
         when Compare_3 =>
            HRTIM_Master_Periph.MCMP3R.MCMP3 := Value;
         when Compare_4 =>
            HRTIM_Master_Periph.MCMP4R.MCMP4 := Value;
      end case;
   end Set_Compare_Value;

   ------------------------
   -- Read_Compare_Value --
   ------------------------

   function Read_Compare_Value
     (This   : HRTimer_Master;
      Number : HRTimer_Compare_Number) return UInt16
   is
     pragma Unreferenced (This);
   begin
      case Number is
         when Compare_1 =>
            return HRTIM_Master_Periph.MCMP1R.MCMP1;
         when Compare_2 =>
            return HRTIM_Master_Periph.MCMP2R.MCMP2;
         when Compare_3 =>
            return HRTIM_Master_Periph.MCMP3R.MCMP3;
         when Compare_4 =>
            return HRTIM_Master_Periph.MCMP4R.MCMP4;
      end case;
   end Read_Compare_Value;

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_Interrupt
     (This   : in out HRTimer_Master;
      Source : HRTimer_Master_Interrupt)
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            This.MDIER.MCMP1IE := True;
         when Compare_2_Interrupt =>
            This.MDIER.MCMP2IE := True;
         when Compare_3_Interrupt =>
            This.MDIER.MCMP3IE := True;
         when Compare_4_Interrupt =>
            This.MDIER.MCMP4IE := True;
         when Repetition_Interrupt =>
            This.MDIER.MREPIE := True;
         when Sync_Input_Interrupt =>
            This.MDIER.SYNCIE := True;
         when Update_Interrupt =>
            This.MDIER.MUPDIE := True;
      end case;
   end Enable_Interrupt;

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_Interrupt
     (This    : in out HRTimer_Master;
      Sources : HRTimer_Master_Interrupt_List)
   is
   begin
      for Source of Sources loop
         case Source is
            when Compare_1_Interrupt =>
               This.MDIER.MCMP1IE := True;
            when Compare_2_Interrupt =>
               This.MDIER.MCMP2IE := True;
            when Compare_3_Interrupt =>
               This.MDIER.MCMP3IE := True;
            when Compare_4_Interrupt =>
               This.MDIER.MCMP4IE := True;
            when Repetition_Interrupt =>
               This.MDIER.MREPIE := True;
            when Sync_Input_Interrupt =>
               This.MDIER.SYNCIE := True;
            when Update_Interrupt =>
               This.MDIER.MUPDIE := True;
         end case;
      end loop;
   end Enable_Interrupt;

   -----------------------
   -- Disable_Interrupt --
   -----------------------

   procedure Disable_Interrupt
     (This   : in out HRTimer_Master;
      Source : HRTimer_Master_Interrupt)
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            This.MDIER.MCMP1IE := False;
         when Compare_2_Interrupt =>
            This.MDIER.MCMP2IE := False;
         when Compare_3_Interrupt =>
            This.MDIER.MCMP3IE := False;
         when Compare_4_Interrupt =>
            This.MDIER.MCMP4IE := False;
         when Repetition_Interrupt =>
            This.MDIER.MREPIE := False;
         when Sync_Input_Interrupt =>
            This.MDIER.SYNCIE := False;
         when Update_Interrupt =>
            This.MDIER.MUPDIE := False;
      end case;
   end Disable_Interrupt;

   -----------------------
   -- Interrupt_Enabled --
   -----------------------

   function Interrupt_Enabled
     (This   : HRTimer_Master;
      Source : HRTimer_Master_Interrupt) return Boolean
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            return This.MDIER.MCMP1IE;
         when Compare_2_Interrupt =>
            return This.MDIER.MCMP2IE;
         when Compare_3_Interrupt =>
            return This.MDIER.MCMP3IE;
         when Compare_4_Interrupt =>
            return This.MDIER.MCMP4IE;
         when Repetition_Interrupt =>
            return This.MDIER.MREPIE;
         when Sync_Input_Interrupt =>
            return This.MDIER.SYNCIE;
         when Update_Interrupt =>
            return This.MDIER.MUPDIE;
      end case;
   end Interrupt_Enabled;

   ----------------------
   -- Interrupt_Status --
   ----------------------

   function Interrupt_Status
     (This   : HRTimer_Master;
      Source : HRTimer_Master_Interrupt) return Boolean
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            return This.MISR.MCMP.Arr(1);
         when Compare_2_Interrupt =>
            return This.MISR.MCMP.Arr(2);
         when Compare_3_Interrupt =>
            return This.MISR.MCMP.Arr(3);
         when Compare_4_Interrupt =>
            return This.MISR.MCMP.Arr(4);
         when Repetition_Interrupt =>
            return This.MISR.MREP;
         when Sync_Input_Interrupt =>
            return This.MISR.SYNC;
         when Update_Interrupt =>
            return This.MISR.MUPD;
      end case;
   end Interrupt_Status;

   -----------------------------
   -- Clear_Pending_Interrupt --
   -----------------------------

   procedure Clear_Pending_Interrupt
     (This   : in out HRTimer_Master;
      Source : HRTimer_Master_Interrupt)
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            This.MICR.MCMP1C := True;
         when Compare_2_Interrupt =>
            This.MICR.MCMP2C := True;
         when Compare_3_Interrupt =>
            This.MICR.MCMP3C := True;
         when Compare_4_Interrupt =>
            This.MICR.MCMP4C := True;
         when Repetition_Interrupt =>
            This.MICR.MREPC := True;
         when Sync_Input_Interrupt =>
            This.MICR.SYNCC := True;
         when Update_Interrupt =>
            This.MICR.MUPDC := True;
      end case;
   end Clear_Pending_Interrupt;

   -----------------------
   -- Enable_DMA_source --
   -----------------------

   procedure Enable_DMA_Source
     (This   : in out HRTimer_Master;
      Source : HRTimer_Master_DMA_Request)
   is
   begin
      case Source is
         when Compare_1_DMA =>
            This.MDIER.MCMP1DE := True;
         when Compare_2_DMA =>
            This.MDIER.MCMP2DE := True;
         when Compare_3_DMA =>
            This.MDIER.MCMP3DE := True;
         when Compare_4_DMA =>
            This.MDIER.MCMP4DE := True;
         when Repetition_DMA =>
            This.MDIER.MREPDE := True;
         when Sync_Input_DMA =>
            This.MDIER.SYNCDE := True;
         when Update_DMA =>
            This.MDIER.MUPDDE := True;
      end case;
   end Enable_DMA_Source;

   ------------------------
   -- Disable_DMA_Source --
   ------------------------

   procedure Disable_DMA_Source
     (This   : in out HRTimer_Master;
      Source : HRTimer_Master_DMA_Request)
   is
   begin
      case Source is
         when Compare_1_DMA =>
            This.MDIER.MCMP1DE := False;
         when Compare_2_DMA =>
            This.MDIER.MCMP2DE := False;
         when Compare_3_DMA =>
            This.MDIER.MCMP3DE := False;
         when Compare_4_DMA =>
            This.MDIER.MCMP4DE := False;
         when Repetition_DMA =>
            This.MDIER.MREPDE := False;
         when Sync_Input_DMA =>
            This.MDIER.SYNCDE := False;
         when Update_DMA =>
            This.MDIER.MUPDDE := False;
      end case;
   end Disable_DMA_Source;

   ------------------------
   -- DMA_Source_Enabled --
   ------------------------

   function DMA_Source_Enabled
     (This   : HRTimer_Master;
      Source : HRTimer_Master_DMA_Request) return Boolean
   is
   begin
      case Source is
         when Compare_1_DMA =>
            return This.MDIER.MCMP1DE;
         when Compare_2_DMA =>
            return This.MDIER.MCMP2DE;
         when Compare_3_DMA =>
            return This.MDIER.MCMP3DE;
         when Compare_4_DMA =>
            return This.MDIER.MCMP4DE;
         when Repetition_DMA =>
            return This.MDIER.MREPDE;
         when Sync_Input_DMA =>
            return This.MDIER.SYNCDE;
         when Update_DMA =>
            return This.MDIER.MUPDDE;
      end case;
   end DMA_Source_Enabled;

   ----------------------------------------------------------------------------

   --  HRTimer A to E functions -----------------------------------------------

   ----------------------------------------------------------------------------

   -------------
   -- Enabled --
   -------------

   function Enabled (This : HRTimer_x) return Boolean is
   begin
      if This'Address = HRTIM_TIMA_Base then
         return HRTIM_Master_Periph.MCR.TACEN;
      elsif This'Address = HRTIM_TIMB_Base then
         return HRTIM_Master_Periph.MCR.TBCEN;
      elsif This'Address = HRTIM_TIMC_Base then
         return HRTIM_Master_Periph.MCR.TCCEN;
      elsif This'Address = HRTIM_TIMD_Base then
         return HRTIM_Master_Periph.MCR.TDCEN;
      elsif This'Address = HRTIM_TIME_Base then
         return HRTIM_Master_Periph.MCR.TECEN;
      end if;
      return False;
   end Enabled;

   ------------------------
   -- Set_Preload_Enable --
   ------------------------

   procedure Set_Preload_Enable
     (This   : in out HRTimer_X;
      Enable : Boolean)
   is
   begin
      This.TIMxCR.PREEN := Enable;
   end Set_Preload_Enable;

   -------------------------
   -- Configure_Prescaler --
   -------------------------

   procedure Configure_Prescaler
     (This        : in out HRTimer_x;
      Prescaler   : UInt3)
   is
   begin
      This.TIMxCR.CKPSCx := Prescaler;
   end Configure_Prescaler;

   -----------------------
   -- Current_Prescaler --
   -----------------------

   function Current_Prescaler (This : HRTimer_x) return UInt3 is
   begin
      return This.TIMxCR.CKPSCx;
   end Current_Prescaler;

   -----------------------
   -- Set_PushPull_Mode --
   -----------------------

   procedure Set_PushPull_Mode (This : in out HRTimer_X; Mode : Boolean) is
   begin
      This.TIMxCR.PSHPLL := Mode;
   end Set_PushPull_Mode;

   -------------------------------------
   -- Configure_Synchronization_Input --
   -------------------------------------

   procedure Configure_Synchronization_Input
     (This   : in out HRTimer_X;
      Reset  : Boolean;
      Start  : Boolean)
   is
   begin
      This.TIMxCR.SYNCRSTx := Reset;
      This.TIMxCR.SYNCSTRTx := Start;
   end Configure_Synchronization_Input;

   -------------------------------------------
   -- Configure_DAC_Synchronization_Trigger --
   -------------------------------------------

   procedure Configure_DAC_Synchronization_Trigger
     (This    : in out HRTimer_X;
      Trigger : DAC_Synchronization_Trigger)
   is
   begin
      This.TIMxCR.DACSYNC := Trigger'Enum_Rep;
   end Configure_DAC_Synchronization_Trigger;

   --------------------------------
   -- Configure_AutoDelayed_Mode --
   --------------------------------

   procedure Configure_AutoDelayed_Mode
     (This : in out HRTimer_X;
      Mode : CMP2_AutoDelayed_Mode)
   is
   begin
      This.TIMxCR.DELCMP.Arr(2) := Mode'Enum_Rep;
   end Configure_AutoDelayed_Mode;

   --------------------------------
   -- Configure_AutoDelayed_Mode --
   --------------------------------

   procedure Configure_AutoDelayed_Mode
     (This : in out HRTimer_X;
      Mode : CMP4_AutoDelayed_Mode)
   is
   begin
      This.TIMxCR.DELCMP.Arr(3) := Mode'Enum_Rep;
   end Configure_AutoDelayed_Mode;

   ----------------------------------
   -- Configure_Update_Gating_Mode --
   ----------------------------------

   procedure Configure_Update_Gating_Mode
     (This : in out HRTimer_X;
      Mode : Update_Gating_Mode)
   is
   begin
      This.TIMxCR.UPDGAT := Mode'Enum_Rep;
   end Configure_Update_Gating_Mode;

   ----------------------------
   -- Configure_Timer_Update --
   ----------------------------

   procedure Configure_Timer_Update
     (This       : in out HRTimer_X;
      Repetition : Boolean;
      Reset      : Boolean;
      Timer_A    : Boolean;
      Timer_B    : Boolean;
      Timer_C    : Boolean;
      Timer_D    : Boolean;
      Timer_E    : Boolean;
      Master     : Boolean)
   is
   begin
      if This'Address = HRTIM_TIMA_Base then
         This.TIMxCR.TxREPU := Repetition;
         This.TIMxCR.TxRSTU := Reset;
         HRTIM_TIMA_Periph.TIMACR.TBU := Timer_B;
         HRTIM_TIMA_Periph.TIMACR.TCU := Timer_C;
         HRTIM_TIMA_Periph.TIMACR.TDU := Timer_D;
         HRTIM_TIMA_Periph.TIMACR.TEU := Timer_E;
         This.TIMxCR.MSTU := Master;

      elsif This'Address = HRTIM_TIMB_Base then
         This.TIMxCR.TxREPU := Repetition;
         This.TIMxCR.TxRSTU := Reset;
         HRTIM_TIMB_Periph.TIMBCR.TAU := Timer_A;
         HRTIM_TIMB_Periph.TIMBCR.TCU := Timer_C;
         HRTIM_TIMB_Periph.TIMBCR.TDU := Timer_D;
         HRTIM_TIMB_Periph.TIMBCR.TEU := Timer_E;
         This.TIMxCR.MSTU := Master;

      elsif This'Address = HRTIM_TIMC_Base then
         This.TIMxCR.TxREPU := Repetition;
         This.TIMxCR.TxRSTU := Reset;
         HRTIM_TIMC_Periph.TIMCCR.TAU := Timer_A;
         HRTIM_TIMC_Periph.TIMCCR.TBU := Timer_B;
         HRTIM_TIMC_Periph.TIMCCR.TDU := Timer_D;
         HRTIM_TIMC_Periph.TIMCCR.TEU := Timer_E;
         This.TIMxCR.MSTU := Master;

      elsif This'Address = HRTIM_TIMD_Base then
         This.TIMxCR.TxREPU := Repetition;
         This.TIMxCR.TxRSTU := Reset;
         HRTIM_TIMD_Periph.TIMDCR.TAU := Timer_A;
         HRTIM_TIMD_Periph.TIMDCR.TBU := Timer_B;
         HRTIM_TIMD_Periph.TIMDCR.TCU := Timer_C;
         HRTIM_TIMD_Periph.TIMDCR.TEU := Timer_E;
         This.TIMxCR.MSTU := Master;

      elsif This'Address = HRTIM_TIME_Base then
         This.TIMxCR.TxREPU := Repetition;
         This.TIMxCR.TxRSTU := Reset;
         HRTIM_TIME_Periph.TIMECR.TAU := Timer_A;
         HRTIM_TIME_Periph.TIMECR.TBU := Timer_B;
         HRTIM_TIME_Periph.TIMECR.TCU := Timer_C;
         HRTIM_TIME_Periph.TIMECR.TDU := Timer_D;
         This.TIMxCR.MSTU := Master;
      end if;
   end Configure_Timer_Update;

   -------------------------
   -- Set_HalfPeriod_Mode --
   -------------------------

   procedure Set_HalfPeriod_Mode
     (This : in out HRTimer_X;
      Mode : Boolean)
   is
   begin
      This.TIMxCR.HALF := Mode;
   end Set_HalfPeriod_Mode;

   ----------------
   -- Set_Period --
   ----------------

   procedure Set_Period (This : in out HRTimer_X;  Value : UInt16) is
   begin
      This.PERxR.PERx := Value;
   end Set_Period;

   --------------------
   -- Current_Period --
   --------------------

   function Current_Period (This : HRTimer_X) return UInt16 is
   begin
      return This.PERxR.PERx;
   end Current_Period;

   --------------------------------
   -- Set_Counter_Operating_Mode --
   --------------------------------

   procedure Set_Counter_Operating_Mode
     (This : in out HRTimer_X;
      Mode : Counter_Operating_Mode)
   is
   begin
      case Mode is
         when SingleShot_NonRetriggerable =>
            This.TIMxCR.CONT := False;
            This.TIMxCR.RETRIG := False;
         when SingleShot_Retriggerable =>
            This.TIMxCR.CONT := False;
            This.TIMxCR.RETRIG := True;
         when Continuous =>
            This.TIMxCR.CONT := True;
            This.TIMxCR.RETRIG := False;
      end case;
   end Set_Counter_Operating_Mode;

   -----------------
   -- Set_Counter --
   -----------------

   procedure Set_Counter (This : in out HRTimer_X;  Value : UInt16) is
   begin
      This.CNTxR.CNTx := Value;
   end Set_Counter;

   ---------------------
   -- Current_Counter --
   ---------------------

   function Current_Counter (This : HRTimer_X) return UInt16 is
   begin
      return This.CNTxR.CNTx;
   end Current_Counter;

   ----------------------------
   -- Set_Repetition_Counter --
   ----------------------------

   procedure Set_Repetition_Counter
     (This : in out HRTimer_X;  Value : UInt8) is
   begin
      This.REPxR.REPx := Value;
   end Set_Repetition_Counter;

   --------------------------------
   -- Current_Repetition_Counter --
   --------------------------------

   function Current_Repetition_Counter (This : HRTimer_X) return UInt8 is
   begin
      return This.REPxR.REPx;
   end Current_Repetition_Counter;

   ----------------------------------
   -- Configure_Repetition_Counter --
   ----------------------------------

   procedure Configure_Repetition_Counter
     (This        : in out HRTimer_x;
      Counter     : UInt8;
      Interrupt   : Boolean;
      DMA_Request : Boolean)
   is
   begin
      This.REPxR.REPx := Counter;
      This.TIMxDIER.REPIE := Interrupt;
      This.TIMxDIER.REPDE := DMA_Request;
   end Configure_Repetition_Counter;

   -----------------------
   -- Set_Compare_Value --
   -----------------------

   procedure Set_Compare_Value
     (This   : in out HRTimer_X;
      Number : HRTimer_Compare_Number;
      Value  : in out UInt16)
   is
      --  The minimum value for timer compare is 3 periods of fHRTIM clock,
      --  that is  0x60 if CKPSC[2:0] = 0, 0x30 if CKPSC[2:0] = 1, 0x18 if
      --  CKPSC[2:0] = 2,... See chapter 21.5.8 at pg. 724 in RM0364 rev. 4.
      Prescaler : constant UInt3 := This.TIMxCR.CKPSCx;
      Pre_Value : constant UInt16 := UInt16 (2 ** Natural (Prescaler));
      Min_Value : constant UInt16 := 16#60# / Pre_Value;
   begin
      Value := UInt16'Max (Value, Min_Value);

      case Number is
         when Compare_1 =>
            This.CMP1xR.CMP1x := Value;
         when Compare_2 =>
            This.CMP2xR.CMP2x := Value;
         when Compare_3 =>
            This.CMP3xR.CMP3x := Value;
         when Compare_4 =>
            This.CMP4xR.CMP4x := Value;
      end case;
   end Set_Compare_Value;

   ------------------------
   -- Read_Compare_Value --
   ------------------------

   function Read_Compare_Value
     (This   : HRTimer_X;
      Number : HRTimer_Compare_Number) return UInt16
   is
   begin
      case Number is
         when Compare_1 =>
            return This.CMP1xR.CMP1x;
         when Compare_2 =>
            return This.CMP2xR.CMP2x;
         when Compare_3 =>
            return This.CMP3xR.CMP3x;
         when Compare_4 =>
            return This.CMP4xR.CMP4x;
      end case;
   end Read_Compare_Value;

   ------------------------
   -- Read_Capture_Value --
   ------------------------

   function Read_Capture_Value
     (This   : HRTimer_X;
      Number : HRTimer_Capture_Number) return UInt16
   is
   begin
      case Number is
         when Capture_1 =>
            return This.CPT1xR.CPT1x;
         when Capture_2 =>
            return This.CPT2xR.CPT2x;
      end case;
   end Read_Capture_Value;

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_Interrupt
     (This   : in out HRTimer_X;
      Source : HRTimer_X_Interrupt)
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            This.TIMxDIER.CMP1IE := True;
         when Compare_2_Interrupt =>
            This.TIMxDIER.CMP2IE := True;
         when Compare_3_Interrupt =>
            This.TIMxDIER.CMP3IE := True;
         when Compare_4_Interrupt =>
            This.TIMxDIER.CMP4IE := True;
         when Repetition_Interrupt =>
            This.TIMxDIER.REPIE := True;
         when Update_Interrupt =>
            This.TIMxDIER.UPDIE := True;
         when Capture_1_Interrupt =>
            This.TIMxDIER.CPT1IE := True;
         when Capture_2_Interrupt =>
            This.TIMxDIER.CPT2IE := True;
         when Output_1_Set_Interrupt =>
            This.TIMxDIER.SET1xIE := True;
         when Output_1_Reset_Interrupt =>
            This.TIMxDIER.RSTx1IE := True;
         when Output_2_Set_Interrupt =>
            This.TIMxDIER.SETx2IE := True;
         when Output_2_Reset_Interrupt =>
            This.TIMxDIER.RSTx2IE := True;
         when Reset_RollOver_Interrupt =>
            This.TIMxDIER.RSTIE := True;
         when Delayed_Protection_Interrupt =>
            This.TIMxDIER.DLYPRTIE := True;
      end case;
   end Enable_Interrupt;

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_Interrupt
     (This    : in out HRTimer_X;
      Sources : HRTimer_X_Interrupt_List)
   is
   begin
      for Source of Sources loop
         case Source is
            when Compare_1_Interrupt =>
               This.TIMxDIER.CMP1IE := True;
            when Compare_2_Interrupt =>
               This.TIMxDIER.CMP2IE := True;
            when Compare_3_Interrupt =>
               This.TIMxDIER.CMP3IE := True;
            when Compare_4_Interrupt =>
               This.TIMxDIER.CMP4IE := True;
            when Repetition_Interrupt =>
               This.TIMxDIER.REPIE := True;
            when Update_Interrupt =>
               This.TIMxDIER.UPDIE := True;
            when Capture_1_Interrupt =>
               This.TIMxDIER.CPT1IE := True;
            when Capture_2_Interrupt =>
               This.TIMxDIER.CPT2IE := True;
            when Output_1_Set_Interrupt =>
               This.TIMxDIER.SET1xIE := True;
            when Output_1_Reset_Interrupt =>
               This.TIMxDIER.RSTx1IE := True;
            when Output_2_Set_Interrupt =>
               This.TIMxDIER.SETx2IE := True;
            when Output_2_Reset_Interrupt =>
               This.TIMxDIER.RSTx2IE := True;
            when Reset_RollOver_Interrupt =>
               This.TIMxDIER.RSTIE := True;
            when Delayed_Protection_Interrupt =>
               This.TIMxDIER.DLYPRTIE := True;
         end case;
      end loop;
   end Enable_Interrupt;

   -----------------------
   -- Disable_Interrupt --
   -----------------------

   procedure Disable_Interrupt
     (This   : in out HRTimer_X;
      Source : HRTimer_X_Interrupt)
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            This.TIMxDIER.CMP1IE := False;
         when Compare_2_Interrupt =>
            This.TIMxDIER.CMP2IE := False;
         when Compare_3_Interrupt =>
            This.TIMxDIER.CMP3IE := False;
         when Compare_4_Interrupt =>
            This.TIMxDIER.CMP4IE := False;
         when Repetition_Interrupt =>
            This.TIMxDIER.REPIE := False;
         when Update_Interrupt =>
            This.TIMxDIER.UPDIE := False;
         when Capture_1_Interrupt =>
            This.TIMxDIER.CPT1IE := False;
         when Capture_2_Interrupt =>
            This.TIMxDIER.CPT2IE := False;
         when Output_1_Set_Interrupt =>
            This.TIMxDIER.SET1xIE := False;
         when Output_1_Reset_Interrupt =>
            This.TIMxDIER.RSTx1IE := False;
         when Output_2_Set_Interrupt =>
            This.TIMxDIER.SETx2IE := False;
         when Output_2_Reset_Interrupt =>
            This.TIMxDIER.RSTx2IE := False;
         when Reset_RollOver_Interrupt =>
            This.TIMxDIER.RSTIE := False;
         when Delayed_Protection_Interrupt =>
            This.TIMxDIER.DLYPRTIE := False;
      end case;
   end Disable_Interrupt;

   -----------------------
   -- Interrupt_Enabled --
   -----------------------

   function Interrupt_Enabled
     (This   : HRTimer_X;
      Source : HRTimer_X_Interrupt) return Boolean
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            return This.TIMxDIER.CMP1IE;
         when Compare_2_Interrupt =>
            return This.TIMxDIER.CMP2IE;
         when Compare_3_Interrupt =>
            return This.TIMxDIER.CMP3IE;
         when Compare_4_Interrupt =>
            return This.TIMxDIER.CMP4IE;
         when Repetition_Interrupt =>
            return This.TIMxDIER.REPIE;
         when Update_Interrupt =>
            return This.TIMxDIER.UPDIE;
         when Capture_1_Interrupt =>
            return This.TIMxDIER.CPT1IE;
         when Capture_2_Interrupt =>
            return This.TIMxDIER.CPT2IE;
         when Output_1_Set_Interrupt =>
            return This.TIMxDIER.SET1xIE;
         when Output_1_Reset_Interrupt =>
            return This.TIMxDIER.RSTx1IE;
         when Output_2_Set_Interrupt =>
            return This.TIMxDIER.SETx2IE;
         when Output_2_Reset_Interrupt =>
            return This.TIMxDIER.RSTx2IE;
         when Reset_RollOver_Interrupt =>
            return This.TIMxDIER.RSTIE;
         when Delayed_Protection_Interrupt =>
            return This.TIMxDIER.DLYPRTIE;
      end case;
   end Interrupt_Enabled;

   ----------------------
   -- Interrupt_Status --
   ----------------------

   function Interrupt_Status
     (This   : HRTimer_X;
      Source : HRTimer_X_Interrupt) return Boolean
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            return This.TIMxISR.CMP.Arr(1);
         when Compare_2_Interrupt =>
            return This.TIMxISR.CMP.Arr(2);
         when Compare_3_Interrupt =>
            return This.TIMxISR.CMP.Arr(3);
         when Compare_4_Interrupt =>
            return This.TIMxISR.CMP.Arr(4);
         when Repetition_Interrupt =>
            return This.TIMxISR.REP;
         when Update_Interrupt =>
            return This.TIMxISR.UPD;
         when Capture_1_Interrupt =>
            return This.TIMxISR.CPT.Arr(1);
         when Capture_2_Interrupt =>
            return This.TIMxISR.CPT.Arr(2);
         when Output_1_Set_Interrupt =>
            return This.TIMxISR.SETx1;
         when Output_1_Reset_Interrupt =>
            return This.TIMxISR.RSTx1;
         when Output_2_Set_Interrupt =>
            return This.TIMxISR.SETx2;
         when Output_2_Reset_Interrupt =>
            return This.TIMxISR.RSTx2;
         when Reset_RollOver_Interrupt =>
            return This.TIMxISR.RST;
         when Delayed_Protection_Interrupt =>
            return This.TIMxISR.DLYPRT;
      end case;
   end Interrupt_Status;

   -----------------------------
   -- Clear_Pending_Interrupt --
   -----------------------------

   procedure Clear_Pending_Interrupt
     (This   : in out HRTimer_X;
      Source : HRTimer_X_Interrupt)
   is
   begin
      case Source is
         when Compare_1_Interrupt =>
            This.TIMxICR.CMP1C := True;
         when Compare_2_Interrupt =>
            This.TIMxICR.CMP2C := True;
         when Compare_3_Interrupt =>
            This.TIMxICR.CMP3C := True;
         when Compare_4_Interrupt =>
            This.TIMxICR.CMP4C := True;
         when Repetition_Interrupt =>
            This.TIMxICR.REPC := True;
         when Update_Interrupt =>
            This.TIMxICR.UPDC := True;
         when Capture_1_Interrupt =>
            This.TIMxICR.CPT1C := True;
         when Capture_2_Interrupt =>
            This.TIMxICR.CPT2C := True;
         when Output_1_Set_Interrupt =>
            This.TIMxICR.SET1xC := True;
         when Output_1_Reset_Interrupt =>
            This.TIMxICR.RSTx1C := True;
         when Output_2_Set_Interrupt =>
            This.TIMxICR.SET2xC := True;
         when Output_2_Reset_Interrupt =>
            This.TIMxICR.RSTx2C := True;
         when Reset_RollOver_Interrupt =>
            This.TIMxICR.RSTC := True;
         when Delayed_Protection_Interrupt =>
            This.TIMxICR.DLYPRTC := True;
      end case;
   end Clear_Pending_Interrupt;

   -----------------------
   -- Enable_DMA_Source --
   -----------------------

   procedure Enable_DMA_Source
     (This   : in out HRTimer_X;
      Source : HRTimer_X_DMA_Request)
   is
   begin
      case Source is
         when Compare_1_DMA =>
            This.TIMxDIER.CMP1DE := True;
         when Compare_2_DMA =>
            This.TIMxDIER.CMP2DE := True;
         when Compare_3_DMA =>
            This.TIMxDIER.CMP3DE := True;
         when Compare_4_DMA =>
            This.TIMxDIER.CMP4DE := True;
         when Repetition_DMA =>
            This.TIMxDIER.REPDE := True;
         when Update_DMA =>
            This.TIMxDIER.UPDDE := True;
         when Capture_1_DMA =>
            This.TIMxDIER.CPT1DE := True;
         when Capture_2_DMA =>
            This.TIMxDIER.CPT2DE := True;
         when Output_1_Set_DMA =>
            This.TIMxDIER.SET1xDE := True;
         when Output_1_Reset_DMA =>
            This.TIMxDIER.RSTx1DE := True;
         when Output_2_Set_DMA =>
            This.TIMxDIER.SETx2DE := True;
         when Output_2_Reset_DMA =>
            This.TIMxDIER.RSTx2DE := True;
         when Reset_RollOver_DMA =>
            This.TIMxDIER.RSTDE := True;
         when Delayed_Protection_DMA =>
            This.TIMxDIER.DLYPRTDE := True;
      end case;
   end Enable_DMA_Source;

   ------------------------
   -- Disable_DMA_Source --
   ------------------------

   procedure Disable_DMA_Source
     (This   : in out HRTimer_X;
      Source : HRTimer_X_DMA_Request)
   is
   begin
      case Source is
         when Compare_1_DMA =>
            This.TIMxDIER.CMP1DE := False;
         when Compare_2_DMA =>
            This.TIMxDIER.CMP2DE := False;
         when Compare_3_DMA =>
            This.TIMxDIER.CMP3DE := False;
         when Compare_4_DMA =>
            This.TIMxDIER.CMP4DE := False;
         when Repetition_DMA =>
            This.TIMxDIER.REPDE := False;
         when Update_DMA =>
            This.TIMxDIER.UPDDE := False;
         when Capture_1_DMA =>
            This.TIMxDIER.CPT1DE := False;
         when Capture_2_DMA =>
            This.TIMxDIER.CPT2DE := False;
         when Output_1_Set_DMA =>
            This.TIMxDIER.SET1xDE := False;
         when Output_1_Reset_DMA =>
            This.TIMxDIER.RSTx1DE := False;
         when Output_2_Set_DMA =>
            This.TIMxDIER.SETx2DE := False;
         when Output_2_Reset_DMA =>
            This.TIMxDIER.RSTx2DE := False;
         when Reset_RollOver_DMA =>
            This.TIMxDIER.RSTDE := False;
         when Delayed_Protection_DMA =>
            This.TIMxDIER.DLYPRTDE := False;
      end case;
   end Disable_DMA_Source;

   -----------------------
   -- DMA_Source_Enabled --
   -----------------------

   function DMA_Source_Enabled
     (This   : HRTimer_X;
      Source : HRTimer_X_DMA_Request) return Boolean
   is
   begin
      case Source is
         when Compare_1_DMA =>
            return This.TIMxDIER.CMP1DE;
         when Compare_2_DMA =>
            return This.TIMxDIER.CMP2DE;
         when Compare_3_DMA =>
            return This.TIMxDIER.CMP3DE;
         when Compare_4_DMA =>
            return This.TIMxDIER.CMP4DE;
         when Repetition_DMA =>
            return This.TIMxDIER.REPDE;
         when Update_DMA =>
            return This.TIMxDIER.UPDDE;
         when Capture_1_DMA =>
            return This.TIMxDIER.CPT1DE;
         when Capture_2_DMA =>
            return This.TIMxDIER.CPT2DE;
         when Output_1_Set_DMA =>
            return This.TIMxDIER.SET1xDE;
         when Output_1_Reset_DMA =>
            return This.TIMxDIER.RSTx1DE;
         when Output_2_Set_DMA =>
            return This.TIMxDIER.SETx2DE;
         when Output_2_Reset_DMA =>
            return This.TIMxDIER.RSTx2DE;
         when Reset_RollOver_DMA =>
            return This.TIMxDIER.RSTDE;
         when Delayed_Protection_DMA =>
            return This.TIMxDIER.DLYPRTDE;
      end case;
   end DMA_Source_Enabled;

   -------------------
   --  Set_Deadtime --
   -------------------

   procedure Set_Deadtime (This : in out HRTimer_X; Enable : Boolean) is
   begin
      This.OUTxR.DTEN := Enable;
   end Set_Deadtime;

   -------------------
   -- Read_Deadtime --
   -------------------

   function Read_Deadtime (This : HRTimer_X) return Boolean is
   begin
      return This.OUTxR.DTEN;
   end Read_Deadtime;

   ------------------------
   -- Configure_Deadtime --
   ------------------------

   procedure Configure_Deadtime
     (This          : in out HRTimer_X;
      Prescaler     : UInt3;
      Rising_Value  : UInt9;
      Rising_Sign   : Boolean;
      Falling_Value : UInt9;
      Falling_Sign  : Boolean)
   is
   begin
      --  The deadtime (generator) time after the prescaler is defined by
      --  tDTG = tHRTIM / 8 * 2 ** DTPRSC. For tHRTIM = 1/144 MHz and
      --  DTPRSC = 0, tDTG = 868 ps; DTPRSC = 1, tDTG = 1.736 ns; and so on.
      This.DTxR.DTPRSC := Prescaler;

      --  Two deadtimes can be defined in relationship with the rising edge
      --  and the falling edge of the Output 1 reference waveform.
      --  The final deadtime after rising and falling values is defined by
      --  tDTR = DTRx * tDTG, and tDTF = DTFx * tDTG.
      --  See chapter 21.5.26 at pg. 742 in the RM0364 rev. 4.
      This.DTxR.DTRx := Rising_Value;
      This.DTxR.DTFx := Falling_Value;

      -- The sign determines whether the deadtime is positive or negative
      -- (overlaping signals). See pg. 649 in RM0364 rev. 4.
      This.DTxR.SDTRx := Rising_Sign;
      This.DTxR.SDTFx := Falling_Sign;
   end Configure_Deadtime;

   ------------------------
   -- Configure_Deadtime --
   ------------------------

   procedure Configure_Deadtime
     (This          : in out HRTimer_X;
      Rising_Value  : Float;
      Rising_Sign   : Boolean;
      Falling_Value : Float;
      Falling_Sign  : Boolean)
   is
      Timer_Frequency : constant UInt32 :=
        STM32.Device.Get_Clock_Source (This);
      --  The clock frequency of this timer.

      tHRTIM : constant Float := 1.0 / Float (Timer_Frequency);
      --  Time period for one cycle of the input timer frequency.

      Max_Divisor : Float;
      DTPRSC      : UInt3 := 0;
      DTRx        : UInt9;
      DTFx        : UInt9;
   begin
      --  The deadtime (generator) time after the prescaler is defined by
      --  tDTG = tHRTIM / 8 * 2 ** DTPRSC. The final deadtime after rising
      --  and falling values is defined by tDTR = DTRx * tDTG, and
      --  tDTF = DTFx * tDTG.
      --  See chapter 21.5.26 at pg. 742 in the RM0364 rev. 4.

      --  Test if the rising or falling deadtime is too large, that is, if
      --  it is greater then the maximum values of prescaler and rising or
      --  falling divisors.
      Max_Divisor := Float'Max (Rising_Value, Falling_Value) / (tHRTIM / 8.0);

      --  DTRx register is type UInt9, DTPRSC register is type UInt3. The value
      --  to be compared is 2 ** Natural (UInt3'Last) * UInt9'Last = 16#FFFF#,
      --  this is UInt16'Last.
      pragma Assert (UInt32 (Max_Divisor) > 16#FFFF#,
                     "This deadtime is too large.");

      --  Find the minimum prescaler value.
      while Max_Divisor > Float (2 ** Natural (DTPRSC) * UInt9'Last) loop
         DTPRSC := DTPRSC + 1;
      end loop;

      -- Save the minimum prescaler value into the prescaler register.
      This.DTxR.DTPRSC := DTPRSC;

      -- Calculates the rising deadtime value and save it into the register.
      DTRx := UInt9 (Rising_Value / (tHRTIM / 8.0) /
                       Float (2 ** Natural (DTPRSC)));
      This.DTxR.DTRx := DTRx;

      -- Calculates the falling deadtime value and save it into the register.
      DTFx := UInt9 (Falling_Value / (tHRTIM / 8.0) /
                       Float (2 ** Natural (DTPRSC)));
      This.DTxR.DTFx := DTFx;

      -- The sign determines whether the deadtime is positive or negative
      -- (overlaping signals). See pg. 649 in RM0364 rev. 4.
      This.DTxR.SDTRx := Rising_Sign;
      This.DTxR.SDTFx := Falling_Sign;
   end Configure_Deadtime;

   -----------------------
   -- Set_Deadtime_Lock --
   -----------------------

   procedure Set_Deadtime_Lock
     (This : in out HRTimer_X; Lock : Deadtime_Lock) is
   begin
      This.DTxR.DTRLKx := Lock.Rising_Value;
      This.DTxR.DTRSLKx := Lock.Rising_Sign;
      This.DTxR.DTFLKx := Lock.Falling_Value;
      This.DTxR.DTFSLKx := Lock.Falling_Sign;
   end Set_Deadtime_Lock;

   ------------------------
   -- Read_Deadtime_Lock --
   ------------------------

   function Read_Deadtime_Lock (This : HRTimer_X) return Deadtime_Lock is
      Lock : Deadtime_Lock;
   begin
      Lock.Rising_Value := This.DTxR.DTRLKx;
      Lock.Rising_Sign := This.DTxR.DTRSLKx;
      Lock.Falling_Value := This.DTxR.DTFLKx;
      Lock.Falling_Sign := This.DTxR.DTFSLKx;
      return Lock;
   end Read_Deadtime_Lock;

   ----------------------------
   -- Configure_Output_Event --
   ----------------------------

   procedure Configure_Output_Event
     (This        : in out HRTimer_X;
      Output      : Output_Number;
      Set_Event   : Output_Event;
      Reset_Event : Output_Event)
   is
   begin
      case Output is
         when Output_1 =>
            This.SETx1R := 2 ** Set_Event'Enum_Rep;
            This.RSTx1R := 2 ** Reset_Event'Enum_Rep;
         when Output_2 =>
            This.SETx2R := 2 ** Set_Event'Enum_Rep;
            This.RSTx2R := 2 ** Reset_Event'Enum_Rep;
      end case;
   end Configure_Output_Event;

   ------------------------------
   -- Configure_External_Event --
   ------------------------------

   procedure Configure_External_Event
     (This         : in out HRTimer_X;
      Event_Number : External_Event_Number;
      Event_Latch  : External_Event_Latch;
      Event_Filter : External_Event_Blanking_Filter)
   is
   begin
      case Event_Number is
         when Event_1 =>
            This.EEFxR1.EE1LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR1.EE1FLTR := Event_Filter'Enum_Rep;
         when Event_2 =>
            This.EEFxR1.EE2LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR1.EE2FLTR := Event_Filter'Enum_Rep;
         when Event_3 =>
            This.EEFxR1.EE3LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR1.EE3FLTR := Event_Filter'Enum_Rep;
         when Event_4 =>
            This.EEFxR1.EE4LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR1.EE4FLTR := Event_Filter'Enum_Rep;
         when Event_5 =>
            This.EEFxR1.EE5LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR1.EE5FLTR := Event_Filter'Enum_Rep;
         when Event_6 =>
            This.EEFxR2.EE6LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR2.EE6FLTR := Event_Filter'Enum_Rep;
         when Event_7 =>
            This.EEFxR2.EE7LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR2.EE7FLTR := Event_Filter'Enum_Rep;
         when Event_8 =>
            This.EEFxR2.EE8LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR2.EE8FLTR := Event_Filter'Enum_Rep;
         when Event_9 =>
            This.EEFxR2.EE9LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR2.EE9FLTR := Event_Filter'Enum_Rep;
         when Event_10 =>
            This.EEFxR2.EE10LTCH := Boolean'Val (Event_Latch'Enum_Rep);
            This.EEFxR2.EE10FLTR := Event_Filter'Enum_Rep;
      end case;

   end Configure_External_Event;

   ----------------------
   -- Set_Chopper_Mode --
   ----------------------

   procedure Set_Chopper_Mode
     (This     : in out HRTimer_X;
      Output_1 : Boolean;
      Output_2 : Boolean)
   is
   begin
      This.OUTxR.CHP1 := Output_1;
      This.OUTxR.CHP2 := Output_2;
   end Set_Chopper_Mode;

   --------------------------
   -- Enabled_Chopper_Mode --
   --------------------------

   function Enabled_Chopper_Mode (This : HRTimer_X) return Boolean is
   begin
      if (This.OUTxR.CHP1 or This.OUTxR.CHP2) then
         return True;
      end if;
      return False;
   end Enabled_Chopper_Mode;

   ----------------------------
   -- Configure_Chopper_Mode --
   ----------------------------

   procedure Configure_Chopper_Mode
     (This              : in out HRTimer_X;
      Output_1          : Boolean;
      Output_2          : Boolean;
      Carrier_Frequency : Chopper_Carrier_Frequency;
      Duty_Cycle        : Chopper_Duty_Cycle;
      Start_PulseWidth  : Chopper_Start_PulseWidth)
   is
   begin
      This.OUTxR.CHP1 := Output_1;
      This.OUTxR.CHP2 := Output_2;
      This.CHPxR.CHPFRQ := Carrier_Frequency'Enum_Rep;
      This.CHPxR.CHPDTY := Duty_Cycle'Enum_Rep;
      This.CHPxR.STRTPW := Start_PulseWidth'Enum_Rep;
   end Configure_Chopper_Mode;

   ----------------------
   -- Set_Fault_Source --
   ----------------------

   procedure Set_Fault_Source
     (This   : in out HRTimer_X;
      Source : HRTimer_Fault_Source;
      Enable : Boolean) is
   begin
      case Source is
         when Fault_1 =>
            This.FLTxR.FLT1EN := Enable;
         when Fault_2 =>
            This.FLTxR.FLT2EN := Enable;
         when Fault_3 =>
            This.FLTxR.FLT3EN := Enable;
         when Fault_4 =>
            This.FLTxR.FLT4EN := Enable;
         when Fault_5 =>
            This.FLTxR.FLT5EN := Enable;
      end case;
   end Set_Fault_Source;

   --------------------------
   -- Enabled_Fault_Source --
   --------------------------

   function Enabled_Fault_Source
     (This : HRTimer_X;
      Source : HRTimer_Fault_Source) return Boolean is
   begin
      case Source is
         when Fault_1 =>
            return This.FLTxR.FLT1EN;
         when Fault_2 =>
            return This.FLTxR.FLT2EN;
         when Fault_3 =>
            return This.FLTxR.FLT3EN;
         when Fault_4 =>
            return This.FLTxR.FLT4EN;
         when Fault_5 =>
            return This.FLTxR.FLT5EN;
      end case;
   end Enabled_Fault_Source;

   ---------------------------
   -- Set_Fault_Source_Lock --
   ---------------------------

   procedure Set_Fault_Source_Lock (This : in out HRTimer_X) is
   begin
      This.FLTxR.FLTLCK := True;
   end Set_Fault_Source_Lock;

   -------------------------------
   -- Enabled_Fault_Source_Lock --
   -------------------------------

   function Enabled_Fault_Source_Lock (This : HRTimer_X) return Boolean is
   begin
      return This.FLTxR.FLTLCK;
   end Enabled_Fault_Source_Lock;

   ----------------------------------------------------------------------------

   --  HRTimer Common functions -----------------------------------------------

   ----------------------------------------------------------------------------

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_Interrupt (Source : HRTimer_Common_Interrupt) is
   begin
      case Source is
         when Fault_1_Interrupt =>
            HRTimer_Common_Periph.IER.FLT1IE := True;
         when Fault_2_Interrupt =>
            HRTimer_Common_Periph.IER.FLT2IE := True;
         when Fault_3_Interrupt =>
            HRTimer_Common_Periph.IER.FLT3IE := True;
         when Fault_4_Interrupt =>
            HRTimer_Common_Periph.IER.FLT4IE := True;
         when Fault_5_Interrupt =>
            HRTimer_Common_Periph.IER.FLT5IE := True;
         when System_Fault_Interrupt =>
            HRTimer_Common_Periph.IER.SYSFLTE := True;
         when DLL_Ready_Interrupt =>
            HRTimer_Common_Periph.IER.DLLRDYIE := True;
         when Burst_Mode_Period_Interrupt =>
            HRTimer_Common_Periph.IER.BMPERIE := True;
      end case;
   end Enable_Interrupt;

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_Interrupt
     (Sources : HRTimer_Common_Interrupt_List)
   is
   begin
      for Source of Sources loop
         case Source is
            when Fault_1_Interrupt =>
               HRTimer_Common_Periph.IER.FLT1IE := True;
            when Fault_2_Interrupt =>
               HRTimer_Common_Periph.IER.FLT2IE := True;
            when Fault_3_Interrupt =>
               HRTimer_Common_Periph.IER.FLT3IE := True;
            when Fault_4_Interrupt =>
               HRTimer_Common_Periph.IER.FLT4IE := True;
            when Fault_5_Interrupt =>
               HRTimer_Common_Periph.IER.FLT5IE := True;
            when System_Fault_Interrupt =>
               HRTimer_Common_Periph.IER.SYSFLTE := True;
            when DLL_Ready_Interrupt =>
               HRTimer_Common_Periph.IER.DLLRDYIE := True;
            when Burst_Mode_Period_Interrupt =>
               HRTimer_Common_Periph.IER.BMPERIE := True;
         end case;
      end loop;
   end Enable_Interrupt;

   -----------------------
   -- Disable_Interrupt --
   -----------------------

   procedure Disable_Interrupt
     (Source : HRTimer_Common_Interrupt)
   is
   begin
      case Source is
         when Fault_1_Interrupt =>
            HRTimer_Common_Periph.IER.FLT1IE := False;
         when Fault_2_Interrupt =>
            HRTimer_Common_Periph.IER.FLT2IE := False;
         when Fault_3_Interrupt =>
            HRTimer_Common_Periph.IER.FLT3IE := False;
         when Fault_4_Interrupt =>
            HRTimer_Common_Periph.IER.FLT4IE := False;
         when Fault_5_Interrupt =>
            HRTimer_Common_Periph.IER.FLT5IE := False;
         when System_Fault_Interrupt =>
            HRTimer_Common_Periph.IER.SYSFLTE := False;
         when DLL_Ready_Interrupt =>
            HRTimer_Common_Periph.IER.DLLRDYIE := False;
         when Burst_Mode_Period_Interrupt =>
            HRTimer_Common_Periph.IER.BMPERIE := False;
      end case;
   end Disable_Interrupt;

   -----------------------
   -- Interrupt_Enabled --
   -----------------------

   function Interrupt_Enabled
     (Source : HRTimer_Common_Interrupt) return Boolean
   is
   begin
      case Source is
         when Fault_1_Interrupt =>
            return HRTimer_Common_Periph.IER.FLT1IE;
         when Fault_2_Interrupt =>
            return HRTimer_Common_Periph.IER.FLT2IE;
         when Fault_3_Interrupt =>
            return HRTimer_Common_Periph.IER.FLT3IE;
         when Fault_4_Interrupt =>
            return HRTimer_Common_Periph.IER.FLT4IE;
         when Fault_5_Interrupt =>
            return HRTimer_Common_Periph.IER.FLT5IE;
         when System_Fault_Interrupt =>
            return HRTimer_Common_Periph.IER.SYSFLTE;
         when DLL_Ready_Interrupt =>
            return HRTimer_Common_Periph.IER.DLLRDYIE;
         when Burst_Mode_Period_Interrupt =>
            return HRTimer_Common_Periph.IER.BMPERIE;
      end case;
   end Interrupt_Enabled;

   ----------------------
   -- Interrupt_Status --
   ----------------------

   function Interrupt_Status
     (Source : HRTimer_Common_Interrupt) return Boolean
   is
   begin
      case Source is
         when Fault_1_Interrupt =>
            return HRTimer_Common_Periph.ISR.FLT.Arr(1);
         when Fault_2_Interrupt =>
            return HRTimer_Common_Periph.ISR.FLT.Arr(2);
         when Fault_3_Interrupt =>
            return HRTimer_Common_Periph.ISR.FLT.Arr(3);
         when Fault_4_Interrupt =>
            return HRTimer_Common_Periph.ISR.FLT.Arr(4);
         when Fault_5_Interrupt =>
            return HRTimer_Common_Periph.ISR.FLT.Arr(5);
         when System_Fault_Interrupt =>
            return HRTimer_Common_Periph.ISR.SYSFLT;
         when DLL_Ready_Interrupt =>
            return HRTimer_Common_Periph.ISR.DLLRDY;
         when Burst_Mode_Period_Interrupt =>
            return HRTimer_Common_Periph.ISR.BMPER;
      end case;
   end Interrupt_Status;

   -----------------------------
   -- Clear_Pending_Interrupt --
   -----------------------------

   procedure Clear_Pending_Interrupt
     (Source : HRTimer_Common_Interrupt)
   is
   begin
      case Source is
         when Fault_1_Interrupt =>
            HRTimer_Common_Periph.ICR.FLT1C := True;
         when Fault_2_Interrupt =>
            HRTimer_Common_Periph.ICR.FLT2C := True;
         when Fault_3_Interrupt =>
            HRTimer_Common_Periph.ICR.FLT3C := True;
         when Fault_4_Interrupt =>
            HRTimer_Common_Periph.ICR.FLT4C := True;
         when Fault_5_Interrupt =>
            HRTimer_Common_Periph.ICR.FLT5C := True;
         when System_Fault_Interrupt =>
            HRTimer_Common_Periph.ICR.SYSFLTC := True;
         when DLL_Ready_Interrupt =>
            HRTimer_Common_Periph.ICR.DLLRDYC := True;
         when Burst_Mode_Period_Interrupt =>
            HRTimer_Common_Periph.ICR.BMPERC := True;
      end case;
   end Clear_Pending_Interrupt;

   -------------------
   -- Enable_Output --
   -------------------

   procedure Enable_Output
     (This : HRTimer_X;
      Output_1 : Boolean;
      Output_2 : Boolean)
   is
   begin
      if This'Address = HRTIM_TIMA_Base then
         HRTimer_Common_Periph.OENR.TA1OEN := Output_1;
         HRTimer_Common_Periph.OENR.TA2OEN := Output_2;

      elsif This'Address = HRTIM_TIMB_Base then
         HRTimer_Common_Periph.OENR.TB1OEN := Output_1;
         HRTimer_Common_Periph.OENR.TB2OEN := Output_2;

      elsif This'Address = HRTIM_TIMC_Base then
         HRTimer_Common_Periph.OENR.TC1OEN := Output_1;
         HRTimer_Common_Periph.OENR.TC2OEN := Output_2;

      elsif This'Address = HRTIM_TIMD_Base then
         HRTimer_Common_Periph.OENR.TD1OEN := Output_1;
         HRTimer_Common_Periph.OENR.TD2OEN := Output_2;

      elsif This'Address = HRTIM_TIME_Base then
         HRTimer_Common_Periph.OENR.TE1OEN := Output_1;
         HRTimer_Common_Periph.OENR.TE2OEN := Output_2;
      end if;
   end Enable_Output;

   --------------------
   -- Disable_Output --
   --------------------

   procedure Disable_Output
     (This : HRTimer_X;
      Output_1 : Boolean;
      Output_2 : Boolean)
   is
   begin
      if This'Address = HRTIM_TIMA_Base then
         HRTimer_Common_Periph.ODISR.TA1ODIS := Output_1;
         HRTimer_Common_Periph.ODISR.TA2ODIS := Output_2;

      elsif This'Address = HRTIM_TIMB_Base then
         HRTimer_Common_Periph.ODISR.TB1ODIS := Output_1;
         HRTimer_Common_Periph.ODISR.TB2ODIS := Output_2;

      elsif This'Address = HRTIM_TIMC_Base then
         HRTimer_Common_Periph.ODISR.TC1ODIS := Output_1;
         HRTimer_Common_Periph.ODISR.TC2ODIS := Output_2;

      elsif This'Address = HRTIM_TIMD_Base then
         HRTimer_Common_Periph.ODISR.TD1ODIS := Output_1;
         HRTimer_Common_Periph.ODISR.TD2ODIS := Output_2;

      elsif This'Address = HRTIM_TIME_Base then
         HRTimer_Common_Periph.ODISR.TE1ODIS := Output_1;
         HRTimer_Common_Periph.ODISR.TE2ODIS := Output_2;
      end if;
   end Disable_Output;

   -------------------
   -- Output_Status --
   -------------------

   function Output_Status
     (This : HRTimer_X) return Output_Status_List
   is
      Output : Output_Status_List;
   begin
      if This'Address = HRTIM_TIMA_Base then
         if HRTimer_Common_Periph.OENR.TA1OEN then
            Output (1) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TA1ODS then
               Output (1) := Fault;
            else
               Output (1) := Idle;
            end if;
         end if;

         if  HRTimer_Common_Periph.OENR.TA2OEN then
            Output (2) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TA2ODS then
               Output (2) := Fault;
            else
               Output (2) := Idle;
            end if;
         end if;
      elsif This'Address = HRTIM_TIMB_Base then
         if HRTimer_Common_Periph.OENR.TB1OEN then
            Output (1) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TB1ODS then
               Output (1) := Fault;
            else
               Output (1) := Idle;
            end if;
         end if;

         if  HRTimer_Common_Periph.OENR.TB2OEN then
            Output (2) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TB2ODS then
               Output (2) := Fault;
            else
               Output (2) := Idle;
            end if;
         end if;
      elsif This'Address = HRTIM_TIMC_Base then
         if HRTimer_Common_Periph.OENR.TC1OEN then
            Output (1) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TC1ODS then
               Output (1) := Fault;
            else
               Output (1) := Idle;
            end if;
         end if;

         if  HRTimer_Common_Periph.OENR.TC2OEN then
            Output (2) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TC2ODS then
               Output (2) := Fault;
            else
               Output (2) := Idle;
            end if;
         end if;
      elsif This'Address = HRTIM_TIMD_Base then
         if HRTimer_Common_Periph.OENR.TD1OEN then
            Output (1) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TD1ODS then
               Output (1) := Fault;
            else
               Output (1) := Idle;
            end if;
         end if;

         if  HRTimer_Common_Periph.OENR.TD2OEN then
            Output (2) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TD2ODS then
               Output (2) := Fault;
            else
               Output (2) := Idle;
            end if;
         end if;
      elsif This'Address = HRTIM_TIME_Base then
         if HRTimer_Common_Periph.OENR.TE1OEN then
            Output (1) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TE1ODS then
               Output (1) := Fault;
            else
               Output (1) := Idle;
            end if;
         end if;

         if  HRTimer_Common_Periph.OENR.TE2OEN then
            Output (2) := Enabled;
         else
            if HRTimer_Common_Periph.ODSR.TE2ODS then
               Output (2) := Fault;
            else
               Output (2) := Idle;
            end if;
         end if;
      end if;

      return Output;
   end Output_Status;

   ------------------------
   -- No_Outputs_Enabled --
   ------------------------

   function No_Outputs_Enabled (This : HRTimer_x) return Boolean is
   begin
      if This'Address = HRTIM_TIMA_Base then
         if (HRTimer_Common_Periph.OENR.TA1OEN or
           HRTimer_Common_Periph.OENR.TA2OEN)
         then
            return False;
         end if;
      elsif This'Address = HRTIM_TIMB_Base then
         if (HRTimer_Common_Periph.OENR.TB1OEN or
           HRTimer_Common_Periph.OENR.TB2OEN)
         then
            return False;
         end if;
      elsif This'Address = HRTIM_TIMC_Base then
         if (HRTimer_Common_Periph.OENR.TC1OEN or
           HRTimer_Common_Periph.OENR.TC2OEN)
         then
            return False;
         end if;
      elsif This'Address = HRTIM_TIMD_Base then
         if (HRTimer_Common_Periph.OENR.TD1OEN or
           HRTimer_Common_Periph.OENR.TD2OEN)
         then
            return False;
         end if;
      elsif This'Address = HRTIM_TIME_Base then
         if (HRTimer_Common_Periph.OENR.TE1OEN or
           HRTimer_Common_Periph.OENR.TE2OEN)
         then
            return False;
         end if;
      end if;
      return True;
   end No_Outputs_Enabled;

   -----------------------
   -- Enable_Burst_Mode --
   -----------------------

   procedure Enable_Burst_Mode is
   begin
      HRTimer_Common_Periph.BMCR.BME := True;
   end Enable_Burst_Mode;

   ------------------------
   -- Disable_Burst_Mode --
   ------------------------

   procedure Disable_Burst_Mode is
   begin
      HRTimer_Common_Periph.BMCR.BME := False;
   end Disable_Burst_Mode;

   ------------------------
   -- Burst_Mode_Enabled --
   ------------------------

   function Burst_Mode_Enabled return Boolean is
   begin
      return HRTimer_Common_Periph.BMCR.BME;
   end Burst_Mode_Enabled;

   -----------------------
   -- Burst_Mode_Status --
   -----------------------

   function Burst_Mode_Status return Boolean is
   begin
      return HRTimer_Common_Periph.BMCR.BMSTAT;
   end Burst_Mode_Status;

   --------------------------
   -- Configure_Burst_Mode --
   --------------------------

   procedure Configure_Burst_Mode
     (Operating_Mode : Burst_Mode_Operating_Mode;
      Clock_Source   : Burst_Mode_Clock_Source;
      Prescaler      : Burst_Mode_Prescaler;
      Preload_Enable : Boolean)
   is
   begin
      HRTimer_Common_Periph.BMCR.BMOM := Boolean'Val (Operating_Mode'Enum_Rep);
      HRTimer_Common_Periph.BMCR.BMCLK := Clock_Source'Enum_Rep;
      HRTimer_Common_Periph.BMCR.BMPRSC := Prescaler'Enum_Rep;
      HRTimer_Common_Periph.BMCR.BMPREN := Preload_Enable;
   end Configure_Burst_Mode;

   ----------------------------------
   -- Configure_HRTimer_Burst_Mode --
   ----------------------------------

   procedure Configure_HRTimer_Burst_Mode
     (Counter : HRTimer;
      Mode    : Burst_Mode_HRTimer_Mode)
   is
   begin
      case Counter is
         when HRTimer_M =>
            HRTimer_Common_Periph.BMCR.MTBM := Boolean'Val (Mode'Enum_Rep);
         when HRTimer_A =>
            HRTimer_Common_Periph.BMCR.TABM := Boolean'Val (Mode'Enum_Rep);
         when HRTimer_B =>
            HRTimer_Common_Periph.BMCR.TBBM := Boolean'Val (Mode'Enum_Rep);
         when HRTimer_C =>
            HRTimer_Common_Periph.BMCR.TCBM := Boolean'Val (Mode'Enum_Rep);
         when HRTimer_D =>
            HRTimer_Common_Periph.BMCR.TDBM := Boolean'Val (Mode'Enum_Rep);
         when HRTimer_E =>
            HRTimer_Common_Periph.BMCR.TEBM := Boolean'Val (Mode'Enum_Rep);
      end case;
   end Configure_HRTimer_Burst_Mode;

   ----------------------------------
   -- Configure_Burst_Mode_Trigger --
   ----------------------------------

   procedure Configure_Burst_Mode_Trigger
     (Triggers : Burst_Mode_Trigger_List;
      Value    : Boolean)
   is
   begin
      if Value then
         for Trigger of Triggers loop
            HRTimer_Common_Periph.BMTRGR :=
              HRTimer_Common_Periph.BMTRGR or (2 ** Trigger'Enum_Rep);
         end loop;
      else
         for Trigger of Triggers loop
            HRTimer_Common_Periph.BMTRGR :=
              HRTimer_Common_Periph.BMTRGR and not (2 ** Trigger'Enum_Rep);
         end loop;
      end if;
   end Configure_Burst_Mode_Trigger;

   ------------------------------
   --  Set_Burst_Mode_Compare  --
   ------------------------------

   procedure Set_Burst_Mode_Compare (Value : UInt16) is
   begin
      HRTimer_Common_Periph.BMCMPR.BMCMP := Value;
   end  Set_Burst_Mode_Compare;

   -----------------------------
   --  Set_Burst_Mode_Period  --
   -----------------------------

   procedure Set_Burst_Mode_Period (Value : UInt16) is
   begin
      HRTimer_Common_Periph.BMPER.BMPER := Value;
   end  Set_Burst_Mode_Period;

   ------------------------------
   -- Configure_External_Event --
   ------------------------------

   procedure Configure_External_Event
     (Number      : External_Event_Number;
      Source      : External_Event_Source;
      Polarity    : External_Event_Polarity;
      Sensitivity : External_Event_Sensitivity;
      Fast_Mode   : External_Event_Fast_Mode;
      Filter      : External_Event_Frequency_Filter)
   is
   begin
      case Number is
         when Event_1 =>
            HRTimer_Common_Periph.EECR1.EE1SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE1POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR1.EE1SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE1FAST := Boolean'Val (Fast_Mode'Enum_Rep);
         when Event_2 =>
            HRTimer_Common_Periph.EECR1.EE2SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE2POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR1.EE2SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE2FAST := Boolean'Val (Fast_Mode'Enum_Rep);
         when Event_3 =>
            HRTimer_Common_Periph.EECR1.EE3SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE3POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR1.EE3SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE3FAST := Boolean'Val (Fast_Mode'Enum_Rep);
         when Event_4 =>
            HRTimer_Common_Periph.EECR1.EE4SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE4POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR1.EE4SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE4FAST := Boolean'Val (Fast_Mode'Enum_Rep);
         when Event_5 =>
            HRTimer_Common_Periph.EECR1.EE5SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE5POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR1.EE5SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR1.EE5FAST := Boolean'Val (Fast_Mode'Enum_Rep);
         when Event_6 =>
            HRTimer_Common_Periph.EECR2.EE6SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR2.EE6POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR2.EE6SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR3.EE6F := Filter'Enum_Rep;
         when Event_7 =>
            HRTimer_Common_Periph.EECR2.EE7SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR2.EE7POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR2.EE7SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR3.EE7F := Filter'Enum_Rep;
         when Event_8 =>
            HRTimer_Common_Periph.EECR2.EE8SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR2.EE8POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR2.EE8SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR3.EE8F := Filter'Enum_Rep;
         when Event_9 =>
            HRTimer_Common_Periph.EECR2.EE9SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR2.EE9POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR2.EE9SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR3.EE9F := Filter'Enum_Rep;
         when Event_10 =>
            HRTimer_Common_Periph.EECR2.EE10SRC := Source'Enum_Rep;
            HRTimer_Common_Periph.EECR2.EE10POL := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.EECR2.EE10SNS := Sensitivity'Enum_Rep;
            HRTimer_Common_Periph.EECR3.EE10F := Filter'Enum_Rep;
      end case;
   end Configure_External_Event;

   ------------------------------------
   -- Configure_External_Event_Clock --
   ------------------------------------

   procedure Configure_External_Event_Clock
     (Clock : External_Event_Sampling_Clock)
   is
   begin
      HRTimer_Common_Periph.EECR3.EEVSD := Clock'Enum_Rep;
   end Configure_External_Event_Clock;

   ---------------------------
   -- Configure_ADC_Trigger --
   ---------------------------

   procedure Configure_ADC_Trigger
     (Output   : ADC_1_3_Trigger_Output;
      Triggers : ADC_1_3_Trigger_List)
   is
   begin
      case Output is
         when ADC_Trigger_1 =>
            for Trigger of Triggers loop
               HRTimer_Common_Periph.ADC1R :=
                 HRTimer_Common_Periph.ADC1R or (2 ** Trigger'Enum_Rep);
            end loop;
         when ADC_Trigger_3 =>
            for Trigger of Triggers loop
               HRTimer_Common_Periph.ADC3R :=
                 HRTimer_Common_Periph.ADC3R or (2 ** Trigger'Enum_Rep);
            end loop;
      end case;
   end Configure_ADC_Trigger;

   ---------------------------
   -- Configure_ADC_Trigger --
   ---------------------------

   procedure Configure_ADC_Trigger
     (Output   : ADC_2_4_Trigger_Output;
      Triggers : ADC_2_4_Trigger_List)
   is
   begin
      case Output is
         when ADC_Trigger_2 =>
            for Trigger of Triggers loop
               HRTimer_Common_Periph.ADC2R :=
                 HRTimer_Common_Periph.ADC2R or (2 ** Trigger'Enum_Rep);
            end loop;
         when ADC_Trigger_4 =>
            for Trigger of Triggers loop
               HRTimer_Common_Periph.ADC4R :=
                 HRTimer_Common_Periph.ADC4R or (2 ** Trigger'Enum_Rep);
            end loop;
      end case;
   end Configure_ADC_Trigger;

   ----------------------------------
   -- Configure_ADC_Trigger_Update --
   ----------------------------------

   procedure Configure_ADC_Trigger_Update
     (Output : ADC_Trigger_Output;
      Source : ADC_Trigger_Update_Source)
   is
   begin
      case Output is
         when ADC_Trigger_1 =>
            HRTimer_Common_Periph.CR1.AD1USRC := Source'Enum_Rep;
         when ADC_Trigger_2 =>
            HRTimer_Common_Periph.CR1.AD2USRC := Source'Enum_Rep;
         when ADC_Trigger_3 =>
            HRTimer_Common_Periph.CR1.AD3USRC := Source'Enum_Rep;
         when ADC_Trigger_4 =>
            HRTimer_Common_Periph.CR1.AD4USRC := Source'Enum_Rep;
      end case;
   end Configure_ADC_Trigger_Update;

   -------------------------------
   -- Configure_DLL_Calibration --
   -------------------------------

   procedure Configure_DLL_Calibration
     (Calibration_Start    : Boolean;
      Periodic_Calibration : Boolean;
      Calibration_Rate     : DLL_Calibration) is
   begin
      if Calibration_Start then
         HRTimer_Common_Periph.DLLCR.CALEN := False;
         HRTimer_Common_Periph.DLLCR.CAL := True;

         --  Wait for DLL calibration end
         while not HRTimer_Common_Periph.ISR.DLLRDY loop
            null;
         end loop;

         --  Clear DLL ready flag
         HRTimer_Common_Periph.ISR.DLLRDY := True;
      end if;

      HRTimer_Common_Periph.DLLCR.CALEN := Periodic_Calibration;
      HRTimer_Common_Periph.DLLCR.CALRTE := Calibration_Rate'Enum_Rep;
   end Configure_DLL_Calibration;

   ---------------------------
   -- Configure_Fault_Input --
   ---------------------------

   procedure Configure_Fault_Input
     (Input    : HRTimer_Fault_Source;
      Enable   : Boolean;
      Polarity : Fault_Input_Polarity;
      Source   : Fault_Input_Source;
      Filter   : Fault_Input_Filter)
   is
   begin
      case Input is
         when Fault_1 =>
            HRTimer_Common_Periph.FLTINR1.FLT1E := Enable;
            HRTimer_Common_Periph.FLTINR1.FLT1P := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.FLTINR1.FLT1SRC := Boolean'Val (Source'Enum_Rep);
            HRTimer_Common_Periph.FLTINR1.FLT1F := Filter'Enum_Rep;
         when Fault_2 =>
            HRTimer_Common_Periph.FLTINR1.FLT2E := Enable;
            HRTimer_Common_Periph.FLTINR1.FLT2P := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.FLTINR1.FLT2SRC := Boolean'Val (Source'Enum_Rep);
            HRTimer_Common_Periph.FLTINR1.FLT2F := Filter'Enum_Rep;
         when Fault_3 =>
            HRTimer_Common_Periph.FLTINR1.FLT3E := Enable;
            HRTimer_Common_Periph.FLTINR1.FLT3P := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.FLTINR1.FLT3SRC := Boolean'Val (Source'Enum_Rep);
            HRTimer_Common_Periph.FLTINR1.FLT3F := Filter'Enum_Rep;
         when Fault_4 =>
            HRTimer_Common_Periph.FLTINR1.FLT4E := Enable;
            HRTimer_Common_Periph.FLTINR1.FLT4P := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.FLTINR1.FLT4SRC := Boolean'Val (Source'Enum_Rep);
            HRTimer_Common_Periph.FLTINR1.FLT4F := Filter'Enum_Rep;
         when Fault_5 =>
            HRTimer_Common_Periph.FLTINR2.FLT5E := Enable;
            HRTimer_Common_Periph.FLTINR2.FLT5P := Boolean'Val (Polarity'Enum_Rep);
            HRTimer_Common_Periph.FLTINR2.FLT5SRC := Boolean'Val (Source'Enum_Rep);
            HRTimer_Common_Periph.FLTINR2.FLT5F := Filter'Enum_Rep;
      end case;
   end Configure_Fault_Input;

   --------------------------
   -- Set_Fault_Input_Lock --
   --------------------------

   procedure Set_Fault_Input_Lock (Input : HRTimer_Fault_Source) is
   begin
      case Input is
         when Fault_1 =>
            HRTimer_Common_Periph.FLTINR1.FLT1LCK := True;
         when Fault_2 =>
            HRTimer_Common_Periph.FLTINR1.FLT2LCK := True;
         when Fault_3 =>
            HRTimer_Common_Periph.FLTINR1.FLT3LCK := True;
         when Fault_4 =>
            HRTimer_Common_Periph.FLTINR1.FLT4LCK := True;
         when Fault_5 =>
            HRTimer_Common_Periph.FLTINR2.FLT5LCK := True;
      end case;
   end Set_Fault_Input_Lock;

   ------------------------------
   -- Enabled_Fault_Input_Lock --
   ------------------------------

   function Enabled_Fault_Input_Lock
     (Input : HRTimer_Fault_Source) return Boolean
   is
   begin
      case Input is
         when Fault_1 =>
            return HRTimer_Common_Periph.FLTINR1.FLT1LCK;
         when Fault_2 =>
            return HRTimer_Common_Periph.FLTINR1.FLT2LCK;
         when Fault_3 =>
            return HRTimer_Common_Periph.FLTINR1.FLT3LCK;
         when Fault_4 =>
            return HRTimer_Common_Periph.FLTINR1.FLT4LCK;
         when Fault_5 =>
            return HRTimer_Common_Periph.FLTINR2.FLT5LCK;
      end case;
   end Enabled_Fault_Input_Lock;

   ---------------------------------
   -- Configure_Fault_Input_Clock --
   ---------------------------------

   procedure Configure_Fault_Input_Clock (Clock : Fault_Input_Sampling_Clock) is
   begin
      HRTimer_Common_Periph.FLTINR2.FLTSD := Clock'Enum_Rep;
   end Configure_Fault_Input_Clock;

   --------------------------------
   -- Set_Burst_DMA_Timer_Update --
   --------------------------------

   procedure Set_Burst_DMA_Timer_Update
     (Counter   : HRTimer_Master;
      Registers : Burst_DMA_Master_Update_List;
      Value     : Boolean)
   is
      pragma Unreferenced (Counter);
   begin
      if Value then
         for Register of Registers loop
            HRTimer_Common_Periph.BDMUPR :=
              HRTimer_Common_Periph.BDMUPR or (2 ** Register'Enum_Rep);
         end loop;
      else
         for Register of Registers loop
            HRTimer_Common_Periph.BDMUPR :=
              HRTimer_Common_Periph.BDMUPR and not (2 ** Register'Enum_Rep);
         end loop;
      end if;
   end Set_Burst_DMA_Timer_Update;

   --------------------------------
   -- Set_Burst_DMA_Timer_Update --
   --------------------------------

   procedure Set_Burst_DMA_Timer_Update
     (Counter   : HRTimer_X;
      Registers : Burst_DMA_TimerX_Update_List;
      Value     : Boolean)
   is
   begin
      if Counter'Address = HRTIM_TIMA_Base then
         if Value then
            for Register of Registers loop
               HRTimer_Common_Periph.BDTAUPR :=
                 HRTimer_Common_Periph.BDTAUPR or (2 ** Register'Enum_Rep);
            end loop;
         else
            for Register of Registers loop
               HRTimer_Common_Periph.BDTAUPR :=
                 HRTimer_Common_Periph.BDTAUPR and not (2 ** Register'Enum_Rep);
            end loop;
         end if;

      elsif Counter'Address = HRTIM_TIMB_Base then
         if Value then
            for Register of Registers loop
               HRTimer_Common_Periph.BDTBUPR :=
                 HRTimer_Common_Periph.BDTBUPR or (2 ** Register'Enum_Rep);
            end loop;
         else
            for Register of Registers loop
               HRTimer_Common_Periph.BDTBUPR :=
                 HRTimer_Common_Periph.BDTBUPR and not (2 ** Register'Enum_Rep);
            end loop;
         end if;

      elsif Counter'Address = HRTIM_TIMC_Base then
         if Value then
            for Register of Registers loop
               HRTimer_Common_Periph.BDTCUPR :=
                 HRTimer_Common_Periph.BDTCUPR or (2 ** Register'Enum_Rep);
            end loop;
         else
            for Register of Registers loop
               HRTimer_Common_Periph.BDTCUPR :=
                 HRTimer_Common_Periph.BDTCUPR and not (2 ** Register'Enum_Rep);
            end loop;
         end if;

      elsif Counter'Address = HRTIM_TIMD_Base then
         if Value then
            for Register of Registers loop
               HRTimer_Common_Periph.BDTDUPR :=
                 HRTimer_Common_Periph.BDTDUPR or (2 ** Register'Enum_Rep);
            end loop;
         else
            for Register of Registers loop
               HRTimer_Common_Periph.BDTDUPR :=
                 HRTimer_Common_Periph.BDTDUPR and not (2 ** Register'Enum_Rep);
            end loop;
         end if;

      elsif Counter'Address = HRTIM_TIME_Base then
         if Value then
            for Register of Registers loop
               HRTimer_Common_Periph.BDTEUPR :=
                 HRTimer_Common_Periph.BDTEUPR or (2 ** Register'Enum_Rep);
            end loop;
         else
            for Register of Registers loop
               HRTimer_Common_Periph.BDTEUPR :=
                 HRTimer_Common_Periph.BDTEUPR and not (2 ** Register'Enum_Rep);
            end loop;
         end if;
      end if;
   end Set_Burst_DMA_Timer_Update;

   ------------------------
   -- Set_Burst_DMA_Data --
   ------------------------

   procedure Set_Burst_DMA_Data (Data : UInt32) is
   begin
      HRTimer_Common_Periph.BDMADR := Data;
   end Set_Burst_DMA_Data;

end STM32.HRTimers;
