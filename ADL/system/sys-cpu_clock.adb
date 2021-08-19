------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--          Copyright (C) 2012-2019, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  This initialization procedure mainly initializes the PLLs and
--  all derived clocks.

with Ada.Unchecked_Conversion;

with STM32_SVD;           use STM32_SVD;
with STM32_SVD.Flash;     use STM32_SVD.Flash;
with STM32_SVD.RCC;       use STM32_SVD.RCC;

package body SYS.CPU_Clock is

   -----------------------
   -- Initialize_Clocks --
   -----------------------

   procedure Initialize_Clocks (HSE_Enabled  : Boolean := True;
                                HSE_Bypass   : Boolean := False;
                                LSI_Enabled  : Boolean := True;
                                Activate_PLL : Boolean := True)
   is
      -------------------------------
      -- Compute Clock Frequencies --
      -------------------------------

      PLLCLKIN : constant Integer :=
        (if HSE_Enabled then 8_000_000 else HSICLK / 2);
      --  PLL input clock value

      PREDIV_Value : constant Integer := HSE_Clock_Frequency / PLLCLKIN;
      --  First HSE clock divider is set to produce a 8Mhz clock

      pragma Assert
        (Activate_PLL and PREDIV_Value not in PREDIV_Range,
         "Invalid PLL PREDIV clock configuration value");

      PLLMUL_Value : constant Integer :=
                      Main_Clock_Frequency / PLLCLKIN;
      --  Compute PLLMUL to generate the required frequency

      pragma Assert
        (Activate_PLL and PLLMUL_Value not in PLLMUL_Range,
         "Invalid PLLMul clock configuration value");

      PLLCLKOUT : constant Integer := PLLMUL_Value * PLLCLKIN;

      PREDIV : constant CFGR2_PREDIV_Field := (if Activate_PLL and HSE_Enabled
                                               then UInt4 (PREDIV_Value - 1)
                                               else 0);
      PLLMUL : constant CFGR_PLLMUL_Field := (if Activate_PLL
                                              then UInt4 (PLLMUL_Value - 2)
                                              else 0);

      SW : constant SYSCLK_Source :=
             (if Activate_PLL then SYSCLK_SRC_PLL
              else (if HSE_Enabled then SYSCLK_SRC_HSE else SYSCLK_SRC_HSI));

      SW_Value : constant CFGR_SW_Field := SYSCLK_Source'Enum_Rep (SW);

      SYSCLK : constant Integer :=
                 (if Activate_PLL then PLLCLKOUT
                  else (if HSE_Enabled then HSE_Clock_Frequency else HSICLK));

      HCLK : constant Integer :=
               (if not AHB_PRE.Enabled then SYSCLK
                else
                   (case AHB_PRE.Value is
                       when DIV2   => SYSCLK / 2,
                       when DIV4   => SYSCLK / 4,
                       when DIV8   => SYSCLK / 8,
                       when DIV16  => SYSCLK / 16,
                       when DIV64  => SYSCLK / 64,
                       when DIV128 => SYSCLK / 128,
                       when DIV256 => SYSCLK / 256,
                       when DIV512 => SYSCLK / 512));
      PCLK1 : constant Integer :=
                (if not APB1_PRE.Enabled then HCLK
                 else
                    (case APB1_PRE.Value is
                        when DIV2  => HCLK / 2,
                        when DIV4  => HCLK / 4,
                        when DIV8  => HCLK / 8,
                        when DIV16 => HCLK / 16));
      PCLK2 : constant Integer :=
                (if not APB2_PRE.Enabled then HCLK
                 else
                    (case APB2_PRE.Value is
                        when DIV2  => HCLK / 2,
                        when DIV4  => HCLK / 4,
                        when DIV8  => HCLK / 8,
                        when DIV16 => HCLK / 16));

      function To_AHB is new Ada.Unchecked_Conversion
        (AHB_Prescaler, UInt4);
      function To_APB is new Ada.Unchecked_Conversion
        (APB_Prescaler, UInt3);

   begin

      --  Check configuration
      pragma Assert
        ((Activate_PLL and PLLCLKOUT not in PLLOUT_Range),
           "Invalid clock configuration");

      pragma Assert
        (SYSCLK /= Main_Clock_Frequency,
           "Cannot generate requested clock");

      --  Cannot be checked at compile time, depends on APB1_PRE and APB2_PRE
      pragma Assert
        (HCLK not in HCLK_Range
           or else PCLK1 not in PCLK1_Range
           or else PCLK2 not in PCLK2_Range,
         "Invalid AHB/APB prescalers configuration");

      --  PWR clock enable
      RCC_Periph.APB1ENR.PWREN := True;

      --  Reset the power interface
      RCC_Periph.APB1RSTR.PWRRST := True;
      RCC_Periph.APB1RSTR.PWRRST := False;

      --  PWR initialization
      PWR_Initialize;

      if not HSE_Enabled then
         --  Setup internal clock and wait for HSI stabilisation.
         RCC_Periph.CR.HSION := True;
         loop
            exit when RCC_Periph.CR.HSIRDY = True;
         end loop;

      else
         --  Configure high-speed external clock, if enabled
         RCC_Periph.CR.HSEBYP := (if HSE_Bypass then True else False);
         --  Enable security for HSERDY
         RCC_Periph.CR.CSSON := True;
         --  Setup high-speed external clock and wait for HSE stabilisation.
         RCC_Periph.CR.HSEON := True;
         loop
            exit when RCC_Periph.CR.HSERDY = True;
         end loop;
      end if;

      if LSI_Enabled then
         --  Setup low-speed internal clock and wait for stabilization.
         RCC_Periph.CSR.LSION := True;
         loop
            exit when RCC_Periph.CSR.LSIRDY = True;
         end loop;
      end if;

      --  Activate PLL if enabled
      if Activate_PLL then
         --  Disable the main PLL before configuring it
         RCC_Periph.CR.PLLON := False;

         --  Configure the PLL clock source, multiplication and division
         --  factors
         RCC_Periph.CFGR2 :=
           (PREDIV => PREDIV,
            others => <>);

         RCC_Periph.CFGR :=
           (PLLMUL => PLLMUL,
            PLLSRC => (if HSE_Enabled then True else False),
            others => <>);

         --  Setup PLL and wait for stabilization.
         RCC_Periph.CR.PLLON := True;
         loop
            exit when RCC_Periph.CR.PLLRDY = True;
         end loop;
      end if;

      --  Configure flash
      --  Must be done before increasing the frequency, otherwise the CPU
      --  won't be able to fetch new instructions.

      if HCLK in FLASH_Latency_0 then
         FLASH_Latency := FLASH_WS'Enum_Rep (FWS0);
      elsif HCLK in FLASH_Latency_1 then
         FLASH_Latency := FLASH_WS'Enum_Rep (FWS1);
      elsif HCLK in FLASH_Latency_2 then
         FLASH_Latency := FLASH_WS'Enum_Rep (FWS2);
      end if;

      Flash_Periph.ACR :=
        (LATENCY => FLASH_Latency,
         PRFTBE  => True, --  Prefetch buffer enabled.
         others  => <>);

      --  Configure derived clocks
      RCC_Periph.CFGR :=
        (SW       => SW_Value,
         HPRE     => To_AHB (AHB_PRE),
         PPRE     => (As_Array => True,
                      Arr      => (1 => To_APB (APB1_PRE),
                                   2 => To_APB (APB2_PRE))),
         --  Microcontroller clock output
         MCO      => MCO_Clock_Selection'Enum_Rep (MCOSEL_HSI),
         MCOPRE   => MCO_Prescaler'Enum_Rep (MCOPRE_DIV1),
         others   => <>);

      --  Test system clock switch status
      case SW is
         when SYSCLK_SRC_PLL =>
            loop
               exit when RCC_Periph.CFGR.SWS =
                 SYSCLK_Source'Enum_Rep (SYSCLK_SRC_PLL);
            end loop;
         when SYSCLK_SRC_HSE =>
            loop
               exit when RCC_Periph.CFGR.SWS =
                 SYSCLK_Source'Enum_Rep (SYSCLK_SRC_HSE);
            end loop;
         when SYSCLK_SRC_HSI =>
            loop
               exit when RCC_Periph.CFGR.SWS =
                 SYSCLK_Source'Enum_Rep (SYSCLK_SRC_HSI);
            end loop;
      end case;

   end Initialize_Clocks;

   ------------------
   -- Reset_Clocks --
   ------------------

   procedure Reset_Clocks is
   begin
      --  Switch on high speed internal clock
      RCC_Periph.CR.HSION := True;

      --  Reset CFGR regiser
      RCC_Periph.CFGR := (others => <>);

      --  Reset HSEON, CSSON and PLLON bits
      RCC_Periph.CR.HSEON := False;
      RCC_Periph.CR.CSSON := False;
      RCC_Periph.CR.PLLON := False;

      --  Reset PLL configuration register
      RCC_Periph.CFGR2 := (PREDIV => 0, others => <>);

      --  Reset HSE bypass bit
      RCC_Periph.CR.HSEBYP := False;

      --  Disable all interrupts
      RCC_Periph.CIR := (others => <>);
   end Reset_Clocks;

   --------------------
   -- PWR_Initialize --
   --------------------

   procedure PWR_Initialize
   is
   begin
      --  Set the PWR voltage threshold and detector
      PWR_Periph.CR.PLS := 4;
      PWR_Periph.CR.PVDE := True;

      --  Disable RTC domain write protection
      PWR_Periph.CR.DBP := True;

      --  Wait until voltage supply scaling has completed
      loop
         exit when PWR_Periph.CSR.PVDO = False;
      end loop;
   end PWR_Initialize;

end SYS.CPU_Clock;
