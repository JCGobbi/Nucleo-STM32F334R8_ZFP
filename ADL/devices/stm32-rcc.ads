------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2015, AdaCore                           --
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
pragma Restrictions (No_Elaboration_Code);

package STM32.RCC is

   procedure BKPSRAM_Clock_Enable with Inline;

   procedure AHB_Force_Reset with Inline;
   procedure AHB_Release_Reset with Inline;
   procedure APB1_Force_Reset with Inline;
   procedure APB1_Release_Reset with Inline;
   procedure APB2_Force_Reset with Inline;
   procedure APB2_Release_Reset with Inline;

   procedure Backup_Domain_Reset;
   --  Disable LSE clock and RTC and reset its configurations.

   ---------------------------------------------------------------------------
   --  Clock Configuration  --------------------------------------------------
   ---------------------------------------------------------------------------

   ---------------
   -- HSE Clock --
   ---------------

   procedure Set_HSE_Clock
     (Enable     : Boolean;
      Bypass     : Boolean := False;
      Enable_CSS : Boolean := False)
     with Post => HSE_Clock_Enabled = Enable;

   function HSE_Clock_Enabled return Boolean;

   ---------------
   -- LSE Clock --
   ---------------

   type HSE_Capability is
     (Lowest_Drive,
      Low_Drive,
      High_Drive,
      Highest_Drive)
     with Size => 2;

   procedure Set_LSE_Clock
     (Enable     : Boolean;
      Bypass     : Boolean := False;
      Capability : HSE_Capability)
     with Post => LSE_Clock_Enabled = Enable;

   function LSE_Clock_Enabled return Boolean;

   ---------------
   -- HSI Clock --
   ---------------

   procedure Set_HSI_Clock (Enable : Boolean)
     with Post => HSI_Clock_Enabled = Enable;
   --  The HSI clock can't be disabled if it is used directly (via SW mux) as
   --  system clock or if the HSI is selected as reference clock for PLL with
   --  PLL enabled (PLLON bit set to ‘1’). It is set by hardware if it is used
   --  directly or indirectly as system clock.

   function HSI_Clock_Enabled return Boolean;

   ---------------
   -- LSI Clock --
   ---------------

   procedure Set_LSI_Clock (Enable : Boolean)
     with Post => LSI_Clock_Enabled = Enable;

   function LSI_Clock_Enabled return Boolean;

   ------------------
   -- System Clock --
   ------------------

   type SYSCLK_Clock_Source is
     (SYSCLK_SRC_HSI,
      SYSCLK_SRC_HSE,
      SYSCLK_SRC_PLL)
     with Size => 2;

   for SYSCLK_Clock_Source use
     (SYSCLK_SRC_HSI => 2#01#,
      SYSCLK_SRC_HSE => 2#10#,
      SYSCLK_SRC_PLL => 2#11#);

   procedure Configure_System_Clock_Mux (Source : SYSCLK_Clock_Source);

   ------------------------
   -- AHB and APB Clocks --
   ------------------------

   type AHB_Prescaler_Enum is
     (DIV2,  DIV4,   DIV8,   DIV16,
      DIV64, DIV128, DIV256, DIV512)
     with Size => 3;

   type AHB_Prescaler is record
      Enable : Boolean := False;
      Value  : AHB_Prescaler_Enum := AHB_Prescaler_Enum'First;
   end record with Size => 4;

   for AHB_Prescaler use record
      Enable at 0 range 3 .. 3;
      Value  at 0 range 0 .. 2;
   end record;

   procedure Configure_AHB_Clock_Prescaler
     (Value : AHB_Prescaler);
   --  The AHB clock bus is the CPU clock selected by the AHB prescaler.
   --  Example to create a variable:
   --  AHB_PRE  : AHB_Prescaler := (Enable => True, Value => DIV2);

   type APB_Prescaler_Enum is
     (DIV2,  DIV4,  DIV8,  DIV16)
     with Size => 2;

   type APB_Prescaler is record
      Enable : Boolean;
      Value  : APB_Prescaler_Enum := APB_Prescaler_Enum'First;
   end record with Size => 3;

   for APB_Prescaler use record
      Enable at 0 range 2 .. 2;
      Value  at 0 range 0 .. 1;
   end record;

   type APB_Clock_Range is (APB_1, APB_2);

   procedure Configure_APB_Clock_Prescaler
     (Bus   : APB_Clock_Range;
      Value : APB_Prescaler);
   --  The APB1 clock bus is the APB1 peripheral clock selected by the APB1
   --  prescaler.
   --  The APB2 clock bus is the APB2 peripheral clock selected by the APB2
   --  prescaler.
   --  Example to create a variable:
   --  APB_PRE  : APB_Prescaler := (Enable => True, Value => DIV2);

   ----------------
   -- PLL Clocks --
   ----------------

   type PLL_Clock_Source is
     (PLL_SRC_HSI,
      PLL_SRC_HSE)
     with Size => 2;

   for PLL_Clock_Source use
     (PLL_SRC_HSI => 2#10#,
      PLL_SRC_HSE => 2#11#);

   procedure Configure_PLL_Source_Mux (Source : PLL_Clock_Source);

   subtype PREDIV_Range is Integer range 1 .. 16;
   subtype PLLMUL_Range is Integer range 2 .. 16;

   procedure Configure_PLL
     (Enable : Boolean;
      PREDIV : PREDIV_Range := PREDIV_Range'First;
      PLLMUL : PLLMUL_Range := PLLMUL_Range'First);
   --  Configure PLL according with RM0364 rev 4 Chapter 8.2.3 section "PLL"
   --  pg 110.

   -------------------
   -- Output Clocks --
   -------------------

   type MCO_Clock_Source is
     (MCOSEL_Disabled,
      MCOSEL_LSI,
      MCOSEL_LSE,
      MCOSEL_SYSCLK,
      MCOSEL_HSI,
      MCOSEL_HSE,
      MCOSEL_PLL)
     with Size => 3;

   for MCO_Clock_Source use
     (MCOSEL_Disabled => 2#000#,
      MCOSEL_LSI      => 2#010#,
      MCOSEL_LSE      => 2#011#,
      MCOSEL_SYSCLK   => 2#100#,
      MCOSEL_HSI      => 2#101#,
      MCOSEL_HSE      => 2#110#,
      MCOSEL_PLL      => 2#111#);

   type MCO_Prescaler is
     (MCOPRE_DIV1,
      MCOPRE_DIV2,
      MCOPRE_DIV3,
      MCOPRE_DIV4,
      MCOPRE_DIV5,
      MCOPRE_DIV6,
      MCOPRE_DIV7,
      MCOPRE_DIV8)
     with Size => 3;

   procedure Configure_MCO_Output_Clock
     (Source : MCO_Clock_Source;
      Value  : MCO_Prescaler;
      Nodiv  : Boolean := False);
   --  Select the source for micro-controller clock output.

   ------------------
   -- Flash Memory --
   ------------------

   --  Flash wait states
   type FLASH_Wait_State is (FWS0, FWS1, FWS2)
     with Size => 3;

   procedure Set_FLASH_Latency (Latency : FLASH_Wait_State);
   --  Constants for Flash Latency
   --  000: Zero wait state, if 0 < HCLK ≤ 24 MHz
   --  001: One wait state, if 24 MHz < HCLK ≤ 48 MHz
   --  010: Two wait sates, if 48 < HCLK ≤ 72 MHz
   --  RM STM32F334 rev 4 chapter 3.5.1 pg. 66

end STM32.RCC;
