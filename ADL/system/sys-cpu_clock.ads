with System;
with HAL;           use HAL;

with STM32_SVD.PWR; use STM32_SVD.PWR;

package Sys.CPU_Clock is
   --  This file has definitions and routines from the following files:
   --  setup_pll, s-stm32, s-bbmcpa, s-bbbopa, s-bbpara.
   --  It permits to program the CPU clock to HSI or HSE with and
   --  without the PLL.

   --------------------
   -- Hardware clock --
   --------------------

   --  Constants for RCC CR register
   subtype PREDIV_Range is Integer range 1 .. 16;
   subtype PLLMUL_Range is Integer range 2 .. 16;

   subtype HSECLK_Range is Integer range   1_000_000 ..  32_000_000;
   subtype PLLIN_Range  is Integer range   1_000_000 ..  24_000_000;
   subtype PLLOUT_Range is Integer range   2_000_000 ..  72_000_000;
   subtype SYSCLK_Range is Integer range           1 ..  72_000_000;
   subtype HCLK_Range   is Integer range           1 ..  72_000_000;
   subtype PCLK1_Range  is Integer range           1 ..  36_000_000;
   subtype PCLK2_Range  is Integer range           1 ..  72_000_000;
   subtype SPII2C_Range is Integer range           1 ..  72_000_000;
   pragma Unreferenced (SPII2C_Range);

   Main_Clock_Frequency : constant HCLK_Range := 72_000_000;
   --  With 8 MHz HSE clock + PLL use 72 MHz,
   --  with 8 MHz HSI clock + PLL use 64 MHz,
   --  with 8 MHz HSE clock - PLL use 8 MHz,
   --  with 8 MHz HSI clock - PLL use 8 MHz.

   HSE_Clock_Frequency : constant HSECLK_Range := 8_000_000;
   --  Frequency of High Speed External clock.

   --  These internal low and high speed clocks are fixed (do not modify)
   HSICLK : constant := 8_000_000;
   --  Frequency of High Speed Internal clock.
   LSICLK : constant :=    40_000;
   --  Frequency of Low Speed Internal clock.

   ------------
   -- MCU ID --
   ------------

   type MCU_ID_Register is record
      DEV_ID   : UInt12;
      Reserved : UInt4;
      REV_ID   : UInt16;
   end record with Pack, Size => 32;

   MCU_ID : MCU_ID_Register with Volatile,
     Address => System'To_Address (16#E004_2000#);
   --  Only 32-bits access supported (read-only) RM pg. 1100 chapter 31.6.1

   DEV_ID_STM32F40xxx : constant := 16#413#; --  STM32F40xxx/41xxx
   DEV_ID_STM32F42xxx : constant := 16#419#; --  STM32F42xxx/43xxx
   DEV_ID_STM32F46xxx : constant := 16#434#; --  STM32F469xx/479xx
   DEV_ID_STM32F74xxx : constant := 16#449#; --  STM32F74xxx/75xxx
   DEV_ID_STM32F334xx : constant := 16#438#; --  STM32F334xx

   ------------------
   -- Flash Memory --
   ------------------

   --  Constants for Flash Latency
   --  000: Zero wait state, if 0 < HCLK ≤ 24 MHz
   --  001: One wait state, if 24 MHz < HCLK ≤ 48 MHz
   --  010: Two wait sates, if 48 < HCLK ≤ 72 MHz
   --  RM STM32F334 pg. 66 chapter 3.5.1
   subtype FLASH_Latency_0 is Integer range          1 .. 24_000_000;
   subtype FLASH_Latency_1 is Integer range 25_000_000 .. 48_000_000;
   subtype FLASH_Latency_2 is Integer range 49_000_000 .. 72_000_000;

   --  Flash wait states
   type FLASH_WS is (FWS0, FWS1, FWS2)
     with Size => 3;

   FLASH_Latency : UInt3 := FLASH_WS'Enum_Rep (FWS2);

   --------------------
   --  RCC constants --
   --------------------

   type PLL_Source is (PLL_SRC_HSI, PLL_SRC_HSE)
     with size => 1;

   type SYSCLK_Source is
     (SYSCLK_SRC_HSI,
      SYSCLK_SRC_HSE,
      SYSCLK_SRC_PLL)
     with Size => 2;

   type AHB_Prescaler_Enum is
     (DIV2,  DIV4,   DIV8,   DIV16,
      DIV64, DIV128, DIV256, DIV512)
     with Size => 3;

   type AHB_Prescaler is record
      Enabled : Boolean := False;
      Value   : AHB_Prescaler_Enum := AHB_Prescaler_Enum'First;
   end record with Size => 4;

   for AHB_Prescaler use record
      Enabled at 0 range 3 .. 3;
      Value   at 0 range 0 .. 2;
   end record;

   type APB_Prescaler_Enum is
     (DIV2,  DIV4,  DIV8,  DIV16)
     with Size => 2;

   type APB_Prescaler is record
      Enabled : Boolean;
      Value   : APB_Prescaler_Enum;
   end record with Size => 3;

   for APB_Prescaler use record
      Enabled at 0 range 2 .. 2;
      Value   at 0 range 0 .. 1;
   end record;

   AHB_PRE  : constant AHB_Prescaler := (Enabled => False, Value => DIV2);
   APB1_PRE : constant APB_Prescaler := (Enabled => True, Value => DIV2);
   APB2_PRE : constant APB_Prescaler := (Enabled => False, Value => DIV2);

   type I2C_Clock_Selection is
     (I2CSEL_PLL,
      I2CSEL_CKIN)
     with Size => 1;

   type MCO_Clock_Selection is
     (MCOSEL_Disabled,
      MCOSEL_LSI,
      MCOSEL_LSE,
      MCOSEL_SYSCLK,
      MCOSEL_HSI,
      MCOSEL_HSE,
      MCOSEL_PLL)
     with Size => 3;

   for MCO_Clock_Selection use
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

   procedure Initialize_Clocks
     (HSE_Enabled  : Boolean := True;
      HSE_Bypass   : Boolean := False;
      LSI_Enabled  : Boolean := True;
      Activate_PLL : Boolean := True);
   --  HSE_Enabled = True: use high-speed ext. clock,
   --  HSE_Bypass = True: bypass osc. with ext. clock,
   --  LSI_Enabled = True: use low-speed internal clock,
   --  Activate_PLL = True: use PLL with HSI or HSE.

   procedure Reset_Clocks;
   --  Switch on HSI clock, reset clock registers from RCC_Periph,
   --  disable all interrupts.

   --  System.BB.MCU.Parameters
   procedure PWR_Initialize
     with Post => PWR_Periph.CSR.PVDO = False;
   --  Set the PWR voltage threshold and detector and wait until
   --  voltage supply scaling has completed.
   --  When the voltage detector is on, the detector output is off
   --  if the voltage of the CPU is above the voltage threshold.

end Sys.CPU_Clock;
