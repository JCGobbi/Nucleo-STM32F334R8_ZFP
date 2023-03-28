--
--  Copyright (C) 2023, AdaCore
--

pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F3x4.svd

--  This is a version for the STM32F3x4 MCU
package Sys.Int.Names is

   --  All identifiers in this unit are implementation defined

   pragma Implementation_Defined;

   ----------------
   -- Interrupts --
   ----------------

   --  System tick
   Sys_Tick_Interrupt            : constant Interrupt_ID := -1;

   --  Window Watchdog interrupt
   WWDG_Interrupt                : constant Interrupt_ID := 0;

   --  PVD through EXTI line detection interrupt
   PVD_Interrupt                 : constant Interrupt_ID := 1;

   --  Tamper and TimeStamp interrupts
   TAMP_STAMP_Interrupt          : constant Interrupt_ID := 2;

   --  RTC Wakeup interrupt through the EXTI line
   RTC_WKUP_Interrupt            : constant Interrupt_ID := 3;

   --  Flash global interrupt
   FLASH_Interrupt               : constant Interrupt_ID := 4;

   --  RCC global interrupt
   RCC_Interrupt                 : constant Interrupt_ID := 5;

   --  EXTI Line0 interrupt
   EXTI0_Interrupt               : constant Interrupt_ID := 6;

   --  EXTI Line3 interrupt
   EXTI1_Interrupt               : constant Interrupt_ID := 7;

   --  EXTI Line2 and Touch sensing interrupts
   EXTI2_TSC_Interrupt           : constant Interrupt_ID := 8;

   --  EXTI Line3 interrupt
   EXTI3_Interrupt               : constant Interrupt_ID := 9;

   --  EXTI Line4 interrupt
   EXTI4_Interrupt               : constant Interrupt_ID := 10;

   --  DMA1 channel 1 interrupt
   DMA1_CH1_Interrupt            : constant Interrupt_ID := 11;

   --  DMA1 channel 2 interrupt
   DMA1_CH2_Interrupt            : constant Interrupt_ID := 12;

   --  DMA1 channel 3 interrupt
   DMA1_CH3_Interrupt            : constant Interrupt_ID := 13;

   --  DMA1 channel 4 interrupt
   DMA1_CH4_Interrupt            : constant Interrupt_ID := 14;

   --  DMA1 channel 5 interrupt
   DMA1_CH5_Interrupt            : constant Interrupt_ID := 15;

   --  DMA1 channel 6 interrupt
   DMA1_CH6_Interrupt            : constant Interrupt_ID := 16;

   --  DMA1 channel 7interrupt
   DMA1_CH7_Interrupt            : constant Interrupt_ID := 17;

   --  ADC1 and ADC2 global interrupt
   ADC1_2_Interrupt              : constant Interrupt_ID := 18;

   --  USB High Priority/CAN_TX interrupts
   USB_HP_CAN_TX_Interrupt       : constant Interrupt_ID := 19;

   --  USB Low Priority/CAN_RX0 interrupts
   USB_LP_CAN_RX0_Interrupt      : constant Interrupt_ID := 20;

   --  CAN_RX1 interrupt
   CAN_RX1_Interrupt             : constant Interrupt_ID := 21;

   --  CAN_SCE interrupt
   CAN_SCE_Interrupt             : constant Interrupt_ID := 22;

   --  EXTI Line5 to Line9 interrupts
   EXTI9_5_Interrupt             : constant Interrupt_ID := 23;

   --  TIM1 Break/TIM15 global interruts
   TIM1_BRK_TIM15_Interrupt      : constant Interrupt_ID := 24;

   --  TIM1 Update/TIM16 global interrupts
   TIM1_UP_TIM16_Interrupt       : constant Interrupt_ID := 25;

   --  TIM1 trigger and commutation/TIM17 interrupts
   TIM1_TRG_COM_TIM17_Interrupt  : constant Interrupt_ID := 26;

   --  TIM1 capture compare interrupt
   TIM1_CC_Interrupt             : constant Interrupt_ID := 27;

   --  TIM2 global interrupt
   TIM2_Interrupt                : constant Interrupt_ID := 28;

   --  Timer 3 global interrupt
   TIM3_Interrupt                : constant Interrupt_ID := 29;

   --  I2C1 event interrupt and EXTI Line23 interrupt
   I2C1_EV_EXTI23_Interrupt      : constant Interrupt_ID := 31;

   --  I2C1 error interrupt
   I2C1_ER_Interrupt             : constant Interrupt_ID := 32;

   --  SPI1 global interrupt
   SPI1_Interrupt                : constant Interrupt_ID := 35;

   --  USART1 global interrupt and EXTI Line 25 interrupt
   USART1_EXTI25_Interrupt       : constant Interrupt_ID := 37;

   --  USART2 global interrupt and EXTI Line 26 interrupt
   USART2_EXTI26_Interrupt       : constant Interrupt_ID := 38;

   --  USART3 global interrupt and EXTI Line 28 interrupt
   USART3_EXTI28_Interrupt       : constant Interrupt_ID := 39;

   --  EXTI Line15 to Line10 interrupts
   EXTI15_10_Interrupt           : constant Interrupt_ID := 40;

   --  RTC alarm interrupt
   RTC_Alarm_Interrupt           : constant Interrupt_ID := 41;

   --  TIM6 global and DAC12 underrun interrupts
   TIM6_DAC1_Interrupt           : constant Interrupt_ID := 54;

   --  TIM7 global interrupt
   TIM7_DAC2_Interrupt           : constant Interrupt_ID := 55;

   --  HRTIM1 master timer interrupt
   HRTIM1_MST_Interrupt          : constant Interrupt_ID := 67;

   --  HRTIM1 timer A interrupt
   HRTIM1_TIMA_Interrupt         : constant Interrupt_ID := 68;

   --  HRTIM1 timer B interrupt
   HRTIM1_TIMB_Interrupt         : constant Interrupt_ID := 69;

   --  HRTIM1 timer C interrupt
   HRTIM1_TIMC_Interrupt         : constant Interrupt_ID := 70;

   --  HRTIM1 timer D interrupt
   HRTIM1_TIMD_Interrupt         : constant Interrupt_ID := 71;

   --  HRTIM1 timer E interrupt
   HRTIM1_TIME_Interrupt         : constant Interrupt_ID := 72;

   --  HRTIM1 fault interrupt
   HRTIM1_FLT_Interrupt          : constant Interrupt_ID := 73;

   --  FPU global interrupt
   FPU_Interrupt                 : constant Interrupt_ID := 81;

end Sys.Int.Names;
