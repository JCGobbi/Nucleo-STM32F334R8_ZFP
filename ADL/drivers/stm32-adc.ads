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
--   @file    stm32f4xx_hal_adc.h                                           --
--   @author  MCD Application Team                                          --
--   @version V1.3.1                                                        --
--   @date    25-March-2015                                                 --
--   @brief   Header file of ADC HAL module.                                --
--                                                                          --
--   COPYRIGHT(c) 2014 STMicroelectronics                                   --
------------------------------------------------------------------------------

--  This file provides interfaces for the analog-to-digital converters on the
--  STM32F3 (ARM Cortex M4F) microcontrollers from ST Microelectronics.

--  Channels are mapped to GPIO_Point values as follows.  See
--  the STM32F334x datasheet, Table 13. "STM32F334x pin definitions"
--
--  Channel    ADC    ADC
--    #         1      2
--
--    0
--    1        PA0    PA4
--    2        PA1    PA5
--    3        PA2    PA6
--    4        PA3    PA7
--    5               PC4
--    6        PC0    PC0
--    7        PC1    PC1
--    8        PC2    PC2
--    9        PC3    PC3
--   10
--   11        PB0    PC5
--   12        PB1    PB2
--   13        PB13   PB12
--   14               PB14
--   15               PB15

with System;        use System;
with Sys.Real_Time; use Sys.Real_Time;

private with STM32_SVD.ADC;

package STM32.ADC is
   pragma Elaborate_Body;

   type Analog_To_Digital_Converter is limited private;

   subtype Analog_Input_Channel is UInt5 range 0 .. 18;

   type ADC_Point is record
      ADC     : access Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel;
   end record;

   VRef_Channel : constant Analog_Input_Channel := 18;
   --  See RM pg 277 section 13.3.32
   --  Note available with ADC_1 and ADC_2

   VBat_Channel : constant Analog_Input_Channel := 17;
   --  See RM pg 276, section 13.3.31 also pg 214
   --  Note only available with ADC_1

   subtype TemperatureSensor_Channel is Analog_Input_Channel;
   --  TODO: ??? The below predicate does not compile with GNAT GPL 2015.
   --  with Static_Predicate => TemperatureSensor_Channel in 16 | VBat_Channel;
   --  See RM pg 389 section 13.3.3. On some MCUs the temperature channel is
   --  the same as the VBat channel, on others it is channel 16. Note only
   --  available with ADC_1

   ADC_Supply_Voltage : constant := 3000;  -- millivolts
   --  This is the ideal value, likely not the actual

   procedure Enable (This : in out Analog_To_Digital_Converter) with
     Pre => not Enabled (This) and
            not Conversion_Started (This) and
            not Injected_Conversion_Started (This),
     Post => Enabled (This);

   procedure Disable (This : in out Analog_To_Digital_Converter) with
     Pre => Enabled (This) and
            not Conversion_Started (This) and
            not Injected_Conversion_Started (This),
     Post => not Enabled (This);

   function Enabled (This : Analog_To_Digital_Converter) return Boolean;

   function Disabled (This : Analog_To_Digital_Converter) return Boolean;

   type ADC_Resolution is
     (ADC_Resolution_12_Bits,  -- 15 ADC Clock cycles
      ADC_Resolution_10_Bits,  -- 12 ADC Clock cycles
      ADC_Resolution_8_Bits,   -- 10 ADC Clock cycles
      ADC_Resolution_6_Bits);  --  8 ADC Clock cycles

   type Data_Alignment is (Right_Aligned, Left_Aligned);

   procedure Configure_Unit
     (This       : in out Analog_To_Digital_Converter;
      Resolution : ADC_Resolution;
      Alignment  : Data_Alignment)
    with
      Post => Current_Resolution (This) = Resolution and
              Current_Alignment (This) = Alignment;

   function Current_Resolution (This : Analog_To_Digital_Converter)
      return ADC_Resolution;

   function Current_Alignment (This : Analog_To_Digital_Converter)
      return Data_Alignment;

   type Channel_Sampling_Times is
     (Sample_1P5_Cycles,
      Sample_2P5_Cycles,
      Sample_4P5_Cycles,
      Sample_7P5_Cycles,
      Sample_19P5_Cycles,
      Sample_61P5_Cycles,
      Sample_181P5_Cycles,
      Sample_601P5_Cycles)
     with Size => 3;
   --  The elapsed time between the start of a conversion and the end of
   --  conversion is the sum of the configured sampling time plus the
   --  successive approximation time (SAR = 12.5 for 12 bit) depending on data
   --  resolution. See RM0364 rev 4 chapter 13.3.16 Timing.

   type External_Trigger is
     (Trigger_Disabled,
      Trigger_Rising_Edge,
      Trigger_Falling_Edge,
      Trigger_Both_Edges);

   type Regular_Channel_Rank is new Natural range 1 .. 16;

   type Injected_Channel_Rank is new Natural range 1 .. 4;

   type External_Events_Regular_Group is
     (Timer1_CC1_Event,
      Timer1_CC2_Event,
      Timer1_CC3_Event,
      Timer2_CC2_Event,
      Timer3_TRGO_Event,
      EXTI_Line11,
      HRTimer_ADCTRG1_Event,
      HRTimer_ADCTRG3_Event,
      Timer1_TRGO_Event,
      Timer1_TRGO2_Event,
      Timer2_TRGO_Event,
      Timer6_TRGO_Event,
      Timer15_TRGO_Event,
      Timer3_CC4_Event);
   --  External triggers for regular channels.

   for External_Events_Regular_Group use --  RM pg. 231
     (Timer1_CC1_Event      => 2#0000#,
      Timer1_CC2_Event      => 2#0001#,
      Timer1_CC3_Event      => 2#0010#,
      Timer2_CC2_Event      => 2#0011#,
      Timer3_TRGO_Event     => 2#0100#,
      EXTI_Line11           => 2#0110#,
      HRTimer_ADCTRG1_Event => 2#0111#,
      HRTimer_ADCTRG3_Event => 2#1000#,
      Timer1_TRGO_Event     => 2#1001#,
      Timer1_TRGO2_Event    => 2#1010#,
      Timer2_TRGO_Event     => 2#1011#,
      Timer6_TRGO_Event     => 2#1101#,
      Timer15_TRGO_Event    => 2#1110#,
      Timer3_CC4_Event      => 2#1111#);

   type Regular_Channel_Conversion_Trigger (Enabler : External_Trigger) is
      record
         case Enabler is
            when Trigger_Disabled =>
               null;
            when others =>
               Event : External_Events_Regular_Group;
         end case;
      end record;

   Software_Triggered : constant Regular_Channel_Conversion_Trigger
     := (Enabler => Trigger_Disabled);

   type Regular_Channel_Conversion is record
      Channel     : Analog_Input_Channel;
      Sample_Time : Channel_Sampling_Times;
   end record;

   type Regular_Channel_Conversions is
     array (Regular_Channel_Rank range <>) of Regular_Channel_Conversion;

   procedure Configure_Regular_Conversions
     (This        : in out Analog_To_Digital_Converter;
      Continuous  : Boolean;
      Trigger     : Regular_Channel_Conversion_Trigger;
      Conversions : Regular_Channel_Conversions)
     with
       Pre => Conversions'Length > 0,
       Post =>
         Length_Matches_Expected (This, Conversions) and
         --  if there are multiple channels to be converted, we must want to
         --  scan them so we set Scan_Mode accordingly
         (if Conversions'Length > 1 then Scan_Mode_Enabled (This)) and
         --  The VBat and VRef internal connections are enabled if This is
         --  ADC_1 and the corresponding channels are included in the lists.
         (VBat_May_Be_Enabled (This, Conversions) or else
          VRef_TemperatureSensor_May_Be_Enabled (This, Conversions));
   --  Configures all the regular channel conversions described in the array
   --  Conversions. Note that the order of conversions in the array is the
   --  order in which they are scanned, ie, their index is their "rank" in
   --  the data structure. Note that if the VBat and Temperature channels are
   --  the same channel, then only the VBat conversion takes place and only
   --  that one will be enabled, so we must check the two in that order.

   function Regular_Conversions_Expected (This : Analog_To_Digital_Converter)
     return Natural;
   --  Returns the total number of regular channel conversions specified in the
   --  hardware

   function Scan_Mode_Enabled (This : Analog_To_Digital_Converter)
     return Boolean;
   --  Returns whether only one channel is converted, or if multiple channels
   --  are converted (i.e., scanned). Note that this is independent of whether
   --  the conversions are continuous.

   type External_Events_Injected_Group is
     (Timer1_TRGO_Event,
      Timer1_CC4_Event,
      Timer2_TRGO_Event,
      Timer2_CC1_Event,
      Timer3_CC4_Event,
      EXTI_Line15,
      Timer1_TRGO2_Event,
      HRTimer_ADCTRG2_Event,
      HRTimer_ADCTRG4_Event,
      Timer3_CC3_Event,
      Timer3_TRGO_Event,
      Timer3_CC1_Event,
      Timer6_TRGO_Event,
      Timer15_TRGO_Event);
   --  External triggers for injected channels

   for External_Events_Injected_Group use --  RM pg. 232
     (Timer1_TRGO_Event     => 2#0000#,
      Timer1_CC4_Event      => 2#0001#,
      Timer2_TRGO_Event     => 2#0010#,
      Timer2_CC1_Event      => 2#0011#,
      Timer3_CC4_Event      => 2#0100#,
      EXTI_Line15           => 2#0110#,
      Timer1_TRGO2_Event    => 2#1000#,
      HRTimer_ADCTRG2_Event => 2#1001#,
      HRTimer_ADCTRG4_Event => 2#1010#,
      Timer3_CC3_Event      => 2#1011#,
      Timer3_TRGO_Event     => 2#1100#,
      Timer3_CC1_Event      => 2#1101#,
      Timer6_TRGO_Event     => 2#1110#,
      Timer15_TRGO_Event    => 2#1111#);

   type Injected_Channel_Conversion_Trigger (Enabler : External_Trigger) is
      record
         case Enabler is
            when Trigger_Disabled =>
               null;
            when others =>
               Event : External_Events_Injected_Group;
         end case;
      end record;

   Software_Triggered_Injected : constant Injected_Channel_Conversion_Trigger
     := (Enabler => Trigger_Disabled);

   subtype Injected_Data_Offset is UInt12;

   type Injected_Channel_Conversion is record
      Channel     : Analog_Input_Channel;
      Sample_Time : Channel_Sampling_Times;
      Offset      : Injected_Data_Offset := 0;
   end record;

   type Injected_Channel_Conversions is
     array (Injected_Channel_Rank range <>) of Injected_Channel_Conversion;

   procedure Configure_Injected_Conversions
     (This          : in out Analog_To_Digital_Converter;
      AutoInjection : Boolean;
      Trigger       : Injected_Channel_Conversion_Trigger;
      Conversions   : Injected_Channel_Conversions)
     with
       Pre =>
         Conversions'Length > 0 and
         (if AutoInjection then Trigger = Software_Triggered_Injected) and
         (if AutoInjection then
           not Discontinuous_Mode_Injected_Enabled (This)),
       Post =>
         Length_Is_Expected (This, Conversions) and
         --  The VBat and VRef internal connections are enabled if This is
         --  ADC_1 and the corresponding channels are included in the lists.
         (VBat_May_Be_Enabled (This, Conversions)  or else
          VRef_TemperatureSensor_May_Be_Enabled (This, Conversions));
   --  Configures all the injected channel conversions described in the array
   --  Conversions. Note that the order of conversions in the array is the
   --  order in which they are scanned, ie, their index is their "rank" in
   --  the data structure. Note that if the VBat and Temperature channels are
   --  the same channel, then only the VBat conversion takes place and only
   --  that one will be enabled, so we must check the two in that order.

   function Injected_Conversions_Expected (This : Analog_To_Digital_Converter)
     return Natural;
   --  Returns the total number of injected channel conversions to be done

   function VBat_Enabled return Boolean;
   --  Returns whether the hardware has the VBat internal connection enabled

   function VRef_TemperatureSensor_Enabled return Boolean;
   --  Returns whether the hardware has the VRef or temperature sensor internal
   --  connection enabled

   procedure Start_Conversion (This : in out Analog_To_Digital_Converter) with
     Pre => Enabled (This) and Regular_Conversions_Expected (This) > 0;
   --  Starts the conversion(s) for the regular channels

   procedure Stop_Conversion (This : in out Analog_To_Digital_Converter) with
     Pre => Conversion_Started (This) and not Disabled (This);
   --  Stops the conversion(s) for the regular channels

   function Conversion_Started (This : Analog_To_Digital_Converter)
     return Boolean;
   --  Returns whether the regular channels' conversions have started. Note
   --  that the ADC hardware clears the corresponding bit immediately, as
   --  part of starting.

   function Conversion_Value (This : Analog_To_Digital_Converter)
      return UInt16 with Inline;
   --  Returns the latest regular conversion result for the specified ADC unit

   function Data_Register_Address (This : Analog_To_Digital_Converter)
     return System.Address
     with Inline;
   --  Returns the address of the ADC Data Register. This is exported
   --  STRICTLY for the sake of clients using DMA. All other
   --  clients of this package should use the Conversion_Value functions!
   --  Seriously, don't use this function otherwise.

   procedure Start_Injected_Conversion
     (This : in out Analog_To_Digital_Converter)
     with Pre => Enabled (This) and Injected_Conversions_Expected (This) > 0;
   --  Note that the ADC hardware clears the corresponding bit immediately, as
   --  part of starting.

   function Injected_Conversion_Started (This : Analog_To_Digital_Converter)
      return Boolean;
   --  Returns whether the injected channels' conversions have started

   function Injected_Conversion_Value
     (This : Analog_To_Digital_Converter;
      Rank : Injected_Channel_Rank)
      return UInt16
     with Inline;
   --  Returns the latest conversion result for the analog input channel at
   --  the injected sequence position given by Rank on the specified ADC unit.
   --
   --  Note that the offset corresponding to the specified Rank is subtracted
   --  automatically, so check the sign bit for a negative result.

   type CDR_Data is (Master, Slave);

   function Multimode_Conversion_Value (Value : CDR_Data) return UInt16;

   function Multimode_Conversion_Value return UInt32 with inline;
   --  Returns the latest ADC_1, ADC_2 and ADC_3 regular channel conversions'
   --  results based the selected multi ADC mode

   --  Discontinuous Management  --------------------------------------------------------

   type Discontinuous_Mode_Channel_Count is range 1 .. 8;
   --  Note this uses a biased representation implicitly because the underlying
   --  representational bit values are 0 ... 7

   procedure Enable_Discontinuous_Mode
     (This    : in out Analog_To_Digital_Converter;
      Regular : Boolean;  -- if False, applies to Injected channels
      Count   : Discontinuous_Mode_Channel_Count)
     with
       Pre => not AutoInjection_Enabled (This),
       Post =>
         (if Regular then
            (Discontinuous_Mode_Regular_Enabled (This)) and
            (not Discontinuous_Mode_Injected_Enabled (This))
          else
            (not Discontinuous_Mode_Regular_Enabled (This)) and
            (Discontinuous_Mode_Injected_Enabled (This)));
   --  Enables discontinuous mode and sets the count. If Regular is True,
   --  enables the mode only for regular channels. If Regular is False, enables
   --  the mode only for Injected channels. The note in RM 13.3.10, pg 393,
   --  says we cannot enable the mode for both regular and injected channels
   --  at the same time, so this flag ensures we follow that rule.

   procedure Disable_Discontinuous_Mode_Regular
     (This : in out Analog_To_Digital_Converter)
      with Post => not Discontinuous_Mode_Regular_Enabled (This);

   procedure Disable_Discontinuous_Mode_Injected
     (This : in out Analog_To_Digital_Converter)
      with Post => not Discontinuous_Mode_Injected_Enabled (This);

   function Discontinuous_Mode_Regular_Enabled
     (This : Analog_To_Digital_Converter)
     return Boolean;

   function Discontinuous_Mode_Injected_Enabled
     (This : Analog_To_Digital_Converter)
      return Boolean;

   function AutoInjection_Enabled
     (This : Analog_To_Digital_Converter)
      return Boolean;

   --  DMA Management  --------------------------------------------------------

   procedure Enable_DMA (This : in out Analog_To_Digital_Converter) with
     Pre => not Conversion_Started (This) and
            not Injected_Conversion_Started (This),
     Post => DMA_Enabled (This);

   procedure Disable_DMA (This : in out Analog_To_Digital_Converter) with
     Pre => not Conversion_Started (This) and
            not Injected_Conversion_Started (This),
     Post => not DMA_Enabled (This);

   function DMA_Enabled (This : Analog_To_Digital_Converter) return Boolean;

   procedure Enable_DMA_After_Last_Transfer
     (This : in out Analog_To_Digital_Converter) with
     Pre => not Conversion_Started (This) and
            not Injected_Conversion_Started (This),
     Post => DMA_Enabled_After_Last_Transfer (This);

   procedure Disable_DMA_After_Last_Transfer
     (This : in out Analog_To_Digital_Converter) with
     Pre => not Conversion_Started (This) and
            not Injected_Conversion_Started (This),
     Post => not DMA_Enabled_After_Last_Transfer (This);

   function DMA_Enabled_After_Last_Transfer
     (This : Analog_To_Digital_Converter)
      return Boolean;

   --  Analog Watchdog  -------------------------------------------------------

   subtype Watchdog_Threshold is UInt12;

   type Analog_Watchdog_Modes is
     (Watchdog_All_Regular_Channels,
      Watchdog_All_Injected_Channels,
      Watchdog_All_Both_Kinds,
      Watchdog_Single_Regular_Channel,
      Watchdog_Single_Injected_Channel,
      Watchdog_Single_Both_Kinds);

   subtype Multiple_Channels_Watchdog is Analog_Watchdog_Modes
     range Watchdog_All_Regular_Channels .. Watchdog_All_Both_Kinds;

   procedure Watchdog_Enable_Channels
     (This : in out Analog_To_Digital_Converter;
      Mode : Multiple_Channels_Watchdog;
      Low  : Watchdog_Threshold;
      High : Watchdog_Threshold)
     with
       Pre  => not Watchdog_Enabled (This),
       Post => Watchdog_Enabled (This);
   --  Enables the watchdog on all channels; channel kind depends on Mode.
   --  A call to this routine is considered a complete configuration of the
   --  watchdog so do not call the other enabler routine (for a single channel)
   --  while this configuration is active. You must first disable the watchdog
   --  if you want to enable the watchdog for a single channel.
   --  see RM0364 rev 4 Chapter 13.3.28, pg 257, Table 44.

   subtype Single_Channel_Watchdog is Analog_Watchdog_Modes
     range Watchdog_Single_Regular_Channel .. Watchdog_Single_Both_Kinds;

   procedure Watchdog_Enable_Channel
     (This    : in out Analog_To_Digital_Converter;
      Mode    : Single_Channel_Watchdog;
      Channel : Analog_Input_Channel;
      Low     : Watchdog_Threshold;
      High    : Watchdog_Threshold)
     with
       Pre  => not Watchdog_Enabled (This),
       Post => Watchdog_Enabled (This);
   --  Enables the watchdog on this single channel, and no others. The kind of
   --  channel depends on Mode. A call to this routine is considered a complete
   --  configuration of the watchdog so do not call the other enabler routine
   --  (for all channels) while this configuration is active. You must
   --  first disable the watchdog if you want to enable the watchdog for
   --  all channels.
   --  see RM0364 rev 4 Chapter 13.3.28, pg 257, Table 44.

   procedure Watchdog_Disable (This : in out Analog_To_Digital_Converter)
     with Post => not Watchdog_Enabled (This);
   --  Whether watching a single channel or all of them, the watchdog is now
   --  disabled

   function Watchdog_Enabled (This : Analog_To_Digital_Converter)
      return Boolean;

   type Analog_Window_Watchdog is (Watchdog_2, Watchdog_3);

   procedure Watchdog_Enable_Channel
     (This     : in out Analog_To_Digital_Converter;
      Watchdog : Analog_Window_Watchdog;
      Channel  : Analog_Input_Channel;
      Low      : Watchdog_Threshold;
      High     : Watchdog_Threshold)
     with
       Pre  => not Conversion_Started (This),
       Post => Watchdog_Enabled (This, Watchdog);
   --  Enable the watchdog 2 or 3 for any selected channel. The channels
   --  selected by AWDxCH must be also selected into the ADC regular or injected
   --  sequence registers SQRi or JSQRi registers. The watchdog is disabled when
   --  none channel is selected.
   --  The watchdog threshold is limited to a resolution of 8 bits, so only the
   --  8 MSBs of the thresholds can be programmed into HTx[7:0] and LTx[7:0].
   --  See RM0364 rev 4, chapter 13.3.28, table 46 for 12- to 6-bit resolutions.

   procedure Watchdog_Disable_Channel
     (This     : in out Analog_To_Digital_Converter;
      Watchdog : Analog_Window_Watchdog;
      Channel  : Analog_Input_Channel)
     with
       Pre  => not Conversion_Started (This);

   procedure Watchdog_Disable
     (This     : in out Analog_To_Digital_Converter;
      Watchdog : Analog_Window_Watchdog)
     with Post => not Watchdog_Enabled (This, Watchdog);
   --  The watchdog is disabled when none channel is selected.

   function Watchdog_Enabled
     (This     : Analog_To_Digital_Converter;
      Watchdog : Analog_Window_Watchdog) return Boolean;
   --  The watchdog is enabled when any channel is selected.

   --  Status Management  -----------------------------------------------------

   type ADC_Status_Flag is
     (ADC_Ready,
      Regular_Channel_Conversion_Completed,
      Regular_Sequence_Conversion_Completed,
      Injected_Channel_Conversion_Completed,
      Injected_Sequence_Conversion_Completed,
      Analog_Watchdog_1_Event_Occurred,
      Analog_Watchdog_2_Event_Occurred,
      Analog_Watchdog_3_Event_Occurred,
      Sampling_Completed,
      Overrun,
      Injected_Context_Queue_Overflow);

   function Status
     (This : Analog_To_Digital_Converter;
      Flag : ADC_Status_Flag)
      return Boolean
     with Inline;
   --  Returns whether Flag is indicated, ie set in the Status Register

   procedure Clear_Status
     (This : in out Analog_To_Digital_Converter;
      Flag : ADC_Status_Flag)
     with
       Inline,
       Post => not Status (This, Flag);

   procedure Poll_For_Status
     (This    : in out Analog_To_Digital_Converter;
      Flag    : ADC_Status_Flag;
      Success : out Boolean;
      Timeout : Time_Span := Time_Span_Last);
   --  Continuously polls for the specified status flag to be set, up to the
   --  deadline computed by the value of Clock + Timeout. Sets the Success
   --  argument accordingly. The default Time_Span_Last value is the largest
   --  possible value, thereby setting a very long, but not infinite, timeout.

   --  Interrupt Management  --------------------------------------------------

   type ADC_Interrupts is
     (ADC_Ready,
      Regular_Channel_Conversion_Complete,
      Regular_Sequence_Conversion_Complete,
      Injected_Channel_Conversion_Complete,
      Injected_Sequence_Conversion_Complete,
      Analog_Watchdog_1_Event_Occurr,
      Analog_Watchdog_2_Event_Occurr,
      Analog_Watchdog_3_Event_Occurr,
      Sampling_Complete,
      Overrun,
      Injected_Context_Queue_Overflow);

   procedure Enable_Interrupts
     (This   : in out Analog_To_Digital_Converter;
      Source : ADC_Interrupts)
     with
       Inline,
       Post => Interrupt_Enabled (This, Source);

   procedure Disable_Interrupts
     (This   : in out Analog_To_Digital_Converter;
      Source : ADC_Interrupts)
     with
       Inline,
       Post => not Interrupt_Enabled (This, Source);

   function Interrupt_Enabled
     (This   : Analog_To_Digital_Converter;
      Source : ADC_Interrupts)
      return Boolean
     with Inline;

   procedure Clear_Interrupt_Pending
     (This   : in out Analog_To_Digital_Converter;
      Source : ADC_Interrupts)
     with Inline;

   --  Common Properties ------------------------------------------------------

   type ADC_Clock_Mode is
     (CLK_ADC,
      PCLK2_Div_1,
      PCLK2_Div_2,
      PCLK2_Div_4);

   type Dual_ADC_DMA_Modes is
     (Disabled,
      DMA_Mode_1,
      DMA_Mode_2);

   for Dual_ADC_DMA_Modes use
     (Disabled   => 2#00#,
      DMA_Mode_1 => 2#10#,
      DMA_Mode_2 => 2#11#);

   type Sampling_Delay_Selections is
     (Sampling_Delay_5_Cycles,
      Sampling_Delay_6_Cycles,
      Sampling_Delay_7_Cycles,
      Sampling_Delay_8_Cycles,
      Sampling_Delay_9_Cycles,
      Sampling_Delay_10_Cycles,
      Sampling_Delay_11_Cycles,
      Sampling_Delay_12_Cycles,
      Sampling_Delay_13_Cycles,
      Sampling_Delay_14_Cycles,
      Sampling_Delay_15_Cycles,
      Sampling_Delay_16_Cycles,
      Sampling_Delay_17_Cycles,
      Sampling_Delay_18_Cycles,
      Sampling_Delay_19_Cycles,
      Sampling_Delay_20_Cycles);

   type Multi_ADC_Mode_Selections is
     (Independent,
      Dual_Combined_Regular_Injected_Simultaneous,
      Dual_Combined_Regular_Simultaneous_Alternate_Trigger,
      Dual_Combined_Interleaved_Injected_Simultaneous,
      Dual_Injected_Simultaneous,
      Dual_Regular_Simultaneous,
      Dual_Interleaved,
      Dual_Alternate_Trigger);

   for Multi_ADC_Mode_Selections use
     (Independent                                            => 2#00000#,
      Dual_Combined_Regular_Injected_Simultaneous            => 2#00001#,
      Dual_Combined_Regular_Simultaneous_Alternate_Trigger   => 2#00010#,
      Dual_Combined_Interleaved_Injected_Simultaneous        => 2#00011#,
      Dual_Injected_Simultaneous                             => 2#00101#,
      Dual_Regular_Simultaneous                              => 2#00110#,
      Dual_Interleaved                                       => 2#00111#,
      Dual_Alternate_Trigger                                 => 2#01001#);

   procedure Configure_Common_Properties
     (Mode           : Multi_ADC_Mode_Selections;
      Clock_Mode     : ADC_Clock_Mode;
      DMA_Mode       : Dual_ADC_DMA_Modes;
      Sampling_Delay : Sampling_Delay_Selections);
   --  These properties are common to all the ADC units on the board.

   --  These Multi_DMA_Mode commands needs to be separate from the
   --  Configure_Common_Properties procedure for the sake of dealing
   --  with overruns etc.

   procedure Multi_Enable_DMA_After_Last_Transfer with
     Post => Multi_DMA_Enabled_After_Last_Transfer;
   --  Make shure to execute this procedure only when conversion is
   --  not started.

   procedure Multi_Disable_DMA_After_Last_Transfer with
     Post => not Multi_DMA_Enabled_After_Last_Transfer;
   --  Make shure to execute this procedure only when conversion is
   --  not started.

   function Multi_DMA_Enabled_After_Last_Transfer return Boolean;

   --  Queries ----------------------------------------------------------------

   function VBat_Conversion
     (This    : Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel)
      return Boolean with Inline;

   function VRef_TemperatureSensor_Conversion
     (This    : Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel)
      return Boolean with Inline;
   --  Returns whether the ADC unit and channel specified are that of a VRef
   --  OR a temperature sensor conversion. Note that one control bit is used
   --  to enable either one, ie it is shared.

   function VBat_May_Be_Enabled
     (This  : Analog_To_Digital_Converter;
      These : Regular_Channel_Conversions)
      return Boolean
   is
     ((for all Conversion of These =>
        (if VBat_Conversion (This, Conversion.Channel) then VBat_Enabled)));

   function VBat_May_Be_Enabled
     (This  : Analog_To_Digital_Converter;
      These : Injected_Channel_Conversions)
      return Boolean
   is
     ((for all Conversion of These =>
        (if VBat_Conversion (This, Conversion.Channel) then VBat_Enabled)));

   function VRef_TemperatureSensor_May_Be_Enabled
     (This  : Analog_To_Digital_Converter;
      These : Regular_Channel_Conversions)
      return Boolean
   is
     (for all Conversion of These =>
        (if VRef_TemperatureSensor_Conversion (This, Conversion.Channel) then
              VRef_TemperatureSensor_Enabled));

   function VRef_TemperatureSensor_May_Be_Enabled
     (This  : Analog_To_Digital_Converter;
      These : Injected_Channel_Conversions)
      return Boolean
   is
     (for all Conversion of These =>
        (if VRef_TemperatureSensor_Conversion (This, Conversion.Channel) then
              VRef_TemperatureSensor_Enabled));

   --  The *_Conversions_Expected functions will always return at least the
   --  value 1 because the hardware uses a biased representation (in which
   --  zero indicates the value one, one indicates the value two, and so on).
   --  Therefore, we don't invoke the functions unless we know they will be
   --  greater than zero.

   function Length_Matches_Expected
     (This  : Analog_To_Digital_Converter;
      These : Regular_Channel_Conversions)
      return Boolean
   is
     (if These'Length > 0 then
         Regular_Conversions_Expected (This) = These'Length);

   function Length_Is_Expected
     (This  : Analog_To_Digital_Converter;
      These : Injected_Channel_Conversions)
      return Boolean
   is
     (if These'Length > 0 then
         Injected_Conversions_Expected (This) = These'Length);

private

   ADC_Stabilization                : constant Time_Span := Microseconds (3);
   Temperature_Sensor_Stabilization : constant Time_Span := Microseconds (10);
   --  The RM, section 13.3.6, says stabilization times are required. These
   --  values are specified in the datasheets, eg section 5.3.20, pg 129,
   --  and section 5.3.21, pg 134, of the STM32F405/7xx, DocID022152 Rev 4.

   procedure Configure_Regular_Channel
     (This        : in out Analog_To_Digital_Converter;
      Channel     : Analog_Input_Channel;
      Rank        : Regular_Channel_Rank;
      Sample_Time : Channel_Sampling_Times);

   procedure Configure_Injected_Channel
     (This        : in out Analog_To_Digital_Converter;
      Channel     : Analog_Input_Channel;
      Rank        : Injected_Channel_Rank;
      Sample_Time : Channel_Sampling_Times;
      Offset      : Injected_Data_Offset);

   procedure Enable_VBat_Connection with
     Post => VBat_Enabled;

   procedure Enable_VRef_TemperatureSensor_Connection with
     Post => VRef_TemperatureSensor_Enabled;
   --  One bit controls both the VRef and the temperature internal connections

   type Analog_To_Digital_Converter is new STM32_SVD.ADC.ADC1_Peripheral;

   function VBat_Conversion
     (This    : Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel)
      return Boolean
   is (This'Address = STM32_SVD.ADC.ADC1_Periph'Address and
         Channel = VBat_Channel);

   function VRef_TemperatureSensor_Conversion
     (This    : Analog_To_Digital_Converter;
      Channel : Analog_Input_Channel)
      return Boolean
   is (This'Address = STM32_SVD.ADC.ADC1_Periph'Address and
         (Channel in VRef_Channel | TemperatureSensor_Channel));

end STM32.ADC;
