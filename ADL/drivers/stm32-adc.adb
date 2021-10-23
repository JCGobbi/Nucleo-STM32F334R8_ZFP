------------------------------------------------------------------------------
--                                                                          --
--                  Copyright (C) 2015-2017, AdaCore                        --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of STMicroelectronics nor the names of its       --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
--                                                                          --
--  This file is based on:                                                  --
--                                                                          --
--   @file    stm32f4xx_hal_adc.c                                           --
--   @author  MCD Application Team                                          --
--   @version V1.3.1                                                        --
--   @date    25-March-2015                                                 --
--   @brief   Header file of ADC HAL module.                                --
--                                                                          --
--   COPYRIGHT(c) 2014 STMicroelectronics                                   --
------------------------------------------------------------------------------

with STM32_SVD.ADC;        use STM32_SVD.ADC;

package body STM32.ADC is

   procedure Set_Sequence_Position
     (This    : in out Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel;
      Rank    : Regular_Channel_Rank)
     with Inline;

   procedure Set_Sampling_Time
     (This        : in out Analog_To_Digital_Converter;
      Channel     : Analog_Input_Channel;
      Sample_Time : Channel_Sampling_Times)
     with Inline,
       Pre => Conversion_Started (This) = False and
         Injected_Conversion_Started (This) = False;

   procedure Set_Injected_Channel_Sequence_Position
     (This    : in out Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel;
      Rank    : Injected_Channel_Rank)
     with Inline;

   procedure Set_Injected_Channel_Offset
     (This    : in out Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel;
      Rank    : Injected_Channel_Rank;
      Offset  : Injected_Data_Offset)
     with Inline;

   ------------
   -- Enable --
   ------------

   procedure Enable (This : in out Analog_To_Digital_Converter) is
   begin
      if not This.CR.ADEN then
         This.CR.ADEN := True;

         loop
            exit when This.ISR.ADRDY = True;
         end loop;

      end if;
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable (This : in out Analog_To_Digital_Converter) is
   begin
      This.CR.ADDIS := True;
   end Disable;

   -------------
   -- Enabled --
   -------------

   function Enabled (This : Analog_To_Digital_Converter) return Boolean is
     (This.CR.ADEN = True);

   --------------
   -- Disabled --
   --------------

   function Disabled (This : Analog_To_Digital_Converter) return Boolean is
     (This.CR.ADEN = False);

   --------------------
   -- Configure_Unit --
   --------------------

   procedure Configure_Unit
     (This       : in out Analog_To_Digital_Converter;
      Resolution : ADC_Resolution;
      Alignment  : Data_Alignment)
   is
   begin
      This.CFGR.RES := ADC_Resolution'Enum_Rep (Resolution);
      This.CFGR.ALIGN := Alignment = Left_Aligned;
   end Configure_Unit;

   ------------------------
   -- Current_Resolution --
   ------------------------

   function Current_Resolution
     (This : Analog_To_Digital_Converter)
      return ADC_Resolution
   is (ADC_Resolution'Val (This.CFGR.RES));

   -----------------------
   -- Current_Alignment --
   -----------------------

   function Current_Alignment
     (This : Analog_To_Digital_Converter)
      return Data_Alignment
   is ((if This.CFGR.ALIGN then Left_Aligned else Right_Aligned));

   -----------------------------------
   -- Configure_Regular_Conversions --
   -----------------------------------

   procedure Configure_Regular_Conversions
     (This        : in out Analog_To_Digital_Converter;
      Continuous  : Boolean;
      Trigger     : Regular_Channel_Conversion_Trigger;
      Conversions : Regular_Channel_Conversions)
   is
   begin
      This.CFGR.CONT := Continuous;

      if Trigger.Enabler /= Trigger_Disabled then
         This.CFGR.EXTSEL := External_Events_Regular_Group'Enum_Rep (Trigger.Event);
         This.CFGR.EXTEN := External_Trigger'Enum_Rep (Trigger.Enabler);
         --  ADSTART need to be set (RM3064 pg. 230 chapter 13.3.18).
         This.CR.ADSTART := True;
      else
         This.CFGR.EXTSEL := 0;
         This.CFGR.EXTEN := 0;
      end if;

      for Rank in Conversions'Range loop
         declare
            Conversion : Regular_Channel_Conversion renames Conversions (Rank);
         begin
            Configure_Regular_Channel
              (This, Conversion.Channel, Rank, Conversion.Sample_Time);

            --  We check the VBat first because that channel is also used for
            --  the temperature sensor channel on some MCUs, in which case the
            --  VBat conversion is the only one done. This order reflects that
            --  hardware behavior.
            if VBat_Conversion (This, Conversion.Channel) then
               Enable_VBat_Connection;
            elsif VRef_TemperatureSensor_Conversion (This, Conversion.Channel)
            then
               Enable_VRef_TemperatureSensor_Connection;
            end if;
         end;
      end loop;

      This.SQR1.L := UInt4 (Conversions'Length - 1);  -- biased rep
   end Configure_Regular_Conversions;

   ----------------------------------
   -- Regular_Conversions_Expected --
   ----------------------------------

   function Regular_Conversions_Expected (This : Analog_To_Digital_Converter)
     return Natural is
     (Natural (This.SQR1.L) + 1);

   -----------------------
   -- Scan_Mode_Enabled --
   -----------------------

   function Scan_Mode_Enabled (This : Analog_To_Digital_Converter)
                               return Boolean
     is (This.SQR1.L /= UInt4 (0));

   ------------------------------------
   -- Configure_Injected_Conversions --
   ------------------------------------

   procedure Configure_Injected_Conversions
     (This          : in out Analog_To_Digital_Converter;
      AutoInjection : Boolean;
      Trigger       : Injected_Channel_Conversion_Trigger;
      Conversions   : Injected_Channel_Conversions)
   is
   begin

      --  Injected channels cannot be converted continuously. The only
      --  exception is when an injected channel is configured to be converted
      --  automatically after regular channels in continuous mode. See note in
      --  RM 13.3.5, pg 390, and "Auto-injection" section on pg 392.
      This.CFGR.JAUTO := AutoInjection;

      if Trigger.Enabler /= Trigger_Disabled then
         This.JSQR.JEXTEN := External_Trigger'Enum_Rep (Trigger.Enabler);
         This.JSQR.JEXTSEL := External_Events_Injected_Group'Enum_Rep (Trigger.Event);
         --  JADSTART need to be set (RM3064 pg. 230 chapter 13.3.18).
         This.CR.JADSTART := True;
      else
         This.JSQR.JEXTEN := 0;
         This.JSQR.JEXTSEL := 0;
      end if;

      for Rank in Conversions'Range loop
         declare
            Conversion : Injected_Channel_Conversion renames
              Conversions (Rank);
         begin
            Configure_Injected_Channel
              (This,
               Conversion.Channel,
               Rank,
               Conversion.Sample_Time,
               Conversion.Offset);

            --  We check the VBat first because that channel is also used for
            --  the temperature sensor channel on some MCUs, in which case the
            --  VBat conversion is the only one done. This order reflects that
            --  hardware behavior.
            if VBat_Conversion (This, Conversion.Channel) then
               Enable_VBat_Connection;
            elsif VRef_TemperatureSensor_Conversion (This, Conversion.Channel)
            then
               Enable_VRef_TemperatureSensor_Connection;
            end if;
         end;
      end loop;

      This.JSQR.JL := UInt2 (Conversions'Length - 1);  -- biased rep
   end Configure_Injected_Conversions;

   -----------------------------------
   -- Injected_Conversions_Expected --
   -----------------------------------

   function Injected_Conversions_Expected (This : Analog_To_Digital_Converter)
     return Natural is
     (Natural (This.JSQR.JL) + 1);

   ----------------------------
   -- Enable_VBat_Connection --
   ----------------------------

   procedure Enable_VBat_Connection is
   begin
      ADC_Common_Periph.CCR.VBATEN := True;
   end Enable_VBat_Connection;

   ------------------
   -- VBat_Enabled --
   ------------------

   function VBat_Enabled return Boolean is
      (ADC_Common_Periph.CCR.VBATEN);

   ----------------------------------------------
   -- Enable_VRef_TemperatureSensor_Connection --
   ----------------------------------------------

   procedure Enable_VRef_TemperatureSensor_Connection is
   begin
      ADC_Common_Periph.CCR.VREFEN := True;
      ADC_Common_Periph.CCR.TSEN := True;
      Delay_Until (Clock + Temperature_Sensor_Stabilization);
   end Enable_VRef_TemperatureSensor_Connection;

   --------------------------------------
   -- VRef_TemperatureSensor_Connected --
   --------------------------------------

   function VRef_TemperatureSensor_Enabled return Boolean is
      (ADC_Common_Periph.CCR.VREFEN and ADC_Common_Periph.CCR.TSEN);

   ---------------------------------
   -- Configure_Common_Properties --
   ---------------------------------

   procedure Configure_Common_Properties
     (Mode           : Multi_ADC_Mode_Selections;
      Clock_Mode     : ADC_Clock_Mode;
      DMA_Mode       : Dual_ADC_DMA_Modes;
      Sampling_Delay : Sampling_Delay_Selections)
   is
   begin
      ADC_Common_Periph.CCR.DUAL    := Mode'Enum_Rep;
      ADC_Common_Periph.CCR.DELAY_k := Sampling_Delay'Enum_Rep;
      ADC_Common_Periph.CCR.MDMA    := DMA_Mode'Enum_Rep;
      ADC_Common_Periph.CCR.CKMODE  := Clock_Mode'Enum_Rep;
   end Configure_Common_Properties;

   -------------------------------
   -- Configure_Regular_Channel --
   -------------------------------

   procedure Configure_Regular_Channel
     (This        : in out Analog_To_Digital_Converter;
      Channel     : Analog_Input_Channel;
      Rank        : Regular_Channel_Rank;
      Sample_Time : Channel_Sampling_Times)
   is
   begin
      Set_Sampling_Time (This, Channel, Sample_Time);
      Set_Sequence_Position (This, Channel, Rank);
   end Configure_Regular_Channel;

   --------------------------------
   -- Configure_Injected_Channel --
   --------------------------------

   procedure Configure_Injected_Channel
     (This        : in out Analog_To_Digital_Converter;
      Channel     : Analog_Input_Channel;
      Rank        : Injected_Channel_Rank;
      Sample_Time : Channel_Sampling_Times;
      Offset      : Injected_Data_Offset)
   is
   begin
      Set_Sampling_Time (This, Channel, Sample_Time);
      Set_Injected_Channel_Sequence_Position (This, Channel, Rank);
      Set_Injected_Channel_Offset (This, Channel, Rank, Offset);
   end Configure_Injected_Channel;

   ----------------------
   -- Start_Conversion --
   ----------------------

   procedure Start_Conversion (This : in out Analog_To_Digital_Converter) is
   begin
      if External_Trigger'Val (This.CFGR.EXTEN) /= Trigger_Disabled then
         return;
      end if;

      if Multi_ADC_Mode_Selections'Val (ADC_Common_Periph.CCR.DUAL) = Independent
        or else This'Address = STM32_SVD.ADC1_Base
      then
         This.CR.ADSTART := True;
      end if;
   end Start_Conversion;

   ---------------------
   -- Stop_Conversion --
   ---------------------

   procedure Stop_Conversion (This : in out Analog_To_Digital_Converter) is
   begin
      This.CR.ADSTP := True;
   end Stop_Conversion;

   ------------------------
   -- Conversion_Started --
   ------------------------

   function Conversion_Started (This : Analog_To_Digital_Converter)
      return Boolean
   is
      (This.CR.ADSTART);

   ----------------------
   -- Conversion_Value --
   ----------------------

   function Conversion_Value
     (This : Analog_To_Digital_Converter)
      return UInt16
   is
   begin
      return This.DR.RDATA;
   end Conversion_Value;

   ---------------------------
   -- Data_Register_Address --
   ---------------------------

   function Data_Register_Address
     (This : Analog_To_Digital_Converter)
      return System.Address
   is
      (This.DR'Address);

   -------------------------------
   -- Start_Injected_Conversion --
   -------------------------------

   procedure Start_Injected_Conversion
     (This : in out Analog_To_Digital_Converter)
   is
   begin
      This.CR.JADSTART := True;
   end Start_Injected_Conversion;

   ---------------------------------
   -- Injected_Conversion_Started --
   ---------------------------------

   function Injected_Conversion_Started (This : Analog_To_Digital_Converter)
     return Boolean
   is
     (This.CR.JADSTART);

   -------------------------------
   -- Injected_Conversion_Value --
   -------------------------------

   function Injected_Conversion_Value
     (This : Analog_To_Digital_Converter;
      Rank : Injected_Channel_Rank)
      return UInt16
   is
   begin
      case Rank is
         when 1 =>
            return This.JDR1.JDATA1;
         when 2 =>
            return This.JDR2.JDATA2;
         when 3 =>
            return This.JDR3.JDATA3;
         when 4 =>
            return This.JDR4.JDATA4;
      end case;
   end Injected_Conversion_Value;

   --------------------------------
   -- Multimode_Conversion_Value --
   --------------------------------

   function Multimode_Conversion_Value (Value : CDR_Data)
     return UInt16 is
   begin
      case Value is
         when Master =>
            return ADC_Common_Periph.CDR.RDATA_MST;
         when Slave =>
            return ADC_Common_Periph.CDR.RDATA_SLV;
      end case;
   end Multimode_Conversion_Value;

   --------------------------------
   -- Multimode_Conversion_Value --
   --------------------------------

   function Multimode_Conversion_Value return UInt32 is
   begin
      return Shift_Left (UInt32 (ADC_Common_Periph.CDR.RDATA_MST), 16) or
               UInt32 (ADC_Common_Periph.CDR.RDATA_SLV);
   end Multimode_Conversion_Value;

   -------------------------------
   -- Enable_Discontinuous_Mode --
   -------------------------------

   procedure Enable_Discontinuous_Mode
     (This    : in out Analog_To_Digital_Converter;
      Regular : Boolean;  -- if False, enabling for Injected channels
      Count   : Discontinuous_Mode_Channel_Count)
   is
   begin
      if Regular then
         This.CFGR.JDISCEN := False;
         This.CFGR.DISCEN := True;
      else -- Injected
         This.CFGR.DISCEN := False;
         This.CFGR.JDISCEN := True;
      end if;
      This.CFGR.DISCNUM := UInt3 (Count - 1);  -- biased
   end Enable_Discontinuous_Mode;

   ----------------------------------------
   -- Disable_Discontinuous_Mode_Regular --
   ---------------------------------------

   procedure Disable_Discontinuous_Mode_Regular
     (This : in out Analog_To_Digital_Converter)
   is
   begin
      This.CFGR.DISCEN := False;
   end Disable_Discontinuous_Mode_Regular;

   -----------------------------------------
   -- Disable_Discontinuous_Mode_Injected --
   -----------------------------------------

   procedure Disable_Discontinuous_Mode_Injected
     (This : in out Analog_To_Digital_Converter)
   is
   begin
      This.CFGR.JDISCEN := False;
   end Disable_Discontinuous_Mode_Injected;

   ----------------------------------------
   -- Discontinuous_Mode_Regular_Enabled --
   ----------------------------------------

   function Discontinuous_Mode_Regular_Enabled
     (This : Analog_To_Digital_Converter)
      return Boolean
   is (This.CFGR.DISCEN);

   -----------------------------------------
   -- Discontinuous_Mode_Injected_Enabled --
   -----------------------------------------

   function Discontinuous_Mode_Injected_Enabled
     (This : Analog_To_Digital_Converter)
      return Boolean
   is (This.CFGR.JDISCEN);

   ---------------------------
   -- AutoInjection_Enabled --
   ---------------------------

   function AutoInjection_Enabled
     (This : Analog_To_Digital_Converter)
      return Boolean
   is (This.CFGR.JAUTO);

   ----------------
   -- Enable_DMA --
   ----------------

   procedure Enable_DMA (This : in out Analog_To_Digital_Converter) is
   begin
      This.CFGR.DMAEN := True;
   end Enable_DMA;

   -----------------
   -- Disable_DMA --
   -----------------

   procedure Disable_DMA (This : in out Analog_To_Digital_Converter) is
   begin
      This.CFGR.DMAEN := False;
   end Disable_DMA;

   -----------------
   -- DMA_Enabled --
   -----------------

   function DMA_Enabled (This : Analog_To_Digital_Converter) return Boolean is
     (This.CFGR.DMAEN);

   ------------------------------------
   -- Enable_DMA_After_Last_Transfer --
   ------------------------------------

   procedure Enable_DMA_After_Last_Transfer
     (This : in out Analog_To_Digital_Converter)
   is
   begin
      This.CFGR.DMACFG := True;
   end Enable_DMA_After_Last_Transfer;

   -------------------------------------
   -- Disable_DMA_After_Last_Transfer --
   -------------------------------------

   procedure Disable_DMA_After_Last_Transfer
     (This : in out Analog_To_Digital_Converter)
   is
   begin
      This.CFGR.DMACFG := False;
   end Disable_DMA_After_Last_Transfer;

   -------------------------------------
   -- DMA_Enabled_After_Last_Transfer --
   -------------------------------------

   function DMA_Enabled_After_Last_Transfer
     (This : Analog_To_Digital_Converter)
      return Boolean
   is (This.CFGR.DMACFG);

   ------------------------------------------
   -- Multi_Enable_DMA_After_Last_Transfer --
   ------------------------------------------

   procedure Multi_Enable_DMA_After_Last_Transfer is
   begin
      --  This is a common register. You must choose the value in
      --  accordance to the resolution: 2 for 12 and 10-bit resolution,
      --  3 for 8 and 6-bit resolution.
      ADC_Common_Periph.CCR.MDMA := 2;
   end Multi_Enable_DMA_After_Last_Transfer;

   -------------------------------------------
   -- Multi_Disable_DMA_After_Last_Transfer --
   -------------------------------------------

   procedure Multi_Disable_DMA_After_Last_Transfer is
   begin
      ADC_Common_Periph.CCR.MDMA := 0;
   end Multi_Disable_DMA_After_Last_Transfer;

   -------------------------------------------
   -- Multi_DMA_Enabled_After_Last_Transfer --
   -------------------------------------------

   function Multi_DMA_Enabled_After_Last_Transfer return Boolean is
     (ADC_Common_Periph.CCR.MDMA = 2);

   ------------------------------
   -- Watchdog_Enable_Channels --
   ------------------------------

   procedure Watchdog_Enable_Channels
     (This : in out Analog_To_Digital_Converter;
      Mode : Multiple_Channels_Watchdog;
      Low  : Watchdog_Threshold;
      High : Watchdog_Threshold)
   is
   begin
      This.TR1.HT1 := High;
      This.TR1.LT1 := Low;
      --  see RM 13.3.28, pg 258, table 45

      --  Enable all channel mode
      This.CFGR.AWD1SGL := False;
      case Mode is
         when Watchdog_All_Regular_Channels =>
            This.CFGR.AWD1EN := True;
         when Watchdog_All_Injected_Channels =>
            This.CFGR.JAWD1EN := True;
         when Watchdog_All_Both_Kinds =>
            This.CFGR.AWD1EN := True;
            This.CFGR.JAWD1EN := True;
      end case;
   end Watchdog_Enable_Channels;

   -----------------------------
   -- Watchdog_Enable_Channel --
   -----------------------------

   procedure Watchdog_Enable_Channel
     (This    : in out Analog_To_Digital_Converter;
      Mode    : Single_Channel_Watchdog;
      Channel : Analog_Input_Channel;
      Low     : Watchdog_Threshold;
      High    : Watchdog_Threshold)
   is
   begin
      This.TR1.HT1 := High;
      This.TR1.LT1 := Low;

      --  Set then channel
      This.CFGR.AWD1CH := Channel;
      --  Enable single channel mode
      This.CFGR.AWD1SGL := True;

      case Mode is
         when Watchdog_Single_Regular_Channel =>
            This.CFGR.AWD1EN := True;
         when Watchdog_Single_Injected_Channel =>
            This.CFGR.JAWD1EN := True;
         when Watchdog_Single_Both_Kinds =>
            This.CFGR.AWD1EN := True;
            This.CFGR.JAWD1EN := True;
      end case;
   end Watchdog_Enable_Channel;

   ----------------------
   -- Watchdog_Disable --
   ----------------------

   procedure Watchdog_Disable (This : in out Analog_To_Digital_Converter) is
   begin
      This.CFGR.AWD1EN := False;
      This.CFGR.JAWD1EN := False;

      --  clearing the single-channel bit (AWGSDL) is not required to disable,
      --  per the RM table 66, section 13.3.7, pg 391, but seems cleanest
      This.CFGR.AWD1SGL := False;
   end Watchdog_Disable;

   ----------------------
   -- Watchdog_Enabled --
   ----------------------

   function Watchdog_Enabled (This : Analog_To_Digital_Converter)
     return Boolean
   is
      (This.CFGR.AWD1EN or This.CFGR.JAWD1EN);

   ------------------------------
   -- Watchdog_Enable_Channels --
   ------------------------------
   procedure Watchdog_Enable_Channels
     (This     : in out Analog_To_Digital_Converter;
      Watchdog : Analog_Window_Watchdog;
      Channels : Analog_Input_Channels;
      Low      : Watchdog_Threshold;
      High     : Watchdog_Threshold)
   is
   begin
      case Watchdog is
         when Watchdog_2 =>
            This.TR2.HT2 := UInt8 (High);
            This.TR2.LT2 := UInt8 (Low);
            for Channel of Channels loop
               This.AWD2CR.AWD2CH := This.AWD2CR.AWD2CH or (2 ** Natural (Channel));
            end loop;
         when Watchdog_3 =>
            This.TR3.HT3 := UInt8 (High);
            This.TR3.LT3 := UInt8 (Low);
            for Channel of Channels loop
               This.AWD3CR.AWD3CH := This.AWD3CR.AWD3CH or (2 ** Natural (Channel));
            end loop;
      end case;
   end Watchdog_Enable_Channels;

   -------------------------------
   -- Watchdog_Disable_Channels --
   -------------------------------
   procedure Watchdog_Disable_Channels
     (This     : in out Analog_To_Digital_Converter;
      Watchdog : Analog_Window_Watchdog;
      Channels : Analog_Input_Channels)
   is
   begin
      case Watchdog is
         when Watchdog_2 =>
            for Channel of Channels loop
               This.AWD2CR.AWD2CH := This.AWD2CR.AWD2CH and not (2 ** Natural (Channel));
            end loop;
         when Watchdog_3 =>
            for Channel of Channels loop
               This.AWD3CR.AWD3CH := This.AWD3CR.AWD3CH and not (2 ** Natural (Channel));
            end loop;
      end case;
   end Watchdog_Disable_Channels;

   ----------------------
   -- Watchdog_Disable --
   ----------------------

   procedure Watchdog_Disable
     (This     : in out Analog_To_Digital_Converter;
      Watchdog : Analog_Window_Watchdog)
   is
   begin
      case Watchdog is
         when Watchdog_2 =>
            This.AWD2CR.AWD2CH := 16#000#;
         when Watchdog_3 =>
            This.AWD3CR.AWD3CH := 16#000#;
      end case;
   end Watchdog_Disable;

   ----------------------
   -- Watchdog_Enabled --
   ----------------------

   function Watchdog_Enabled
     (This     : Analog_To_Digital_Converter;
      Watchdog : Analog_Window_Watchdog) return Boolean
   is
   begin
      case Watchdog is
         when Watchdog_2 =>
            return This.AWD2CR.AWD2CH /= 16#000#;
         when Watchdog_3 =>
            return This.AWD3CR.AWD3CH /= 16#000#;
      end case;
   end Watchdog_Enabled;

   ------------
   -- Status --
   ------------

   function Status
     (This : Analog_To_Digital_Converter;
      Flag : ADC_Status_Flag)
      return Boolean
   is
   begin
      case Flag is
         when ADC_Ready =>
            return This.ISR.ADRDY;
         when Regular_Channel_Conversion_Completed =>
            return This.ISR.EOC;
         when Regular_Sequence_Conversion_Completed =>
            return This.ISR.EOS;
         when Injected_Channel_Conversion_Completed =>
            return This.ISR.JEOC;
         when Injected_Sequence_Conversion_Completed =>
            return This.ISR.JEOS;
         when Analog_Watchdog_1_Event_Occurred =>
            return This.ISR.AWD.Arr (1);
         when Analog_Watchdog_2_Event_Occurred =>
            return This.ISR.AWD.Arr (2);
         when Analog_Watchdog_3_Event_Occurred =>
            return This.ISR.AWD.Arr (3);
         when Sampling_Completed =>
            return This.ISR.EOSMP;
         when Overrun =>
            return This.ISR.OVR;
         when Injected_Context_Queue_Overflow =>
            return This.ISR.JQOVF;
      end case;
   end Status;

   ------------------
   -- Clear_Status --
   ------------------

   procedure Clear_Status
     (This : in out Analog_To_Digital_Converter;
      Flag : ADC_Status_Flag)
   is
   begin
      case Flag is
         when ADC_Ready =>
            This.ISR.ADRDY := True;
         when Regular_Channel_Conversion_Completed =>
            This.ISR.EOC := True;
         when Regular_Sequence_Conversion_Completed =>
            This.ISR.EOS := True;
         when Injected_Channel_Conversion_Completed =>
            This.ISR.JEOC := True;
         when Injected_Sequence_Conversion_Completed =>
            This.ISR.JEOS := True;
         when Analog_Watchdog_1_Event_Occurred =>
            This.ISR.AWD.Arr (1) := True;
         when Analog_Watchdog_2_Event_Occurred =>
            This.ISR.AWD.Arr (2) := True;
         when Analog_Watchdog_3_Event_Occurred =>
            This.ISR.AWD.Arr (3) := True;
         when Sampling_Completed =>
            This.ISR.EOSMP := True;
         when Overrun =>
            This.ISR.OVR := True;
         when Injected_Context_Queue_Overflow =>
            This.ISR.JQOVF := True;
      end case;
   end Clear_Status;

   ---------------------
   -- Poll_For_Status --
   ---------------------

   procedure Poll_For_Status
     (This    : in out Analog_To_Digital_Converter;
      Flag    : ADC_Status_Flag;
      Success : out Boolean;
      Timeout : Time_Span := Time_Span_Last)
   is
      Deadline : constant Time := Clock + Timeout;
   begin
      Success := False;
      while Clock < Deadline loop
         if Status (This, Flag) then
            Success := True;
            exit;
         end if;
      end loop;
   end Poll_For_Status;

   -----------------------
   -- Enable_Interrupts --
   -----------------------

   procedure Enable_Interrupts
     (This   : in out Analog_To_Digital_Converter;
      Source : ADC_Interrupts)
   is
   begin
      case Source is
         when ADC_Ready =>
            This.IER.ADRDYIE := True;
         when Regular_Channel_Conversion_Complete =>
            This.IER.EOCIE := True;
         when Regular_Sequence_Conversion_Complete =>
            This.IER.EOSIE := True;
         when Injected_Channel_Conversion_Complete =>
            This.IER.JEOCIE := True;
         when Injected_Sequence_Conversion_Complete =>
            This.IER.JEOSIE := True;
         when Analog_Watchdog_1_Event_Occurr =>
            This.IER.AWD1IE := True;
         when Analog_Watchdog_2_Event_Occurr =>
            This.IER.AWD2IE := True;
         when Analog_Watchdog_3_Event_Occurr =>
            This.IER.AWD3IE := True;
         when Sampling_Complete =>
            This.IER.EOSMPIE := True;
         when Overrun =>
            This.IER.OVRIE := True;
         when Injected_Context_Queue_Overflow =>
            This.IER.JQOVFIE := True;
      end case;
   end Enable_Interrupts;

   -----------------------
   -- Interrupt_Enabled --
   -----------------------

   function Interrupt_Enabled
     (This   : Analog_To_Digital_Converter;
      Source : ADC_Interrupts)
     return Boolean
   is
   begin
      case Source is
         when ADC_Ready =>
            return This.IER.ADRDYIE;
         when Regular_Channel_Conversion_Complete =>
            return This.IER.EOCIE;
         when Regular_Sequence_Conversion_Complete =>
            return This.IER.EOSIE;
         when Injected_Channel_Conversion_Complete =>
            return This.IER.JEOCIE;
         when Injected_Sequence_Conversion_Complete =>
            return This.IER.JEOSIE;
         when Analog_Watchdog_1_Event_Occurr =>
            return This.IER.AWD1IE;
         when Analog_Watchdog_2_Event_Occurr =>
            return This.IER.AWD2IE;
         when Analog_Watchdog_3_Event_Occurr =>
            return This.IER.AWD3IE;
         when Sampling_Complete =>
            return This.IER.EOSMPIE;
         when Overrun =>
            return This.IER.OVRIE;
         when Injected_Context_Queue_Overflow =>
            return This.IER.JQOVFIE;
      end case;
   end Interrupt_Enabled;

   ------------------------
   -- Disable_Interrupts --
   ------------------------

   procedure Disable_Interrupts
     (This   : in out Analog_To_Digital_Converter;
      Source : ADC_Interrupts)
   is
   begin
      case Source is
         when ADC_Ready =>
            This.IER.ADRDYIE := False;
         when Regular_Channel_Conversion_Complete =>
            This.IER.EOCIE := False;
         when Regular_Sequence_Conversion_Complete =>
            This.IER.EOSIE := False;
         when Injected_Channel_Conversion_Complete =>
            This.IER.JEOCIE := False;
         when Injected_Sequence_Conversion_Complete =>
            This.IER.JEOSIE := False;
         when Analog_Watchdog_1_Event_Occurr =>
            This.IER.AWD1IE := False;
         when Analog_Watchdog_2_Event_Occurr =>
            This.IER.AWD2IE := False;
         when Analog_Watchdog_3_Event_Occurr =>
            This.IER.AWD3IE := False;
         when Sampling_Complete =>
            This.IER.EOSMPIE := False;
         when Overrun =>
            This.IER.OVRIE := False;
         when Injected_Context_Queue_Overflow =>
            This.IER.JQOVFIE := False;
      end case;
   end Disable_Interrupts;

   -----------------------------
   -- Clear_Interrupt_Pending --
   -----------------------------

   procedure Clear_Interrupt_Pending
     (This   : in out Analog_To_Digital_Converter;
      Source : ADC_Interrupts)
   is
   begin
      case Source is
         when ADC_Ready =>
            This.ISR.ADRDY := True;
         when Regular_Channel_Conversion_Complete =>
            This.ISR.EOC := True;
         when Regular_Sequence_Conversion_Complete =>
            This.ISR.EOS := True;
         when Injected_Channel_Conversion_Complete =>
            This.ISR.JEOC := True;
         when Injected_Sequence_Conversion_Complete =>
            This.ISR.JEOS := True;
         when Analog_Watchdog_1_Event_Occurr =>
            This.ISR.AWD.Arr (1) := True;
         when Analog_Watchdog_2_Event_Occurr =>
            This.ISR.AWD.Arr (2) := True;
         when Analog_Watchdog_3_Event_Occurr =>
            This.ISR.AWD.Arr (3) := True;
         when Sampling_Complete =>
            This.ISR.EOSMP := True;
         when Overrun =>
            This.ISR.OVR := True;
         when Injected_Context_Queue_Overflow =>
            This.ISR.JQOVF := True;
      end case;
   end Clear_Interrupt_Pending;

   ---------------------------
   -- Set_Sequence_Position --
   ---------------------------

   procedure Set_Sequence_Position
     (This    : in out Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel;
      Rank    : Regular_Channel_Rank)
   is
   begin
      case Rank is
         when 1 =>
            This.SQR1.SQ1 := Channel;
         when 2 =>
            This.SQR1.SQ2 := Channel;
         when 3 =>
            This.SQR1.SQ3 := Channel;
         when 4 =>
            This.SQR1.SQ4 := Channel;
         when 5 =>
            This.SQR2.SQ5 := Channel;
         when 6 =>
            This.SQR2.SQ6 := Channel;
         when 7 =>
            This.SQR2.SQ7 := Channel;
         when 8 =>
            This.SQR2.SQ8 := Channel;
         when 9 =>
            This.SQR2.SQ9 := Channel;
         when 10 =>
            This.SQR3.SQ10 := Channel;
         when 11 =>
            This.SQR3.SQ11 := Channel;
         when 12 =>
            This.SQR3.SQ12 := Channel;
         when 13 =>
            This.SQR3.SQ13 := Channel;
         when 14 =>
            This.SQR3.SQ14 := Channel;
         when 15 =>
            This.SQR4.SQ15 := Channel;
         when 16 =>
            This.SQR4.SQ16 := Channel;
      end case;
   end Set_Sequence_Position;

   --------------------------------------------
   -- Set_Injected_Channel_Sequence_Position --
   --------------------------------------------

   procedure Set_Injected_Channel_Sequence_Position
     (This    : in out Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel;
      Rank    : Injected_Channel_Rank)
   is
   begin
      case Rank is
         when 1 =>
            This.JSQR.JSQ1 := Channel;
         when 2 =>
            This.JSQR.JSQ2 := Channel;
         when 3 =>
            This.JSQR.JSQ3 := Channel;
         when 4 =>
            This.JSQR.JSQ4 := Channel;
      end case;
   end Set_Injected_Channel_Sequence_Position;

   -----------------------
   -- Set_Sampling_Time --
   -----------------------

   procedure Set_Sampling_Time
     (This        : in out Analog_To_Digital_Converter;
      Channel     : Analog_Input_Channel;
      Sample_Time : Channel_Sampling_Times)
   is
   begin
      if Channel < 10 then
         This.SMPR1.SMP.Arr (Natural (Channel)) :=
           Channel_Sampling_Times'Enum_Rep (Sample_Time);
      else
         This.SMPR2.SMP.Arr (Natural (Channel)) :=
           Channel_Sampling_Times'Enum_Rep (Sample_Time);
      end if;
   end Set_Sampling_Time;

   ---------------------------------
   -- Set_Injected_Channel_Offset --
   ---------------------------------

   procedure Set_Injected_Channel_Offset
     (This    : in out Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel;
      Rank    : Injected_Channel_Rank;
      Offset  : Injected_Data_Offset)
   is
   begin
      case Rank is
         when 1 =>
            This.OFR1.OFFSET1_CH := Channel;
            This.OFR1.OFFSET1 := Offset;
            This.OFR1.OFFSET1_EN := True;
         when 2 =>
            This.OFR2.OFFSET2_CH := Channel;
            This.OFR2.OFFSET2 := Offset;
            This.OFR2.OFFSET2_EN := True;
         when 3 =>
            This.OFR3.OFFSET3_CH := Channel;
            This.OFR3.OFFSET3 := Offset;
            This.OFR3.OFFSET3_EN := True;
         when 4 =>
            This.OFR4.OFFSET4_CH := Channel;
            This.OFR4.OFFSET4 := Offset;
            This.OFR4.OFFSET4_EN := True;
      end case;
   end Set_Injected_Channel_Offset;

end STM32.ADC;
