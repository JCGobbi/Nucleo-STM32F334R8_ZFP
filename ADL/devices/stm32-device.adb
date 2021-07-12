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

with ADL_Config;

with STM32_SVD.RCC; use STM32_SVD.RCC;
with STM32_SVD.CRC; use STM32_SVD.CRC;

package body STM32.Device is

   HSE_VALUE : constant := ADL_Config.High_Speed_External_Clock;
   --  External oscillator in Hz

   HSI_VALUE : constant := 8_000_000;
   --  Internal oscillator in Hz

   HPRE_Presc_Table : constant array (UInt4) of UInt32 :=
     (1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 8, 16, 64, 128, 256, 512);

   PPRE_Presc_Table : constant array (UInt3) of UInt32 :=
     (1, 1, 1, 1, 2, 4, 8, 16);

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (This : aliased in out GPIO_Port) is
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

   procedure Reset (This : aliased in out GPIO_Port) is
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

   procedure Enable_Clock (This : aliased in out Analog_To_Digital_Converter)
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

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock
   --    (This : aliased in out Digital_To_Analog_Converter)
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

   --  procedure Reset (This : aliased in out Digital_To_Analog_Converter)
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

   --  procedure Enable_Clock (This : in out CRC_32) is
   --     pragma Unreferenced (This);
   --  begin
   --     RCC_Periph.AHBENR.CRCEN := True;
   --  end Enable_Clock;

   -------------------
   -- Disable_Clock --
   -------------------

   --  procedure Disable_Clock (This : in out CRC_32) is
   --     pragma Unreferenced (This);
   --  begin
   --     RCC_Periph.AHBENR.CRCEN := False;
   --  end Disable_Clock;

   -----------
   -- Reset --
   -----------

   --  procedure Reset (This : in out CRC_32) is
   --  begin
   --     This.CR.RESET := True;
   --  end Reset;

   ------------------
   -- Enable_Clock --
   ------------------

   --  procedure Enable_Clock (This : aliased in out DMA_Controller) is
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

   -- This processor doesn't have DMA reset
   --  procedure Reset (This : aliased in out DMA_Controller) is
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

   --  procedure Enable_Clock (This : aliased in out USART) is
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

   --  procedure Reset (This : aliased in out USART) is
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

   --  procedure Reset (This : in out SPI_Port'Class) is
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

   procedure Enable_Clock (This : in out Timer) is
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

   procedure Reset (This : in out Timer) is
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

   ----------------------
   -- Set_Clock_Source --
   ----------------------

   procedure Set_Clock_Source (This : in out Timer;
                               Source : Timer_Clock_Source)
   is
      Activate_Pll : constant Boolean := RCC_Periph.CR.PLLON;
   begin
      if This'Address = TIM1_Base then
         if Activate_Pll and Source = PLLCLK then
            RCC_Periph.CFGR3.TIM1SW := True;
         else
            RCC_Periph.CFGR3.TIM1SW := False;
         end if;
      else
         raise Unknown_Device;
      end if;
   end Set_Clock_Source;

   ----------------------
   -- Get_Clock_Source --
   ----------------------

   function Get_Clock_Source (This : Timer) return UInt32 is
   begin
      if This'Address = TIM1_Base then
         return System_Clock_Frequencies.TIM1CLK;
      elsif This'Address = TIM15_Base or
        This'Address = TIM16_Base or
        This'Address = TIM17_Base
      then
         return System_Clock_Frequencies.TIMCLK2;
      elsif This'Address = TIM2_Base or
        This'Address = TIM3_Base or
        This'Address = TIM6_Base or
        This'Address = TIM7_Base
      then
         return System_Clock_Frequencies.TIMCLK1;
      else
         raise Unknown_Device;
      end if;
   end Get_Clock_Source;

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (This : in out HRTimer_Master) is
   begin
      if This'Address = HRTIM_Master_Base then
         RCC_Periph.APB2ENR.HRTIM1EN := True;
      else
         raise Unknown_Device;
      end if;
   end Enable_Clock;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : in out HRTimer_Master) is
   begin
      if This'Address = HRTIM_Master_Base then
         RCC_Periph.APB2RSTR.HRTIM1RST := True;
         RCC_Periph.APB2RSTR.HRTIM1RST := False;
      else
         raise Unknown_Device;
      end if;
   end Reset;

   ----------------------
   -- Set_Clock_Source --
   ----------------------

   procedure Set_Clock_Source (This : in out HRTimer_Master;
                               Source : Timer_Clock_Source)
   is
      Activate_Pll : constant Boolean := RCC_Periph.CR.PLLON;
   begin
      if This'Address = HRTIM_Master_Base then
         if Activate_Pll and Source = PLLCLK then
            RCC_Periph.CFGR3.HRTIM1SW := True;
         else
            RCC_Periph.CFGR3.HRTIM1SW := False;
         end if;
      else
         raise Unknown_Device;
      end if;
   end Set_Clock_Source;

   ----------------------
   -- Get_Clock_Source --
   ----------------------

   function Get_Clock_Source (This : HRTimer_X) return UInt32 is
      pragma Unreferenced (This);
   begin
      return System_Clock_Frequencies.HRTIM1CLK;
   end Get_Clock_Source;

   ------------------------------
   -- System_Clock_Frequencies --
   ------------------------------

   function System_Clock_Frequencies return RCC_System_Clocks
   is
      Source : constant SYSCLK_Source :=
        SYSCLK_Source'Val (RCC_Periph.CFGR.SWS);

      --  Get the correct value of Pll divisor
      Plld   : constant UInt32 := UInt32 (RCC_Periph.CFGR2.PREDIV + 1);
      --  Get the correct value of Pll multiplier
      Pllm   : constant UInt32 := UInt32 (RCC_Periph.CFGR.PLLMUL + 2);

      PLLSRC : constant PLL_Source :=
        PLL_Source'Val (Boolean'Pos (RCC_Periph.CFGR.PLLSRC));

      Result : RCC_System_Clocks;
      PLLCLK : UInt32;

   begin
      --  PLL Source Mux
      case PLLSRC is
         when PLL_SRC_HSE => --  HSE as source
            PLLCLK := HSE_VALUE / Plld * Pllm;

         when PLL_SRC_HSI => --  HSI as source
            PLLCLK := HSI_VALUE / 2 * Pllm;
      end case;

      -- System Clock Mux
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
            Result.SYSCLK := PLLCLK;
            Result.I2CCLK := PLLCLK;
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
         --  TIMxCLK = 2xPCLKx.

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
