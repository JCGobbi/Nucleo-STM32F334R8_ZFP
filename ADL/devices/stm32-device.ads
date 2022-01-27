------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2015-2018, AdaCore                     --
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
--   @file    stm32f334x8.h                                                 --
--   @author  Julio C. Gobbi                                                --
--   @version V1.0.0                                                        --
--   @date    24-March-2021                                                 --
--   @brief   CMSIS STM32F334xx Device Peripheral Access Layer Header File. --
--                                                                          --
--   COPYRIGHT(c) 2014 STMicroelectronics                                   --
------------------------------------------------------------------------------

--  This file provides declarations for devices on the STM32F334x8 MCUs
--  manufactured by ST Microelectronics.  For example, an STM32F334R8.

with STM32_SVD;      use STM32_SVD;
--  with STM32_SVD.SYSCFG; --  Enable for COMP and OPAMP

with STM32.GPIO;     use STM32.GPIO;
with STM32.ADC;      use STM32.ADC;
--  with STM32.DAC;      use STM32.DAC;
--  with STM32.CRC;      use STM32.CRC;
--  with STM32.DMA;      use STM32.DMA;
--  with STM32.USARTs;   use STM32.USARTs;
--  with STM32.SPI;      use STM32.SPI;
--  with STM32.I2C;      use STM32.I2C;
--  with STM32.RTC;      use STM32.RTC;
with STM32.Timers;   use STM32.Timers;
--  with STM32.HRTimers; use STM32.HRTimers;
--  with STM32.OPAMP;    use STM32.OPAMP;
--  with STM32.COMP;     use STM32.COMP;

package STM32.Device is
   pragma Elaborate_Body;

   Unknown_Device : exception;
   --  Raised by the routines below for a device passed as an actual parameter
   --  when that device is not present on the given hardware instance.

   ----------
   -- GPIO --
   ----------

   procedure Enable_Clock (This : aliased GPIO_Port);
   procedure Enable_Clock (Point : GPIO_Point);
   procedure Enable_Clock (Points : GPIO_Points);

   procedure Reset (This : aliased GPIO_Port)
     with Inline;
   procedure Reset (Point : GPIO_Point)
     with Inline;
   procedure Reset (Points : GPIO_Points)
     with Inline;

   function GPIO_Port_Representation (Port : GPIO_Port) return UInt4
     with Inline;

   GPIO_A : aliased GPIO_Port with Import, Volatile, Address => GPIOA_Base;
   GPIO_B : aliased GPIO_Port with Import, Volatile, Address => GPIOB_Base;
   GPIO_C : aliased GPIO_Port with Import, Volatile, Address => GPIOC_Base;
   GPIO_D : aliased GPIO_Port with Import, Volatile, Address => GPIOD_Base;
   GPIO_F : aliased GPIO_Port with Import, Volatile, Address => GPIOF_Base;

   PA0  : aliased GPIO_Point := (GPIO_A'Access, Pin_0);
   PA1  : aliased GPIO_Point := (GPIO_A'Access, Pin_1);
   PA2  : aliased GPIO_Point := (GPIO_A'Access, Pin_2);
   PA3  : aliased GPIO_Point := (GPIO_A'Access, Pin_3);
   PA4  : aliased GPIO_Point := (GPIO_A'Access, Pin_4);
   PA5  : aliased GPIO_Point := (GPIO_A'Access, Pin_5);
   PA6  : aliased GPIO_Point := (GPIO_A'Access, Pin_6);
   PA7  : aliased GPIO_Point := (GPIO_A'Access, Pin_7);
   PA8  : aliased GPIO_Point := (GPIO_A'Access, Pin_8);
   PA9  : aliased GPIO_Point := (GPIO_A'Access, Pin_9);
   PA10 : aliased GPIO_Point := (GPIO_A'Access, Pin_10);
   PA11 : aliased GPIO_Point := (GPIO_A'Access, Pin_11);
   PA12 : aliased GPIO_Point := (GPIO_A'Access, Pin_12);
   PA13 : aliased GPIO_Point := (GPIO_A'Access, Pin_13);
   PA14 : aliased GPIO_Point := (GPIO_A'Access, Pin_14);
   PA15 : aliased GPIO_Point := (GPIO_A'Access, Pin_15);
   PB0  : aliased GPIO_Point := (GPIO_B'Access, Pin_0);
   PB1  : aliased GPIO_Point := (GPIO_B'Access, Pin_1);
   PB2  : aliased GPIO_Point := (GPIO_B'Access, Pin_2);
   PB3  : aliased GPIO_Point := (GPIO_B'Access, Pin_3);
   PB4  : aliased GPIO_Point := (GPIO_B'Access, Pin_4);
   PB5  : aliased GPIO_Point := (GPIO_B'Access, Pin_5);
   PB6  : aliased GPIO_Point := (GPIO_B'Access, Pin_6);
   PB7  : aliased GPIO_Point := (GPIO_B'Access, Pin_7);
   PB8  : aliased GPIO_Point := (GPIO_B'Access, Pin_8);
   PB9  : aliased GPIO_Point := (GPIO_B'Access, Pin_9);
   PB10 : aliased GPIO_Point := (GPIO_B'Access, Pin_10);
   PB11 : aliased GPIO_Point := (GPIO_B'Access, Pin_11);
   PB12 : aliased GPIO_Point := (GPIO_B'Access, Pin_12);
   PB13 : aliased GPIO_Point := (GPIO_B'Access, Pin_13);
   PB14 : aliased GPIO_Point := (GPIO_B'Access, Pin_14);
   PB15 : aliased GPIO_Point := (GPIO_B'Access, Pin_15);
   PC0  : aliased GPIO_Point := (GPIO_C'Access, Pin_0);
   PC1  : aliased GPIO_Point := (GPIO_C'Access, Pin_1);
   PC2  : aliased GPIO_Point := (GPIO_C'Access, Pin_2);
   PC3  : aliased GPIO_Point := (GPIO_C'Access, Pin_3);
   PC4  : aliased GPIO_Point := (GPIO_C'Access, Pin_4);
   PC5  : aliased GPIO_Point := (GPIO_C'Access, Pin_5);
   PC6  : aliased GPIO_Point := (GPIO_C'Access, Pin_6);
   PC7  : aliased GPIO_Point := (GPIO_C'Access, Pin_7);
   PC8  : aliased GPIO_Point := (GPIO_C'Access, Pin_8);
   PC9  : aliased GPIO_Point := (GPIO_C'Access, Pin_9);
   PC10 : aliased GPIO_Point := (GPIO_C'Access, Pin_10);
   PC11 : aliased GPIO_Point := (GPIO_C'Access, Pin_11);
   PC12 : aliased GPIO_Point := (GPIO_C'Access, Pin_12);
   PC13 : aliased GPIO_Point := (GPIO_C'Access, Pin_13);
   PC14 : aliased GPIO_Point := (GPIO_C'Access, Pin_14);
   PC15 : aliased GPIO_Point := (GPIO_C'Access, Pin_15);
   PD0  : aliased GPIO_Point := (GPIO_D'Access, Pin_0);
   PD1  : aliased GPIO_Point := (GPIO_D'Access, Pin_1);
   PD2  : aliased GPIO_Point := (GPIO_D'Access, Pin_2);
   PD3  : aliased GPIO_Point := (GPIO_D'Access, Pin_3);
   PD4  : aliased GPIO_Point := (GPIO_D'Access, Pin_4);
   PD5  : aliased GPIO_Point := (GPIO_D'Access, Pin_5);
   PD6  : aliased GPIO_Point := (GPIO_D'Access, Pin_6);
   PD7  : aliased GPIO_Point := (GPIO_D'Access, Pin_7);
   PD8  : aliased GPIO_Point := (GPIO_D'Access, Pin_8);
   PD9  : aliased GPIO_Point := (GPIO_D'Access, Pin_9);
   PD10 : aliased GPIO_Point := (GPIO_D'Access, Pin_10);
   PD11 : aliased GPIO_Point := (GPIO_D'Access, Pin_11);
   PD12 : aliased GPIO_Point := (GPIO_D'Access, Pin_12);
   PD13 : aliased GPIO_Point := (GPIO_D'Access, Pin_13);
   PD14 : aliased GPIO_Point := (GPIO_D'Access, Pin_14);
   PD15 : aliased GPIO_Point := (GPIO_D'Access, Pin_15);
   PF0  : aliased GPIO_Point := (GPIO_F'Access, Pin_0);
   PF1  : aliased GPIO_Point := (GPIO_F'Access, Pin_1);
   PF2  : aliased GPIO_Point := (GPIO_F'Access, Pin_2);
   PF3  : aliased GPIO_Point := (GPIO_F'Access, Pin_3);
   PF4  : aliased GPIO_Point := (GPIO_F'Access, Pin_4);
   PF5  : aliased GPIO_Point := (GPIO_F'Access, Pin_5);
   PF6  : aliased GPIO_Point := (GPIO_F'Access, Pin_6);
   PF7  : aliased GPIO_Point := (GPIO_F'Access, Pin_7);
   PF8  : aliased GPIO_Point := (GPIO_F'Access, Pin_8);
   PF9  : aliased GPIO_Point := (GPIO_F'Access, Pin_9);
   PF10 : aliased GPIO_Point := (GPIO_F'Access, Pin_10);
   PF11 : aliased GPIO_Point := (GPIO_F'Access, Pin_11);
   PF12 : aliased GPIO_Point := (GPIO_F'Access, Pin_12);
   PF13 : aliased GPIO_Point := (GPIO_F'Access, Pin_13);
   PF14 : aliased GPIO_Point := (GPIO_F'Access, Pin_14);
   PF15 : aliased GPIO_Point := (GPIO_F'Access, Pin_15);

   GPIO_AF_RTC_50Hz_0  : constant GPIO_Alternate_Function;
   GPIO_AF_MCO_0       : constant GPIO_Alternate_Function;
   GPIO_AF_TAMPER_0    : constant GPIO_Alternate_Function;
   GPIO_AF_SWJ_0       : constant GPIO_Alternate_Function;
   GPIO_AF_TRACE_0     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM2_1      : constant GPIO_Alternate_Function;
   GPIO_AF_TIM15_1     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM16_1     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM17_1     : constant GPIO_Alternate_Function;
   GPIO_AF_EVENT_1     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM1_2      : constant GPIO_Alternate_Function;
   GPIO_AF_TIM3_2      : constant GPIO_Alternate_Function;
   GPIO_AF_TIM15_2     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM16_2     : constant GPIO_Alternate_Function;
   GPIO_AF_HRTIM1_3    : constant GPIO_Alternate_Function;
   GPIO_AF_TSC_3       : constant GPIO_Alternate_Function;
   GPIO_AF_I2C1_4      : constant GPIO_Alternate_Function;
   GPIO_AF_TIM1_4      : constant GPIO_Alternate_Function;
   GPIO_AF_SPI1_5      : constant GPIO_Alternate_Function;
   GPIO_AF_INFRARED_5  : constant GPIO_Alternate_Function;
   GPIO_AF_TIM1_6      : constant GPIO_Alternate_Function;
   GPIO_AF_INFRARED_6  : constant GPIO_Alternate_Function;
   GPIO_AF_USART1_7    : constant GPIO_Alternate_Function;
   GPIO_AF_USART2_7    : constant GPIO_Alternate_Function;
   GPIO_AF_USART3_7    : constant GPIO_Alternate_Function;
   GPIO_AF_COMP6_7     : constant GPIO_Alternate_Function;
   GPIO_AF_COMP2_8     : constant GPIO_Alternate_Function;
   GPIO_AF_COMP4_8     : constant GPIO_Alternate_Function;
   GPIO_AF_COMP6_8     : constant GPIO_Alternate_Function;
   GPIO_AF_CAN_9       : constant GPIO_Alternate_Function;
   GPIO_AF_TIM1_9      : constant GPIO_Alternate_Function;
   GPIO_AF_TIM15_9     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM2_10     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM3_10     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM17_10    : constant GPIO_Alternate_Function;
   GPIO_AF_TIM1_11     : constant GPIO_Alternate_Function;
   GPIO_AF_HRTIM1_12   : constant GPIO_Alternate_Function;
   GPIO_AF_TIM1_12     : constant GPIO_Alternate_Function;
   GPIO_AF_HRTIM1_13   : constant GPIO_Alternate_Function;
   GPIO_AF_OPAMP2_13   : constant GPIO_Alternate_Function;
   GPIO_AF_EVENTOUT_15 : constant GPIO_Alternate_Function;

   ---------
   -- ADC --
   ---------

   ADC_1      : aliased Analog_To_Digital_Converter
     with Volatile, Import, Address => ADC1_Base;
   ADC_2      : aliased Analog_To_Digital_Converter
     with Volatile, Import, Address => ADC2_Base;

   Temperature_Channel : constant Analog_Input_Channel := 16;
   Temperature_Sensor  : constant ADC_Point :=
     (ADC_1'Access, Channel => Temperature_Channel);
   --  see RM pg 274, section 13.3.30, also pg 214

   VRef_Channel : constant Analog_Input_Channel := 18;
   VRef_Sensor  : constant ADC_Point :=
     (ADC_1'Access, Channel => VRef_Channel);
   --  see RM pg 274, section 13.3.30, also pg 214

   VBat_Channel : constant Analog_Input_Channel := 17;
   VBat_Sensor  : constant ADC_Point :=
     (ADC_1'Access, Channel => VBat_Channel);
   VBat : constant ADC_Point := (ADC_1'Access, Channel => VBat_Channel);

   VBat_Bridge_Divisor : constant := 2;
   --  The VBAT pin is internally connected to a bridge divider. The actual
   --  voltage is the raw conversion value * the divisor. See section 13.3.31,
   --  pg 276 of the RM.

   VRef_OpAmp_2_Channel : constant Analog_Input_Channel := 17;
   VRef_OpAmp_2_Sensor  : constant ADC_Point :=
     (ADC_2'Access, Channel => VRef_OpAmp_2_Channel);
   --  see RM pg 224, section 13.3.11

   procedure Enable_Clock (This : aliased Analog_To_Digital_Converter);

   procedure Reset_All_ADC_Units;

   type ADC_Clock_Source is (AHB, PLLCLK);

   type ADC_Prescaler_Enum is
     (DIV_1,  DIV_2,  DIV_4,  DIV_6,  DIV_8,   DIV_10,
      DIV_12, DIV_16, DIV_32, DIV_64, DIV_128, DIV_256)
     with Size => 4;

   type ADC_Prescaler is record
      Enable : Boolean := False;
      Value  : ADC_Prescaler_Enum := ADC_Prescaler_Enum'First;
   end record with Size => 5;

   for ADC_Prescaler use record
      Enable at 0 range 4 .. 4;
      Value  at 0 range 0 .. 3;
   end record;

   procedure Select_Clock_Source
     (This      : Analog_To_Digital_Converter;
      Source    : ADC_Clock_Source;
      Prescaler : ADC_Prescaler := (Enable => False, Value => DIV_2));
   --  Example to create a variable:
   --  AHB_PRE  : ADC_Prescaler := (Enable => True, Value => DIV2);
   --  To disable (and use AHB) use:
   --  AHB_PRE  : ADC_Prescaler := (Enable => False, Value => DIV2);

   ---------
   -- DAC --
   ---------

   --  DAC_1 : aliased Digital_To_Analog_Converter
   --    with Import, Volatile, Address => DAC1_Base;
   --  DAC_2 : aliased Digital_To_Analog_Converter
   --    with Import, Volatile, Address => DAC2_Base;
   --
   --  DAC_Channel_1_IO : GPIO_Point renames PA4;
   --  DAC_Channel_2_IO : GPIO_Point renames PA5;
   --
   --  procedure Enable_Clock
   --    (This : aliased Digital_To_Analog_Converter)
   --    with Inline;
   --
   --  procedure Reset
   --    (This : aliased Digital_To_Analog_Converter)
   --    with Inline;

   ---------
   -- CRC --
   ---------

   --  CRC_Unit : CRC_32 with Import, Volatile, Address => CRC_Base;

   --  procedure Enable_Clock (This : CRC_32) with Inline;

   --  procedure Disable_Clock (This : CRC_32) with Inline;

   --  procedure Reset (This : CRC_32);

   ---------
   -- DMA --
   ---------

   --  DMA_1 : aliased DMA_Controller
   --    with Import, Volatile, Address => DMA_Base;
   --
   --  procedure Enable_Clock (This : aliased DMA_Controller);
   --  procedure Reset (This : aliased DMA_Controller);

   -----------
   -- USART --
   -----------

   --  Internal_USART_1 : aliased Internal_USART
   --    with Import, Volatile, Address => USART1_Base;
   --  Internal_USART_2 : aliased Internal_USART
   --    with Import, Volatile, Address => USART2_Base;
   --  Internal_USART_3 : aliased Internal_USART
   --    with Import, Volatile, Address => USART3_Base;

   --  USART_1 : aliased USART (Internal_USART_1'Access);
   --  USART_2 : aliased USART (Internal_USART_2'Access);
   --  USART_3 : aliased USART (Internal_USART_3'Access);

   --  procedure Enable_Clock (This : aliased USART);

   --  procedure Reset (This : aliased USART);

   --  type USART_Clock_Source is (PCLK, SYSCLK, LSE, HSI);

   --  procedure Select_Clock_Source
   --    (This   : USART;
   --     Source : USART_Clock_Source)
   --    with Post => Read_Clock_Source (This) = Source;
   --  --  Set the clock for USART1.

   --  function Read_Clock_Source (This : USART) return USART_Clock_Source;

   ---------
   -- I2C --
   ---------

   --  Internal_I2C_Port_1 : aliased Internal_I2C_Port
   --  with Import, Volatile, Address => I2C_Base;
   --
   --  type I2C_Port_Id is (I2C_Id_1);
   --
   --  I2C_1 : aliased I2C_Port (Internal_I2C_Port_1'Access);
   --
   --  --  I2C_1_DMA : aliased I2C_Port_DMA (Internal_I2C_Port_1'Access);
   --
   --  function As_Port_Id (Port : I2C_Port'Class) return I2C_Port_Id with Inline;
   --
   --  procedure Enable_Clock (This : aliased I2C_Port'Class);
   --  procedure Enable_Clock (This : I2C_Port_Id);
   --
   --  procedure Reset (This : I2C_Port'Class);
   --  procedure Reset (This : I2C_Port_Id);

   --  type I2C_Clock_Source is (HSI, SYSCLK);
   --
   --  procedure Select_Clock_Source (This   : I2C_Port'Class;
   --                                 Source : I2C_Clock_Source);
   --
   --  procedure Select_Clock_Source (This   : I2C_Port_Id;
   --                                 Source : I2C_Clock_Source);
   --  --  Set I2C Clock Mux source.
   --
   --  function Read_Clock_Source (This : I2C_Port'Class) return I2C_Clock_Source;
   --
   --  function Read_Clock_Source (This : I2C_Port_Id) return I2C_Clock_Source;
   --  --  Return I2C Clock Mux source.

   ---------
   -- SPI --
   ---------

   --  Internal_SPI_1 : aliased Internal_SPI_Port
   --    with Import, Volatile, Address => SPI_Base;

   --  SPI_1 : aliased SPI_Port (Internal_SPI_1'Access);

   --  SPI_1_DMA : aliased SPI_Port_DMA (Internal_SPI_1'Access);

   --  procedure Enable_Clock (This : SPI_Port'Class);
   --  procedure Reset (This : SPI_Port'Class);

   ---------
   -- RTC --
   ---------

   --  RTC : aliased RTC_Device;

   --  procedure Enable_Clock (This : RTC_Device);
   --
   --  type RTC_Clock_Source is (No_Clock, LSE, LSI, HSE)
   --    with Size => 2;
   --
   --  procedure Select_Clock_Source
   --    (This       : RTC_Device;
   --     Source     : RTC_Clock_Source)
   --    with Post => Source = Read_Clock_Source (This);
   --  --  Set RTC Clock Mux source. Once the RTC clock source has been selected,
   --  --  it cannot be changed anymore unless the RTC domain is reset, or unless
   --  --  a failure is detected on LSE (LSECSSD is set). The BDRST bit can be used
   --  --  to reset them.
   --  --  The HSE clock is divided by 32 before entering the RTC to assure it is
   --  --  < 1 MHz.
   --
   --  function Read_Clock_Source (This : RTC_Device) return RTC_Clock_Source;
   --  --  Return RTC Clock Mux source.

   -----------
   -- Timer --
   -----------

   Timer_1  : aliased Timer with Import, Volatile, Address => TIM1_Base;
   Timer_2  : aliased Timer with Import, Volatile, Address => TIM2_Base;
   Timer_3  : aliased Timer with Import, Volatile, Address => TIM3_Base;
   Timer_6  : aliased Timer with Import, Volatile, Address => TIM6_Base;
   Timer_7  : aliased Timer with Import, Volatile, Address => TIM7_Base;
   Timer_15 : aliased Timer with Import, Volatile, Address => TIM15_Base;
   Timer_16 : aliased Timer with Import, Volatile, Address => TIM16_Base;
   Timer_17 : aliased Timer with Import, Volatile, Address => TIM17_Base;

   procedure Enable_Clock (This : Timer);

   procedure Reset (This : Timer);

   type Timer_Clock_Source is (PCLK2, PLLCLK);

   procedure Select_Clock_Source
     (This   : Timer;
      Source : Timer_Clock_Source)
     with Post => Read_Clock_Source (This) = Source;
   --  Set the clock for TIM1 to 2 x PLLCLK or PCLK2.

   function Read_Clock_Source (This : Timer) return Timer_Clock_Source;

   function Get_Clock_Frequency (This : Timer) return UInt32;
   --  Returns the timer input frequency in Hz.

   -------------
   -- HRTimer --
   -------------

   --  HRTimer_M : aliased HRTimer_Master
   --    with Import, Volatile, Address => HRTIM_Master_Base;
   --
   --  HRTimer_A : aliased HRTimer_Channel
   --    with Import, Volatile, Address => HRTIM_TIMA_Base;
   --  HRTimer_B : aliased HRTimer_Channel
   --    with Import, Volatile, Address => HRTIM_TIMB_Base;
   --  HRTimer_C : aliased HRTimer_Channel
   --    with Import, Volatile, Address => HRTIM_TIMC_Base;
   --  HRTimer_D : aliased HRTimer_Channel
   --    with Import, Volatile, Address => HRTIM_TIMD_Base;
   --  HRTimer_E : aliased HRTimer_Channel
   --    with Import, Volatile, Address => HRTIM_TIME_Base;
   --
   --  procedure Enable_Clock (This : HRTimer_Master);
   --
   --  procedure Enable_Clock (This : HRTimer_Channel);
   --
   --  procedure Reset (This : HRTimer_Master);
   --
   --  procedure Reset (This : HRTimer_Channel);
   --
   --  procedure Select_Clock_Source
   --    (This   : HRTimer_Master;
   --     Source : Timer_Clock_Source)
   --    with Post => Read_Clock_Source (This) = Source;
   --  --  Set the clock for HRTIM1 to 2 x PLLCLK or PCLK2.
   --
   --  function Read_Clock_Source (This : HRTimer_Master) return Timer_Clock_Source;
   --
   --  function Get_Clock_Frequency (This : HRTimer_Master) return UInt32;
   --  --  Returns the timer input frequency in Hz.
   --
   --  function Get_Clock_Frequency (This : HRTimer_Channel) return UInt32;
   --  --  Returns the HRTIM1 input frequency in Hz.

   ----------------
   -- Comparator --
   ----------------

   --  Comp_2 : aliased Comparator
   --    with Import, Volatile,
   --    Address => STM32_SVD.SYSCFG.SYSCFG_COMP_OPAMP_Periph.COMP2_CSR'Address;
   --  Comp_4 : aliased Comparator
   --    with Import, Volatile,
   --    Address => STM32_SVD.SYSCFG.SYSCFG_COMP_OPAMP_Periph.COMP4_CSR'Address;
   --  Comp_6 : aliased Comparator
   --    with Import, Volatile,
   --    Address => STM32_SVD.SYSCFG.SYSCFG_COMP_OPAMP_Periph.COMP6_CSR'Address;

   -----------
   -- OpAmp --
   -----------

   --  Opamp_2 : aliased Operational_Amplifier
   --    with Import, Volatile,
   --    Address => STM32_SVD.SYSCFG.SYSCFG_COMP_OPAMP_Periph.OPAMP2_CSR'Address;

   -----------------------------
   -- Reset and Clock Control --
   -----------------------------

   --  See RM pg. 107 for clock tree
   type RCC_System_Clocks is record
      SYSCLK    : UInt32;
      HCLK      : UInt32;
      PCLK1     : UInt32;
      PCLK2     : UInt32;
      TIMCLK1   : UInt32; --  For TIMs 2, 3, 6, 7
      TIMCLK2   : UInt32; --  For TIMs 15, 16, 17
      TIM1CLK   : UInt32; --  For TIM1
      HRTIM1CLK : UInt32; --  For HRTIM1
      I2CCLK    : UInt32;
   end record;

   function System_Clock_Frequencies return RCC_System_Clocks;
   --  Returns each RCC system clock frequency in Hz.

private

   GPIO_AF_RTC_50Hz_0  : constant GPIO_Alternate_Function := 0;
   GPIO_AF_MCO_0       : constant GPIO_Alternate_Function := 0;
   GPIO_AF_TAMPER_0    : constant GPIO_Alternate_Function := 0;
   GPIO_AF_SWJ_0       : constant GPIO_Alternate_Function := 0;
   GPIO_AF_TRACE_0     : constant GPIO_Alternate_Function := 0;
   GPIO_AF_TIM2_1      : constant GPIO_Alternate_Function := 1;
   GPIO_AF_TIM15_1     : constant GPIO_Alternate_Function := 1;
   GPIO_AF_TIM16_1     : constant GPIO_Alternate_Function := 1;
   GPIO_AF_TIM17_1     : constant GPIO_Alternate_Function := 1;
   GPIO_AF_EVENT_1     : constant GPIO_Alternate_Function := 1;
   GPIO_AF_TIM1_2      : constant GPIO_Alternate_Function := 2;
   GPIO_AF_TIM3_2      : constant GPIO_Alternate_Function := 2;
   GPIO_AF_TIM15_2     : constant GPIO_Alternate_Function := 2;
   GPIO_AF_TIM16_2     : constant GPIO_Alternate_Function := 2;
   GPIO_AF_HRTIM1_3    : constant GPIO_Alternate_Function := 3;
   GPIO_AF_TSC_3       : constant GPIO_Alternate_Function := 3;
   GPIO_AF_I2C1_4      : constant GPIO_Alternate_Function := 4;
   GPIO_AF_TIM1_4      : constant GPIO_Alternate_Function := 4;
   GPIO_AF_SPI1_5      : constant GPIO_Alternate_Function := 5;
   GPIO_AF_INFRARED_5  : constant GPIO_Alternate_Function := 5;
   GPIO_AF_TIM1_6      : constant GPIO_Alternate_Function := 6;
   GPIO_AF_INFRARED_6  : constant GPIO_Alternate_Function := 6;
   GPIO_AF_USART1_7    : constant GPIO_Alternate_Function := 7;
   GPIO_AF_USART2_7    : constant GPIO_Alternate_Function := 7;
   GPIO_AF_USART3_7    : constant GPIO_Alternate_Function := 7;
   GPIO_AF_COMP6_7     : constant GPIO_Alternate_Function := 7;
   GPIO_AF_COMP2_8     : constant GPIO_Alternate_Function := 8;
   GPIO_AF_COMP4_8     : constant GPIO_Alternate_Function := 8;
   GPIO_AF_COMP6_8     : constant GPIO_Alternate_Function := 8;
   GPIO_AF_CAN_9       : constant GPIO_Alternate_Function := 9;
   GPIO_AF_TIM1_9      : constant GPIO_Alternate_Function := 9;
   GPIO_AF_TIM15_9     : constant GPIO_Alternate_Function := 9;
   GPIO_AF_TIM2_10     : constant GPIO_Alternate_Function := 10;
   GPIO_AF_TIM3_10     : constant GPIO_Alternate_Function := 10;
   GPIO_AF_TIM17_10    : constant GPIO_Alternate_Function := 10;
   GPIO_AF_TIM1_11     : constant GPIO_Alternate_Function := 11;
   GPIO_AF_HRTIM1_12   : constant GPIO_Alternate_Function := 12;
   GPIO_AF_TIM1_12     : constant GPIO_Alternate_Function := 12;
   GPIO_AF_HRTIM1_13   : constant GPIO_Alternate_Function := 13;
   GPIO_AF_OPAMP2_13   : constant GPIO_Alternate_Function := 13;
   GPIO_AF_EVENTOUT_15 : constant GPIO_Alternate_Function := 15;

end STM32.Device;
