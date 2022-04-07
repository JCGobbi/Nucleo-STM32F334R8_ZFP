--
--  Copyright (C) 2022, AdaCore
--

pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F3x4.svd


with System;

package Interfaces.STM32.SYSCFG is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   subtype SYSCFG_CFGR1_MEM_MODE_Field is Interfaces.STM32.UInt2;
   subtype SYSCFG_CFGR1_USB_IT_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_TIM1_ITR_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_DAC_TRIG_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_ADC24_DMA_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_TIM16_DMA_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_TIM17_DMA_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_TIM6_DAC1_DMA_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_TIM7_DAC2_DMA_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_I2C_PB6_FM_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_I2C_PB7_FM_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_I2C_PB8_FM_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_I2C_PB9_FM_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_I2C1_FM_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR1_ENCODER_MODE_Field is Interfaces.STM32.UInt2;
   subtype SYSCFG_CFGR1_FPU_IT_Field is Interfaces.STM32.UInt6;

   --  configuration register 1
   type SYSCFG_CFGR1_Register is record
      --  Memory mapping selection bits
      MEM_MODE          : SYSCFG_CFGR1_MEM_MODE_Field := 16#0#;
      --  unspecified
      Reserved_2_4      : Interfaces.STM32.UInt3 := 16#0#;
      --  USB interrupt remap
      USB_IT_RMP        : SYSCFG_CFGR1_USB_IT_RMP_Field := 16#0#;
      --  Timer 1 ITR3 selection
      TIM1_ITR_RMP      : SYSCFG_CFGR1_TIM1_ITR_RMP_Field := 16#0#;
      --  DAC trigger remap (when TSEL = 001)
      DAC_TRIG_RMP      : SYSCFG_CFGR1_DAC_TRIG_RMP_Field := 16#0#;
      --  ADC24 DMA remapping bit
      ADC24_DMA_RMP     : SYSCFG_CFGR1_ADC24_DMA_RMP_Field := 16#0#;
      --  unspecified
      Reserved_9_10     : Interfaces.STM32.UInt2 := 16#0#;
      --  TIM16 DMA request remapping bit
      TIM16_DMA_RMP     : SYSCFG_CFGR1_TIM16_DMA_RMP_Field := 16#0#;
      --  TIM17 DMA request remapping bit
      TIM17_DMA_RMP     : SYSCFG_CFGR1_TIM17_DMA_RMP_Field := 16#0#;
      --  TIM6 and DAC1 DMA request remapping bit
      TIM6_DAC1_DMA_RMP : SYSCFG_CFGR1_TIM6_DAC1_DMA_RMP_Field := 16#0#;
      --  TIM7 and DAC2 DMA request remapping bit
      TIM7_DAC2_DMA_RMP : SYSCFG_CFGR1_TIM7_DAC2_DMA_RMP_Field := 16#0#;
      --  unspecified
      Reserved_15_15    : Interfaces.STM32.Bit := 16#0#;
      --  Fast Mode Plus (FM+) driving capability activation bits.
      I2C_PB6_FM        : SYSCFG_CFGR1_I2C_PB6_FM_Field := 16#0#;
      --  Fast Mode Plus (FM+) driving capability activation bits.
      I2C_PB7_FM        : SYSCFG_CFGR1_I2C_PB7_FM_Field := 16#0#;
      --  Fast Mode Plus (FM+) driving capability activation bits.
      I2C_PB8_FM        : SYSCFG_CFGR1_I2C_PB8_FM_Field := 16#0#;
      --  Fast Mode Plus (FM+) driving capability activation bits.
      I2C_PB9_FM        : SYSCFG_CFGR1_I2C_PB9_FM_Field := 16#0#;
      --  I2C1 Fast Mode Plus
      I2C1_FM           : SYSCFG_CFGR1_I2C1_FM_Field := 16#0#;
      --  unspecified
      Reserved_21_21    : Interfaces.STM32.Bit := 16#0#;
      --  Encoder mode
      ENCODER_MODE      : SYSCFG_CFGR1_ENCODER_MODE_Field := 16#0#;
      --  unspecified
      Reserved_24_25    : Interfaces.STM32.UInt2 := 16#0#;
      --  Interrupt enable bits from FPU
      FPU_IT            : SYSCFG_CFGR1_FPU_IT_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCFG_CFGR1_Register use record
      MEM_MODE          at 0 range 0 .. 1;
      Reserved_2_4      at 0 range 2 .. 4;
      USB_IT_RMP        at 0 range 5 .. 5;
      TIM1_ITR_RMP      at 0 range 6 .. 6;
      DAC_TRIG_RMP      at 0 range 7 .. 7;
      ADC24_DMA_RMP     at 0 range 8 .. 8;
      Reserved_9_10     at 0 range 9 .. 10;
      TIM16_DMA_RMP     at 0 range 11 .. 11;
      TIM17_DMA_RMP     at 0 range 12 .. 12;
      TIM6_DAC1_DMA_RMP at 0 range 13 .. 13;
      TIM7_DAC2_DMA_RMP at 0 range 14 .. 14;
      Reserved_15_15    at 0 range 15 .. 15;
      I2C_PB6_FM        at 0 range 16 .. 16;
      I2C_PB7_FM        at 0 range 17 .. 17;
      I2C_PB8_FM        at 0 range 18 .. 18;
      I2C_PB9_FM        at 0 range 19 .. 19;
      I2C1_FM           at 0 range 20 .. 20;
      Reserved_21_21    at 0 range 21 .. 21;
      ENCODER_MODE      at 0 range 22 .. 23;
      Reserved_24_25    at 0 range 24 .. 25;
      FPU_IT            at 0 range 26 .. 31;
   end record;

   subtype SYSCFG_RCR_PAGE0_WP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_RCR_PAGE1_WP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_RCR_PAGE2_WP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_RCR_PAGE3_WP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_RCR_PAGE4_WP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_RCR_PAGE5_WP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_RCR_PAGE6_WP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_RCR_PAGE7_WP_Field is Interfaces.STM32.Bit;

   --  CCM SRAM protection register
   type SYSCFG_RCR_Register is record
      --  CCM SRAM page write protection bit
      PAGE0_WP      : SYSCFG_RCR_PAGE0_WP_Field := 16#0#;
      --  CCM SRAM page write protection bit
      PAGE1_WP      : SYSCFG_RCR_PAGE1_WP_Field := 16#0#;
      --  CCM SRAM page write protection bit
      PAGE2_WP      : SYSCFG_RCR_PAGE2_WP_Field := 16#0#;
      --  CCM SRAM page write protection bit
      PAGE3_WP      : SYSCFG_RCR_PAGE3_WP_Field := 16#0#;
      --  CCM SRAM page write protection bit
      PAGE4_WP      : SYSCFG_RCR_PAGE4_WP_Field := 16#0#;
      --  CCM SRAM page write protection bit
      PAGE5_WP      : SYSCFG_RCR_PAGE5_WP_Field := 16#0#;
      --  CCM SRAM page write protection bit
      PAGE6_WP      : SYSCFG_RCR_PAGE6_WP_Field := 16#0#;
      --  CCM SRAM page write protection bit
      PAGE7_WP      : SYSCFG_RCR_PAGE7_WP_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : Interfaces.STM32.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCFG_RCR_Register use record
      PAGE0_WP      at 0 range 0 .. 0;
      PAGE1_WP      at 0 range 1 .. 1;
      PAGE2_WP      at 0 range 2 .. 2;
      PAGE3_WP      at 0 range 3 .. 3;
      PAGE4_WP      at 0 range 4 .. 4;
      PAGE5_WP      at 0 range 5 .. 5;
      PAGE6_WP      at 0 range 6 .. 6;
      PAGE7_WP      at 0 range 7 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  SYSCFG_EXTICR1_EXTI array element
   subtype SYSCFG_EXTICR1_EXTI_Element is Interfaces.STM32.UInt4;

   --  SYSCFG_EXTICR1_EXTI array
   type SYSCFG_EXTICR1_EXTI_Field_Array is array (0 .. 3)
     of SYSCFG_EXTICR1_EXTI_Element
     with Component_Size => 4, Size => 16;

   --  Type definition for SYSCFG_EXTICR1_EXTI
   type SYSCFG_EXTICR1_EXTI_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  EXTI as a value
            Val : Interfaces.STM32.UInt16;
         when True =>
            --  EXTI as an array
            Arr : SYSCFG_EXTICR1_EXTI_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for SYSCFG_EXTICR1_EXTI_Field use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  external interrupt configuration register 1
   type SYSCFG_EXTICR1_Register is record
      --  EXTI 0 configuration bits
      EXTI           : SYSCFG_EXTICR1_EXTI_Field :=
                        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCFG_EXTICR1_Register use record
      EXTI           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  SYSCFG_EXTICR2_EXTI array element
   subtype SYSCFG_EXTICR2_EXTI_Element is Interfaces.STM32.UInt4;

   --  SYSCFG_EXTICR2_EXTI array
   type SYSCFG_EXTICR2_EXTI_Field_Array is array (4 .. 7)
     of SYSCFG_EXTICR2_EXTI_Element
     with Component_Size => 4, Size => 16;

   --  Type definition for SYSCFG_EXTICR2_EXTI
   type SYSCFG_EXTICR2_EXTI_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  EXTI as a value
            Val : Interfaces.STM32.UInt16;
         when True =>
            --  EXTI as an array
            Arr : SYSCFG_EXTICR2_EXTI_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for SYSCFG_EXTICR2_EXTI_Field use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  external interrupt configuration register 2
   type SYSCFG_EXTICR2_Register is record
      --  EXTI 4 configuration bits
      EXTI           : SYSCFG_EXTICR2_EXTI_Field :=
                        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCFG_EXTICR2_Register use record
      EXTI           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  SYSCFG_EXTICR3_EXTI array element
   subtype SYSCFG_EXTICR3_EXTI_Element is Interfaces.STM32.UInt4;

   --  SYSCFG_EXTICR3_EXTI array
   type SYSCFG_EXTICR3_EXTI_Field_Array is array (8 .. 11)
     of SYSCFG_EXTICR3_EXTI_Element
     with Component_Size => 4, Size => 16;

   --  Type definition for SYSCFG_EXTICR3_EXTI
   type SYSCFG_EXTICR3_EXTI_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  EXTI as a value
            Val : Interfaces.STM32.UInt16;
         when True =>
            --  EXTI as an array
            Arr : SYSCFG_EXTICR3_EXTI_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for SYSCFG_EXTICR3_EXTI_Field use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  external interrupt configuration register 3
   type SYSCFG_EXTICR3_Register is record
      --  EXTI 8 configuration bits
      EXTI           : SYSCFG_EXTICR3_EXTI_Field :=
                        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCFG_EXTICR3_Register use record
      EXTI           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   --  SYSCFG_EXTICR4_EXTI array element
   subtype SYSCFG_EXTICR4_EXTI_Element is Interfaces.STM32.UInt4;

   --  SYSCFG_EXTICR4_EXTI array
   type SYSCFG_EXTICR4_EXTI_Field_Array is array (12 .. 15)
     of SYSCFG_EXTICR4_EXTI_Element
     with Component_Size => 4, Size => 16;

   --  Type definition for SYSCFG_EXTICR4_EXTI
   type SYSCFG_EXTICR4_EXTI_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  EXTI as a value
            Val : Interfaces.STM32.UInt16;
         when True =>
            --  EXTI as an array
            Arr : SYSCFG_EXTICR4_EXTI_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 16;

   for SYSCFG_EXTICR4_EXTI_Field use record
      Val at 0 range 0 .. 15;
      Arr at 0 range 0 .. 15;
   end record;

   --  external interrupt configuration register 4
   type SYSCFG_EXTICR4_Register is record
      --  EXTI 12 configuration bits
      EXTI           : SYSCFG_EXTICR4_EXTI_Field :=
                        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCFG_EXTICR4_Register use record
      EXTI           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype SYSCFG_CFGR2_LOCUP_LOCK_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR2_SRAM_PARITY_LOCK_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR2_PVD_LOCK_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR2_BYP_ADD_PAR_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR2_SRAM_PEF_Field is Interfaces.STM32.Bit;

   --  configuration register 2
   type SYSCFG_CFGR2_Register is record
      --  Cortex-M0 LOCKUP bit enable bit
      LOCUP_LOCK       : SYSCFG_CFGR2_LOCUP_LOCK_Field := 16#0#;
      --  SRAM parity lock bit
      SRAM_PARITY_LOCK : SYSCFG_CFGR2_SRAM_PARITY_LOCK_Field := 16#0#;
      --  PVD lock enable bit
      PVD_LOCK         : SYSCFG_CFGR2_PVD_LOCK_Field := 16#0#;
      --  unspecified
      Reserved_3_3     : Interfaces.STM32.Bit := 16#0#;
      --  Bypass address bit 29 in parity calculation
      BYP_ADD_PAR      : SYSCFG_CFGR2_BYP_ADD_PAR_Field := 16#0#;
      --  unspecified
      Reserved_5_7     : Interfaces.STM32.UInt3 := 16#0#;
      --  SRAM parity flag
      SRAM_PEF         : SYSCFG_CFGR2_SRAM_PEF_Field := 16#0#;
      --  unspecified
      Reserved_9_31    : Interfaces.STM32.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCFG_CFGR2_Register use record
      LOCUP_LOCK       at 0 range 0 .. 0;
      SRAM_PARITY_LOCK at 0 range 1 .. 1;
      PVD_LOCK         at 0 range 2 .. 2;
      Reserved_3_3     at 0 range 3 .. 3;
      BYP_ADD_PAR      at 0 range 4 .. 4;
      Reserved_5_7     at 0 range 5 .. 7;
      SRAM_PEF         at 0 range 8 .. 8;
      Reserved_9_31    at 0 range 9 .. 31;
   end record;

   subtype COMP2_CSR_COMP2EN_Field is Interfaces.STM32.Bit;
   subtype COMP2_CSR_COMP2INMSEL_Field is Interfaces.STM32.UInt3;
   subtype COMP2_CSR_COMP2OUTSEL_Field is Interfaces.STM32.UInt4;
   subtype COMP2_CSR_COMP2POL_Field is Interfaces.STM32.Bit;
   subtype COMP2_CSR_COMP2_BLANKING_Field is Interfaces.STM32.UInt3;
   subtype COMP2_CSR_COMP2INMSEL_3_Field is Interfaces.STM32.Bit;
   subtype COMP2_CSR_COMP2OUT_Field is Interfaces.STM32.Bit;
   subtype COMP2_CSR_COMP2LOCK_Field is Interfaces.STM32.Bit;

   --  control and status register
   type COMP2_CSR_Register is record
      --  Comparator 2 enable
      COMP2EN        : COMP2_CSR_COMP2EN_Field := 16#0#;
      --  unspecified
      Reserved_1_3   : Interfaces.STM32.UInt3 := 16#0#;
      --  Comparator 2 inverting input selection
      COMP2INMSEL    : COMP2_CSR_COMP2INMSEL_Field := 16#0#;
      --  unspecified
      Reserved_7_9   : Interfaces.STM32.UInt3 := 16#0#;
      --  Comparator 2 output selection
      COMP2OUTSEL    : COMP2_CSR_COMP2OUTSEL_Field := 16#0#;
      --  unspecified
      Reserved_14_14 : Interfaces.STM32.Bit := 16#0#;
      --  Comparator 2 output polarity
      COMP2POL       : COMP2_CSR_COMP2POL_Field := 16#0#;
      --  unspecified
      Reserved_16_17 : Interfaces.STM32.UInt2 := 16#0#;
      --  Comparator 2 blanking source
      COMP2_BLANKING : COMP2_CSR_COMP2_BLANKING_Field := 16#0#;
      --  unspecified
      Reserved_21_21 : Interfaces.STM32.Bit := 16#0#;
      --  Comparator 1 inverting input selection
      COMP2INMSEL_3  : COMP2_CSR_COMP2INMSEL_3_Field := 16#0#;
      --  unspecified
      Reserved_23_29 : Interfaces.STM32.UInt7 := 16#0#;
      --  Read-only. Comparator 2 output
      COMP2OUT       : COMP2_CSR_COMP2OUT_Field := 16#0#;
      --  Comparator 2 lock
      COMP2LOCK      : COMP2_CSR_COMP2LOCK_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMP2_CSR_Register use record
      COMP2EN        at 0 range 0 .. 0;
      Reserved_1_3   at 0 range 1 .. 3;
      COMP2INMSEL    at 0 range 4 .. 6;
      Reserved_7_9   at 0 range 7 .. 9;
      COMP2OUTSEL    at 0 range 10 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      COMP2POL       at 0 range 15 .. 15;
      Reserved_16_17 at 0 range 16 .. 17;
      COMP2_BLANKING at 0 range 18 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      COMP2INMSEL_3  at 0 range 22 .. 22;
      Reserved_23_29 at 0 range 23 .. 29;
      COMP2OUT       at 0 range 30 .. 30;
      COMP2LOCK      at 0 range 31 .. 31;
   end record;

   subtype COMP4_CSR_COMP4EN_Field is Interfaces.STM32.Bit;
   subtype COMP4_CSR_COMP4INMSEL_Field is Interfaces.STM32.UInt3;
   subtype COMP4_CSR_COMP4OUTSEL_Field is Interfaces.STM32.UInt4;
   subtype COMP4_CSR_COMP4POL_Field is Interfaces.STM32.Bit;
   subtype COMP4_CSR_COMP4_BLANKING_Field is Interfaces.STM32.UInt3;
   subtype COMP4_CSR_COMP4INMSEL_3_Field is Interfaces.STM32.Bit;
   subtype COMP4_CSR_COMP4OUT_Field is Interfaces.STM32.Bit;
   subtype COMP4_CSR_COMP4LOCK_Field is Interfaces.STM32.Bit;

   --  control and status register
   type COMP4_CSR_Register is record
      --  Comparator 4 enable
      COMP4EN        : COMP4_CSR_COMP4EN_Field := 16#0#;
      --  unspecified
      Reserved_1_3   : Interfaces.STM32.UInt3 := 16#0#;
      --  Comparator 4 inverting input selection
      COMP4INMSEL    : COMP4_CSR_COMP4INMSEL_Field := 16#0#;
      --  unspecified
      Reserved_7_9   : Interfaces.STM32.UInt3 := 16#0#;
      --  Comparator 4 output selection
      COMP4OUTSEL    : COMP4_CSR_COMP4OUTSEL_Field := 16#0#;
      --  unspecified
      Reserved_14_14 : Interfaces.STM32.Bit := 16#0#;
      --  Comparator 4 output polarity
      COMP4POL       : COMP4_CSR_COMP4POL_Field := 16#0#;
      --  unspecified
      Reserved_16_17 : Interfaces.STM32.UInt2 := 16#0#;
      --  Comparator 4 blanking source
      COMP4_BLANKING : COMP4_CSR_COMP4_BLANKING_Field := 16#0#;
      --  unspecified
      Reserved_21_21 : Interfaces.STM32.Bit := 16#0#;
      --  Comparator 4 inverting input selection
      COMP4INMSEL_3  : COMP4_CSR_COMP4INMSEL_3_Field := 16#0#;
      --  unspecified
      Reserved_23_29 : Interfaces.STM32.UInt7 := 16#0#;
      --  Read-only. Comparator 4 output
      COMP4OUT       : COMP4_CSR_COMP4OUT_Field := 16#0#;
      --  Comparator 4 lock
      COMP4LOCK      : COMP4_CSR_COMP4LOCK_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMP4_CSR_Register use record
      COMP4EN        at 0 range 0 .. 0;
      Reserved_1_3   at 0 range 1 .. 3;
      COMP4INMSEL    at 0 range 4 .. 6;
      Reserved_7_9   at 0 range 7 .. 9;
      COMP4OUTSEL    at 0 range 10 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      COMP4POL       at 0 range 15 .. 15;
      Reserved_16_17 at 0 range 16 .. 17;
      COMP4_BLANKING at 0 range 18 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      COMP4INMSEL_3  at 0 range 22 .. 22;
      Reserved_23_29 at 0 range 23 .. 29;
      COMP4OUT       at 0 range 30 .. 30;
      COMP4LOCK      at 0 range 31 .. 31;
   end record;

   subtype COMP6_CSR_COMP6EN_Field is Interfaces.STM32.Bit;
   subtype COMP6_CSR_COMP6INMSEL_Field is Interfaces.STM32.UInt3;
   subtype COMP6_CSR_COMP6OUTSEL_Field is Interfaces.STM32.UInt4;
   subtype COMP6_CSR_COMP6POL_Field is Interfaces.STM32.Bit;
   subtype COMP6_CSR_COMP6_BLANKING_Field is Interfaces.STM32.UInt3;
   subtype COMP6_CSR_COMP6INMSEL_3_Field is Interfaces.STM32.Bit;
   subtype COMP6_CSR_COMP6OUT_Field is Interfaces.STM32.Bit;
   subtype COMP6_CSR_COMP6LOCK_Field is Interfaces.STM32.Bit;

   --  control and status register
   type COMP6_CSR_Register is record
      --  Comparator 6 enable
      COMP6EN        : COMP6_CSR_COMP6EN_Field := 16#0#;
      --  unspecified
      Reserved_1_3   : Interfaces.STM32.UInt3 := 16#0#;
      --  Comparator 6 inverting input selection
      COMP6INMSEL    : COMP6_CSR_COMP6INMSEL_Field := 16#0#;
      --  unspecified
      Reserved_7_9   : Interfaces.STM32.UInt3 := 16#0#;
      --  Comparator 6 output selection
      COMP6OUTSEL    : COMP6_CSR_COMP6OUTSEL_Field := 16#0#;
      --  unspecified
      Reserved_14_14 : Interfaces.STM32.Bit := 16#0#;
      --  Comparator 6 output polarity
      COMP6POL       : COMP6_CSR_COMP6POL_Field := 16#0#;
      --  unspecified
      Reserved_16_17 : Interfaces.STM32.UInt2 := 16#0#;
      --  Comparator 6 blanking source
      COMP6_BLANKING : COMP6_CSR_COMP6_BLANKING_Field := 16#0#;
      --  unspecified
      Reserved_21_21 : Interfaces.STM32.Bit := 16#0#;
      --  Comparator 6 inverting input selection
      COMP6INMSEL_3  : COMP6_CSR_COMP6INMSEL_3_Field := 16#0#;
      --  unspecified
      Reserved_23_29 : Interfaces.STM32.UInt7 := 16#0#;
      --  Read-only. Comparator 6 output
      COMP6OUT       : COMP6_CSR_COMP6OUT_Field := 16#0#;
      --  Comparator 6 lock
      COMP6LOCK      : COMP6_CSR_COMP6LOCK_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for COMP6_CSR_Register use record
      COMP6EN        at 0 range 0 .. 0;
      Reserved_1_3   at 0 range 1 .. 3;
      COMP6INMSEL    at 0 range 4 .. 6;
      Reserved_7_9   at 0 range 7 .. 9;
      COMP6OUTSEL    at 0 range 10 .. 13;
      Reserved_14_14 at 0 range 14 .. 14;
      COMP6POL       at 0 range 15 .. 15;
      Reserved_16_17 at 0 range 16 .. 17;
      COMP6_BLANKING at 0 range 18 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      COMP6INMSEL_3  at 0 range 22 .. 22;
      Reserved_23_29 at 0 range 23 .. 29;
      COMP6OUT       at 0 range 30 .. 30;
      COMP6LOCK      at 0 range 31 .. 31;
   end record;

   subtype OPAMP2_CSR_OPAMP2EN_Field is Interfaces.STM32.Bit;
   subtype OPAMP2_CSR_FORCE_VP_Field is Interfaces.STM32.Bit;
   subtype OPAMP2_CSR_VP_SEL_Field is Interfaces.STM32.UInt2;
   subtype OPAMP2_CSR_VM_SEL_Field is Interfaces.STM32.UInt2;
   subtype OPAMP2_CSR_TCM_EN_Field is Interfaces.STM32.Bit;
   subtype OPAMP2_CSR_VMS_SEL_Field is Interfaces.STM32.Bit;
   subtype OPAMP2_CSR_VPS_SEL_Field is Interfaces.STM32.UInt2;
   subtype OPAMP2_CSR_CALON_Field is Interfaces.STM32.Bit;
   subtype OPAMP2_CSR_CAL_SEL_Field is Interfaces.STM32.UInt2;
   subtype OPAMP2_CSR_PGA_GAIN_Field is Interfaces.STM32.UInt4;
   subtype OPAMP2_CSR_USER_TRIM_Field is Interfaces.STM32.Bit;
   subtype OPAMP2_CSR_TRIMOFFSETP_Field is Interfaces.STM32.UInt5;
   subtype OPAMP2_CSR_TRIMOFFSETN_Field is Interfaces.STM32.UInt5;
   subtype OPAMP2_CSR_TSTREF_Field is Interfaces.STM32.Bit;
   subtype OPAMP2_CSR_OUTCAL_Field is Interfaces.STM32.Bit;
   subtype OPAMP2_CSR_LOCK_Field is Interfaces.STM32.Bit;

   --  OPAMP2 control register
   type OPAMP2_CSR_Register is record
      --  OPAMP2 enable
      OPAMP2EN     : OPAMP2_CSR_OPAMP2EN_Field := 16#0#;
      --  FORCE_VP
      FORCE_VP     : OPAMP2_CSR_FORCE_VP_Field := 16#0#;
      --  OPAMP2 Non inverting input selection
      VP_SEL       : OPAMP2_CSR_VP_SEL_Field := 16#0#;
      --  unspecified
      Reserved_4_4 : Interfaces.STM32.Bit := 16#0#;
      --  OPAMP2 inverting input selection
      VM_SEL       : OPAMP2_CSR_VM_SEL_Field := 16#0#;
      --  Timer controlled Mux mode enable
      TCM_EN       : OPAMP2_CSR_TCM_EN_Field := 16#0#;
      --  OPAMP2 inverting input secondary selection
      VMS_SEL      : OPAMP2_CSR_VMS_SEL_Field := 16#0#;
      --  OPAMP2 Non inverting input secondary selection
      VPS_SEL      : OPAMP2_CSR_VPS_SEL_Field := 16#0#;
      --  Calibration mode enable
      CALON        : OPAMP2_CSR_CALON_Field := 16#0#;
      --  Calibration selection
      CAL_SEL      : OPAMP2_CSR_CAL_SEL_Field := 16#0#;
      --  Gain in PGA mode
      PGA_GAIN     : OPAMP2_CSR_PGA_GAIN_Field := 16#0#;
      --  User trimming enable
      USER_TRIM    : OPAMP2_CSR_USER_TRIM_Field := 16#0#;
      --  Offset trimming value (PMOS)
      TRIMOFFSETP  : OPAMP2_CSR_TRIMOFFSETP_Field := 16#0#;
      --  Offset trimming value (NMOS)
      TRIMOFFSETN  : OPAMP2_CSR_TRIMOFFSETN_Field := 16#0#;
      --  TSTREF
      TSTREF       : OPAMP2_CSR_TSTREF_Field := 16#0#;
      --  Read-only. OPAMP 2 ouput status flag
      OUTCAL       : OPAMP2_CSR_OUTCAL_Field := 16#0#;
      --  OPAMP 2 lock
      LOCK         : OPAMP2_CSR_LOCK_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for OPAMP2_CSR_Register use record
      OPAMP2EN     at 0 range 0 .. 0;
      FORCE_VP     at 0 range 1 .. 1;
      VP_SEL       at 0 range 2 .. 3;
      Reserved_4_4 at 0 range 4 .. 4;
      VM_SEL       at 0 range 5 .. 6;
      TCM_EN       at 0 range 7 .. 7;
      VMS_SEL      at 0 range 8 .. 8;
      VPS_SEL      at 0 range 9 .. 10;
      CALON        at 0 range 11 .. 11;
      CAL_SEL      at 0 range 12 .. 13;
      PGA_GAIN     at 0 range 14 .. 17;
      USER_TRIM    at 0 range 18 .. 18;
      TRIMOFFSETP  at 0 range 19 .. 23;
      TRIMOFFSETN  at 0 range 24 .. 28;
      TSTREF       at 0 range 29 .. 29;
      OUTCAL       at 0 range 30 .. 30;
      LOCK         at 0 range 31 .. 31;
   end record;

   subtype SYSCFG_CFGR3_SPI1_RX_DMA_RMP_Field is Interfaces.STM32.UInt2;
   subtype SYSCFG_CFGR3_SPI1_TX_DMA_RMP_Field is Interfaces.STM32.UInt2;
   subtype SYSCFG_CFGR3_I2C1_RX_DMA_RMP_Field is Interfaces.STM32.UInt2;
   subtype SYSCFG_CFGR3_ADC2_DMA_RMP_0_Field is Interfaces.STM32.UInt2;
   subtype SYSCFG_CFGR3_ADC2_DMA_RMP_1_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR3_DAC1_TRIG3_RMP_Field is Interfaces.STM32.Bit;
   subtype SYSCFG_CFGR3_DAC1_TRIG5_RMP_Field is Interfaces.STM32.Bit;

   --  configuration register 3
   type SYSCFG_CFGR3_Register is record
      --  SPI1_RX DMA remapping bit
      SPI1_RX_DMA_RMP : SYSCFG_CFGR3_SPI1_RX_DMA_RMP_Field := 16#0#;
      --  SPI1_TX DMA remapping bit
      SPI1_TX_DMA_RMP : SYSCFG_CFGR3_SPI1_TX_DMA_RMP_Field := 16#0#;
      --  I2C1_RX DMA remapping bit
      I2C1_RX_DMA_RMP : SYSCFG_CFGR3_I2C1_RX_DMA_RMP_Field := 16#0#;
      --  ADC2 DMA channel remapping bit
      ADC2_DMA_RMP_0  : SYSCFG_CFGR3_ADC2_DMA_RMP_0_Field := 16#0#;
      --  unspecified
      Reserved_8_8    : Interfaces.STM32.Bit := 16#0#;
      --  ADC2 DMA controller remapping bit
      ADC2_DMA_RMP_1  : SYSCFG_CFGR3_ADC2_DMA_RMP_1_Field := 16#0#;
      --  unspecified
      Reserved_10_15  : Interfaces.STM32.UInt6 := 16#0#;
      --  DAC1_CH1 / DAC1_CH2 Trigger remap
      DAC1_TRIG3_RMP  : SYSCFG_CFGR3_DAC1_TRIG3_RMP_Field := 16#0#;
      --  DAC1_CH1 / DAC1_CH2 Trigger remap
      DAC1_TRIG5_RMP  : SYSCFG_CFGR3_DAC1_TRIG5_RMP_Field := 16#0#;
      --  unspecified
      Reserved_18_31  : Interfaces.STM32.UInt14 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SYSCFG_CFGR3_Register use record
      SPI1_RX_DMA_RMP at 0 range 0 .. 1;
      SPI1_TX_DMA_RMP at 0 range 2 .. 3;
      I2C1_RX_DMA_RMP at 0 range 4 .. 5;
      ADC2_DMA_RMP_0  at 0 range 6 .. 7;
      Reserved_8_8    at 0 range 8 .. 8;
      ADC2_DMA_RMP_1  at 0 range 9 .. 9;
      Reserved_10_15  at 0 range 10 .. 15;
      DAC1_TRIG3_RMP  at 0 range 16 .. 16;
      DAC1_TRIG5_RMP  at 0 range 17 .. 17;
      Reserved_18_31  at 0 range 18 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System configuration controller
   type SYSCFG_COMP_OPAMP_Peripheral is record
      --  configuration register 1
      SYSCFG_CFGR1   : aliased SYSCFG_CFGR1_Register;
      --  CCM SRAM protection register
      SYSCFG_RCR     : aliased SYSCFG_RCR_Register;
      --  external interrupt configuration register 1
      SYSCFG_EXTICR1 : aliased SYSCFG_EXTICR1_Register;
      --  external interrupt configuration register 2
      SYSCFG_EXTICR2 : aliased SYSCFG_EXTICR2_Register;
      --  external interrupt configuration register 3
      SYSCFG_EXTICR3 : aliased SYSCFG_EXTICR3_Register;
      --  external interrupt configuration register 4
      SYSCFG_EXTICR4 : aliased SYSCFG_EXTICR4_Register;
      --  configuration register 2
      SYSCFG_CFGR2   : aliased SYSCFG_CFGR2_Register;
      --  control and status register
      COMP2_CSR      : aliased COMP2_CSR_Register;
      --  control and status register
      COMP4_CSR      : aliased COMP4_CSR_Register;
      --  control and status register
      COMP6_CSR      : aliased COMP6_CSR_Register;
      --  OPAMP2 control register
      OPAMP2_CSR     : aliased OPAMP2_CSR_Register;
      --  configuration register 3
      SYSCFG_CFGR3   : aliased SYSCFG_CFGR3_Register;
   end record
     with Volatile;

   for SYSCFG_COMP_OPAMP_Peripheral use record
      SYSCFG_CFGR1   at 16#0# range 0 .. 31;
      SYSCFG_RCR     at 16#4# range 0 .. 31;
      SYSCFG_EXTICR1 at 16#8# range 0 .. 31;
      SYSCFG_EXTICR2 at 16#C# range 0 .. 31;
      SYSCFG_EXTICR3 at 16#10# range 0 .. 31;
      SYSCFG_EXTICR4 at 16#14# range 0 .. 31;
      SYSCFG_CFGR2   at 16#18# range 0 .. 31;
      COMP2_CSR      at 16#20# range 0 .. 31;
      COMP4_CSR      at 16#28# range 0 .. 31;
      COMP6_CSR      at 16#30# range 0 .. 31;
      OPAMP2_CSR     at 16#3C# range 0 .. 31;
      SYSCFG_CFGR3   at 16#50# range 0 .. 31;
   end record;

   --  System configuration controller
   SYSCFG_COMP_OPAMP_Periph : aliased SYSCFG_COMP_OPAMP_Peripheral
     with Import, Address => SYSCFG_COMP_OPAMP_Base;

end Interfaces.STM32.SYSCFG;
