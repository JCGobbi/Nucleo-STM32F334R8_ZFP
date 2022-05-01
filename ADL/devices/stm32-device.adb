------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2015-2016, AdaCore                     --
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
--     3. Neither the name of the copyright holder nor the names of its     --
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
------------------------------------------------------------------------------

with System;        use System;
with Ada.Unchecked_Conversion;

with STM32_SVD.RCC; use STM32_SVD.RCC;
with STM32_SVD.CRC; use STM32_SVD.CRC;

with STM32.RCC;     use STM32.RCC;

package body STM32.Device is

   HPRE_Presc_Table : constant array (UInt4) of UInt32 :=
     (1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 8, 16, 64, 128, 256, 512);

   PPRE_Presc_Table : constant array (UInt3) of UInt32 :=
     (1, 1, 1, 1, 2, 4, 8, 16);

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (This : aliased GPIO_Port) is
   begin
      if This'Address = GPIOA_Base then
         RCC_Periph.AHBENR.IOPAEN := True;
      elsif This'Address = GPIOB_Base then
         RCC_Periph.AHBENR.IOPBEN := True;
      elsif This'Address = GPIOC_Base then
         RCC_Periph.AHBENR.IOPCEN := True;
      elsif This'Address = GPIOD_Base then
         RCC_Periph.AHBENR.IOPDEN := True;
      elsif This'Address = GPIOF_Base then
         RCC_Periph.AHBENR.IOPFEN := True;
      else
         raise Unknown_Device;
      end if;
   end Enable_Clock;

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (Point : GPIO_Point)
   is
   begin
      Enable_Clock (Point.Periph.all);
   end Enable_Clock;

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (Points : GPIO_Points)
   is
   begin
      for Point of Points loop
         Enable_Clock (Point.Periph.all);
      end loop;
   end Enable_Clock;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : aliased GPIO_Port) is
   begin
      if This'Address = GPIOA_Base then
         RCC_Periph.AHBRSTR.IOPARST := True;
         RCC_Periph.AHBRSTR.IOPARST := False;
      elsif This'Address = GPIOB_Base then
         RCC_Periph.AHBRSTR.IOPBRST := True;
         RCC_Periph.AHBRSTR.IOPBRST := False;
      elsif This'Address = GPIOC_Base then
         RCC_Periph.AHBRSTR.IOPCRST := True;
         RCC_Periph.AHBRSTR.IOPCRST := False;
      elsif This'Address = GPIOD_Base then
         RCC_Periph.AHBRSTR.IOPDRST := True;
         RCC_Periph.AHBRSTR.IOPDRST := False;
      elsif This'Address = GPIOF_Base then
         RCC_Periph.AHBRSTR.IOPFRST := True;
         RCC_Periph.AHBRSTR.IOPFRST := False;
      else
         raise Unknown_Device;
      end if;
   end Reset;

   -----------
   -- Reset --
   -----------

   procedure Reset (Point : GPIO_Point) is
   begin
      Reset (Point.Periph.all);
   end Reset;

   -----------
   -- Reset --
   -----------

   procedure Reset (Points : GPIO_Points)
   is
      Do_Reset : Boolean;
   begin
      for J in Points'Range loop
         Do_Reset := True;
         for K in Points'First .. J - 1 loop
            if Points (K).Periph = Points (J).Periph then
               Do_Reset := False;

               exit;
            end if;
         end loop;

         if Do_Reset then
            Reset (Points (J).Periph.all);
         end if;
      end loop;
   end Reset;

   ------------------------------
   -- GPIO_Port_Representation --
   ------------------------------

   function GPIO_Port_Representation (Port : GPIO_Port) return UInt4 is
   begin
      --  TODO: rather ugly to have this board-specific range here
      if Port'Address = GPIOA_Base then
         return 0;
      elsif Port'Address = GPIOB_Base then
         return 1;
      elsif Port'Address = GPIOC_Base then
         return 2;
      elsif Port'Address = GPIOD_Base then
         return 3;
      elsif Port'Address = GPIOF_Base then
         return 5;
      else
         raise Program_Error;
      end if;
   end GPIO_Port_Representation;

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (This : aliased Analog_To_Digital_Converter)
   is
   begin
      if This'Address = ADC1_Base then
         RCC_Periph.AHBENR.ADC12EN := True;
      elsif This'Address = ADC2_Base then
         RCC_Periph.AHBENR.ADC12EN := True;
      else
         raise Unknown_Device;
      end if;
   end Enable_Clock;

   -------------------------
   -- Reset_All_ADC_Units --
   -------------------------

   procedure Reset_All_ADC_Units is
   begin
         RCC_Periph.AHBRSTR.ADC12RST := True;
         RCC_Periph.AHBRSTR.ADC12RST := False;
   end Reset_All_ADC_Units;

   -------------------------
   -- Select_Clock_Source --
   -------------------------

   procedure Select_Clock_Source
     (This      : Analog_To_Digital_Converter;
      Source    : ADC_Clock_Source;
      Prescaler : ADC_Prescaler := (Enable => False, Value => DIV_2))
   is
      pragma Unreferenced (This);
      function To_ADCPRE is new Ada.Unchecked_Conversion
        (ADC_Prescaler, UInt5);
      AHB_PRE : constant ADC_Prescaler := (Enable => False, Value => DIV_2);
   begin
      case Source is
         when AHB =>
            RCC_Periph.CFGR2.ADC12PRES := To_ADCPRE (AHB_PRE);
            if not RCC_Periph.AHBENR.ADC12EN then
               RCC_Periph.AHBENR.ADC12EN := True;
            end if;
         when PLLCLK =>
            if Prescaler.Enable then
               RCC_Periph.AHBENR.ADC12EN := False;
            end if;
            RCC_Periph.CFGR2.ADC12PRES := To_ADCPRE (Prescaler);
      end case;
   end Select_Clock_Source;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock
   --    (This : aliased Digital_To_Analog_Converter)
   --  is
   --  begin
   --     if This'Address = DAC1_Base then
   --        RCC_Periph.APB1ENR.DAC1EN := True;
   --     elsif This'Address = DAC2_Base then
   --        RCC_Periph.APB1ENR.DAC2EN := True;
   --     end if;
   --  end Enable_Clock;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : aliased Digital_To_Analog_Converter)
   --  is
   --  begin
   --     if This'Address = DAC1_Base then
   --        RCC_Periph.APB1RSTR.DAC1RST := True;
   --        RCC_Periph.APB1RSTR.DAC1RST := False;
   --     elsif This'Address = DAC2_Base then
   --        RCC_Periph.APB1RSTR.DAC2RST := True;
   --        RCC_Periph.APB1RSTR.DAC2RST := False;
   --     end if;
   --  end Reset;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : CRC_32) is
   --     pragma Unreferenced (This);
   --  begin
   --     RCC_Periph.AHBENR.CRCEN := True;
   --  end Enable_Clock;

   -------------------
   -- Disable_Clock --
   -------------------

   --  procedure Disable_Clock (This : CRC_32) is
   --     pragma Unreferenced (This);
   --  begin
   --     RCC_Periph.AHBENR.CRCEN := False;
   --  end Disable_Clock;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : CRC_32) is
   --     pragma Unreferenced (This);
   --  begin
   --     CRC_Periph.CR.RESET := True;
   --  end Reset;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : aliased DMA_Controller) is
   --  begin
   --     if This'Address = STM32_SVD.DMA_Base then
   --        RCC_Periph.AHBENR.DMA1EN := True;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Enable_Clock;

   -----------
   -- Reset --
   -----------

   --  This processor doesn't have DMA reset. When a DMA transfer error occurs
   --  during a DMA read or write access, the faulty channel x is automatically
   --  disabled through a hardware clear of its EN bit in the corresponding
   --  DMA_CCRx register. See RM0364 rev 4 pg 181 chapter 11.4.6.

   --  procedure Reset (This : aliased DMA_Controller) is
   --  begin
   --     if This'Address = STM32_SVD.DMA_Base then
   --        RCC_Periph.AHBENR.DMA1EN := False;
   --        RCC_Periph.AHBENR.DMA1EN := True;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Reset;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : aliased USART) is
   --  begin
   --     if This.Periph.all'Address = USART1_Base then
   --        RCC_Periph.APB2ENR.USART1EN := True;
   --     elsif This.Periph.all'Address = USART2_Base then
   --        RCC_Periph.APB1ENR.USART2EN := True;
   --     elsif This.Periph.all'Address = USART3_Base then
   --        RCC_Periph.APB1ENR.USART3EN := True;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Enable_Clock;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : aliased USART) is
   --  begin
   --     if This.Periph.all'Address = USART1_Base then
   --        RCC_Periph.APB2RSTR.USART1RST := True;
   --        RCC_Periph.APB2RSTR.USART1RST := False;
   --     elsif This.Periph.all'Address = USART2_Base then
   --        RCC_Periph.APB1RSTR.USART2RST := True;
   --        RCC_Periph.APB1RSTR.USART2RST := False;
   --     elsif This.Periph.all'Address = USART3_Base then
   --        RCC_Periph.APB1RSTR.USART3RST := True;
   --        RCC_Periph.APB1RSTR.USART3RST := False;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Reset;

   -------------------------
   -- Select_Clock_Source --
   -------------------------

   --  procedure Select_Clock_Source (This   : USART;
   --                                 Source : USART_Clock_Source)
   --  is
   --  begin
   --     if This'Address = USART1_Base then
   --        RCC_Periph.CFGR3.USART1SW := Source'Enum_Rep;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Select_Clock_Source;

   -----------------------
   -- Read_Clock_Source --
   -----------------------

   --  function Read_Clock_Source
   --    (This : USART) return USART_Clock_Source
   --  is
   --  begin
   --     if This'Address = USART1_Base then
   --        return USART_Clock_Source'Val (RCC_Periph.CFGR3.USART1SW);
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Read_Clock_Source;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : aliased in out CAN_Controller)
   --  is
   --  begin
   --     if This'Address = CAN_Base then
   --        RCC_Periph.APB1ENR.CANEN := True;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Enable_Clock;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : aliased in out CAN_Controller) is
   --  begin
   --     if This'Address = STM32_SVD.CAN_Base then
   --        RCC_Periph.APB1RSTR.CANRST := True;
   --        RCC_Periph.APB1RSTR.CANRST := False;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Reset;

   ----------------
   -- As_Port_Id --
   ----------------

   --  function As_Port_Id (Port : I2C_Port'Class) return I2C_Port_Id is
   --  begin
   --     if Port.Periph.all'Address = I2C_Base then
   --        return I2C_Id_1;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end As_Port_Id;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : aliased I2C_Port'Class) is
   --  begin
   --     Enable_Clock (As_Port_Id (This));
   --  end Enable_Clock;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : I2C_Port_Id) is
   --  begin
   --     case This is
   --        when I2C_Id_1 =>
   --           RCC_Periph.APB1ENR.I2C1EN := True;
   --     end case;
   --  end Enable_Clock;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : I2C_Port'Class) is
   --  begin
   --     Reset (As_Port_Id (This));
   --  end Reset;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : I2C_Port_Id) is
   --  begin
   --     case This is
   --        when I2C_Id_1 =>
   --           RCC_Periph.APB1RSTR.I2C1RST := True;
   --           RCC_Periph.APB1RSTR.I2C1RST := False;
   --     end case;
   --  end Reset;

   -------------------------
   -- Select_Clock_Source --
   -------------------------

   --  procedure Select_Clock_Source (This   : I2C_Port'Class;
   --                                 Source : I2C_Clock_Source)
   --  is
   --  begin
   --     case This is
   --        when I2C_Id_1 =>
   --           RCC_Periph.CFGR3.I2C1SW := Source = SYSCLK;
   --     end case;
   --  end Select_Clock_Source;

   -------------------------
   -- Select_Clock_Source --
   -------------------------

   --  procedure Select_Clock_Source (This   : I2C_Port_Id;
   --                                 Source : I2C_Clock_Source)
   --  is
   --  begin
   --     RCC_Periph.CFGR3.I2C1SW := Source = SYSCLK;
   --  end Select_Clock_Source;

   -----------------------
   -- Read_Clock_Source --
   -----------------------

   --  function Read_Clock_Source (This : I2C_Port'Class) return I2C_Clock_Source
   --  is
   --  begin
   --     case This is
   --        when I2C_Id_1 =>
   --           if RCC_Periph.CFGR3.I2C1SW then
   --              return SYSCLK;
   --           else
   --              return HSI;
   --           end if;
   --     end case;
   --  end Read_Clock_Source;

   ------------------------
   -- Read_Clock_Source --
   ------------------------

   --  function Read_Clock_Source (This : I2C_Port_Id) return I2C_Clock_Source
   --  is
   --  begin
   --     return I2C_Clock_Source'Val (RCC_Periph.CFGR3.I2C1SW);
   --  end Read_Clock_Source;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : SPI_Port'Class) is
   --  begin
   --     if This.Periph.all'Address = SPI_Base then
   --        RCC_Periph.APB2ENR.SPI1EN := True;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Enable_Clock;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : SPI_Port'Class) is
   --  begin
   --     if This.Periph.all'Address = SPI_Base then
   --        RCC_Periph.APB2RSTR.SPI1RST := True;
   --        RCC_Periph.APB2RSTR.SPI1RST := False;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Reset;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : RTC_Device) is
   --     pragma Unreferenced (This);
   --  begin
   --     RCC_Periph.BDCR.RTCEN := True;
   --  end Enable_Clock;

   -------------------------
   -- Select_Clock_Source --
   -------------------------

   --  procedure Select_Clock_Source
   --    (This       : RTC_Device;
   --     Source     : RTC_Clock_Source)
   --  is
   --     pragma Unreferenced (This);
   --  begin
   --     RCC_Periph.BDCR.RTCSEL := Source'Enum_Rep;
   --  end Select_Clock_Source;

   ------------------------
   -- Read_Clock_Source --
   ------------------------

   --  function Read_Clock_Source (This : RTC_Device) return RTC_Clock_Source
   --  is
   --     pragma Unreferenced (This);
   --  begin
   --     return RTC_Clock_Source'Val (RCC_Periph.BDCR.RTCSEL);
   --  end Read_Clock_Source;

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (This : Timer) is
   begin
      if This'Address = TIM1_Base then
         RCC_Periph.APB2ENR.TIM1EN := True;
      elsif This'Address = TIM2_Base then
         RCC_Periph.APB1ENR.TIM2EN := True;
      elsif This'Address = TIM3_Base then
         RCC_Periph.APB1ENR.TIM3EN := True;
      elsif This'Address = TIM6_Base then
         RCC_Periph.APB1ENR.TIM6EN := True;
      elsif This'Address = TIM7_Base then
         RCC_Periph.APB1ENR.TIM7EN := True;
      elsif This'Address = TIM15_Base then
         RCC_Periph.APB2ENR.TIM15EN := True;
      elsif This'Address = TIM16_Base then
         RCC_Periph.APB2ENR.TIM16EN := True;
      elsif This'Address = TIM17_Base then
         RCC_Periph.APB2ENR.TIM17EN := True;
      else
         raise Unknown_Device;
      end if;
   end Enable_Clock;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : Timer) is
   begin
      if This'Address = TIM1_Base then
         RCC_Periph.APB2RSTR.TIM1RST := True;
         RCC_Periph.APB2RSTR.TIM1RST := False;
      elsif This'Address = TIM2_Base then
         RCC_Periph.APB1RSTR.TIM2RST := True;
         RCC_Periph.APB1RSTR.TIM2RST := False;
      elsif This'Address = TIM3_Base then
         RCC_Periph.APB1RSTR.TIM3RST := True;
         RCC_Periph.APB1RSTR.TIM3RST := False;
      elsif This'Address = TIM6_Base then
         RCC_Periph.APB1RSTR.TIM6RST := True;
         RCC_Periph.APB1RSTR.TIM6RST := False;
      elsif This'Address = TIM7_Base then
         RCC_Periph.APB1RSTR.TIM7RST := True;
         RCC_Periph.APB1RSTR.TIM7RST := False;
      elsif This'Address = TIM15_Base then
         RCC_Periph.APB2RSTR.TIM15RST := True;
         RCC_Periph.APB2RSTR.TIM15RST := False;
      elsif This'Address = TIM16_Base then
         RCC_Periph.APB2RSTR.TIM16RST := True;
         RCC_Periph.APB2RSTR.TIM16RST := False;
      elsif This'Address = TIM17_Base then
         RCC_Periph.APB2RSTR.TIM17RST := True;
         RCC_Periph.APB2RSTR.TIM17RST := False;
      else
         raise Unknown_Device;
      end if;
   end Reset;

   -------------------------
   -- Select_Clock_Source --
   -------------------------

   procedure Select_Clock_Source (This   : Timer;
                                  Source : Timer_Clock_Source)
   is
   begin
      if This'Address = TIM1_Base then
         RCC_Periph.CFGR3.TIM1SW := Source = PLLCLK;
      else
         raise Unknown_Device;
      end if;
   end Select_Clock_Source;

   -----------------------
   -- Read_Clock_Source --
   -----------------------

   function Read_Clock_Source
     (This : Timer) return Timer_Clock_Source
   is
   begin
      if This'Address = TIM1_Base then
         if RCC_Periph.CFGR3.TIM1SW then
            return PLLCLK;
         else
            return PCLK2;
         end if;
      else
         raise Unknown_Device;
      end if;
   end Read_Clock_Source;

   -------------------------
   -- Get_Clock_Frequency --
   -------------------------

   function Get_Clock_Frequency (This : Timer) return UInt32 is
   begin
      if This'Address = TIM1_Base then
         return System_Clock_Frequencies.TIM1CLK;
      elsif This'Address = TIM2_Base or
        This'Address = TIM3_Base or
        This'Address = TIM6_Base or
        This'Address = TIM7_Base
      then
         return System_Clock_Frequencies.TIMCLK1;
      elsif This'Address = TIM15_Base or
        This'Address = TIM16_Base or
        This'Address = TIM17_Base
      then
         return System_Clock_Frequencies.TIMCLK2;
      else
         raise Unknown_Device;
      end if;
   end Get_Clock_Frequency;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : HRTimer_Master) is
   --  begin
   --     if This'Address = HRTIM_Master_Base then
   --        RCC_Periph.APB2ENR.HRTIM1EN := True;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Enable_Clock;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : HRTimer_Channel) is
   --  begin
   --     if This'Address = HRTIM_TIMA_Base or
   --        This'Address = HRTIM_TIMB_Base or
   --        This'Address = HRTIM_TIMC_Base or
   --        This'Address = HRTIM_TIMD_Base or
   --        This'Address = HRTIM_TIME_Base
   --     then
   --        RCC_Periph.APB2ENR.HRTIM1EN := True;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Enable_Clock;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : HRTimer_Master) is
   --  begin
   --     if This'Address = HRTIM_Master_Base then
   --        RCC_Periph.APB2RSTR.HRTIM1RST := True;
   --        RCC_Periph.APB2RSTR.HRTIM1RST := False;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Reset;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : HRTimer_Channel) is
   --  begin
   --     if This'Address = HRTIM_TIMA_Base or
   --        This'Address = HRTIM_TIMB_Base or
   --        This'Address = HRTIM_TIMC_Base or
   --        This'Address = HRTIM_TIMD_Base or
   --        This'Address = HRTIM_TIME_Base
   --     then
   --        RCC_Periph.APB2RSTR.HRTIM1RST := True;
   --        RCC_Periph.APB2RSTR.HRTIM1RST := False;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Reset;

   -------------------------
   -- Select_Clock_Source --
   -------------------------

   --  procedure Select_Clock_Source (This   : HRTimer_Master;
   --                                 Source : Timer_Clock_Source)
   --  is
   --  begin
   --     if This'Address = HRTIM_Master_Base then
   --        RCC_Periph.CFGR3.HRTIM1SW := Source = PLLCLK;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Select_Clock_Source;

   -----------------------
   -- Read_Clock_Source --
   -----------------------

   --  function Read_Clock_Source
   --    (This : HRTimer_Master) return Timer_Clock_Source
   --  is
   --  begin
   --     if This'Address = TIM1_Base then
   --        if RCC_Periph.CFGR3.HRTIM1SW then
   --           return PLLCLK;
   --        else
   --           return PCLK2;
   --        end if;
   --     else
   --        raise Unknown_Device;
   --     end if;
   --  end Read_Clock_Source;

   -------------------------
   -- Get_Clock_Frequency --
   -------------------------

   --  function Get_Clock_Frequency (This : HRTimer_Master) return UInt32 is
   --     pragma Unreferenced (This);
   --  begin
   --     return System_Clock_Frequencies.TIMCLK2;
   --  end Get_Clock_Frequency;

   -------------------------
   -- Get_Clock_Frequency --
   -------------------------

   --  function Get_Clock_Frequency (This : HRTimer_Channel) return UInt32 is
   --     pragma Unreferenced (This);
   --  begin
   --     return System_Clock_Frequencies.HRTIM1CLK;
   --  end Get_Clock_Frequency;

   ------------------------------
   -- System_Clock_Frequencies --
   ------------------------------

   function System_Clock_Frequencies return RCC_System_Clocks
   is
      Source : constant SYSCLK_Clock_Source :=
        SYSCLK_Clock_Source'Val (RCC_Periph.CFGR.SWS);
      --  Get System Clock Mux
      PLLCLK : UInt32;
      --  PLL output

      Result : RCC_System_Clocks;

   begin
      case Source is
         --  HSI as source
         when SYSCLK_SRC_HSI =>
            Result.SYSCLK := HSI_VALUE;
            Result.I2CCLK := HSI_VALUE;

         --  HSE as source
         when SYSCLK_SRC_HSE =>
            Result.SYSCLK := HSE_VALUE;
            Result.I2CCLK := HSE_VALUE;

         --  PLL as source
         when SYSCLK_SRC_PLL =>
            declare
               Plld   : constant UInt32 := UInt32 (RCC_Periph.CFGR2.PREDIV + 1);
               --  Get the correct value of Pll divisor
               Pllm   : constant UInt32 := UInt32 (RCC_Periph.CFGR.PLLMUL + 2);
               --  Get the correct value of Pll multiplier
               PLLSRC : constant Boolean := RCC_Periph.CFGR.PLLSRC;
               --  Get the PLL entry clock source
            begin
               --  PLL Source Mux
               if PLLSRC then
                  --  HSE/PREDIV selected as PLL input clock
                  PLLCLK := (HSE_VALUE / Plld) * Pllm;
               else
                  --  HSI/2 selected as PLL input clock
                  PLLCLK := (HSI_VALUE / 2) * Pllm;
               end if;

               Result.SYSCLK := PLLCLK;
               Result.I2CCLK := PLLCLK;
            end;
      end case;

      declare
         HPRE  : constant UInt4 := RCC_Periph.CFGR.HPRE;
         PPRE1 : constant UInt3 := RCC_Periph.CFGR.PPRE.Arr (1);
         PPRE2 : constant UInt3 := RCC_Periph.CFGR.PPRE.Arr (2);
      begin
         Result.HCLK  := Result.SYSCLK / HPRE_Presc_Table (HPRE);
         Result.PCLK1 := Result.HCLK / PPRE_Presc_Table (PPRE1);
         Result.PCLK2 := Result.HCLK / PPRE_Presc_Table (PPRE2);

         --  Timer clocks
         --  If the APB prescaler (PPRE1, PPRE2 in the RCC_CFGR register)
         --  is configured to a division factor of 1, TIMxCLK = PCLKx.
         --  Otherwise, the timer clock frequencies are set to twice to the
         --  frequency of the APB domain to which the timers are connected:
         --  TIMxCLK = 2 x PCLKx.

         --  TIMs 2, 3, 6, 7
         if PPRE_Presc_Table (PPRE1) = 1 then
            Result.TIMCLK1 := Result.PCLK1;
         else
            Result.TIMCLK1 := Result.PCLK1 * 2;
         end if;

         --  TIMs 15, 16, 17
         if PPRE_Presc_Table (PPRE2) = 1 then
            Result.TIMCLK2 := Result.PCLK2;
         else
            Result.TIMCLK2 := Result.PCLK2 * 2;
         end if;
      end;

      declare
         Activate_Pll : constant Boolean := RCC_Periph.CR.PLLON;
         TIM1_Pll     : constant Boolean := RCC_Periph.CFGR3.TIM1SW;
         HRTIM1_Pll   : constant Boolean := RCC_Periph.CFGR3.HRTIM1SW;
      begin
         --  TIM1 source Mux
         if Activate_Pll and TIM1_Pll then
            Result.TIM1CLK := PLLCLK * 2;
         else
            Result.TIM1CLK := Result.PCLK2;
         end if;

         --  HRTIM1 source Mux
         if Activate_Pll and HRTIM1_Pll then
            Result.HRTIM1CLK := PLLCLK * 2;
         else
            Result.HRTIM1CLK := Result.PCLK2;
         end if;
      end;

      return Result;
   end System_Clock_Frequencies;

end STM32.Device;
