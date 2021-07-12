pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F3x4.svd

pragma Restrictions (No_Elaboration_Code);

with System;

--  STM32F3x4
package STM32_SVD is
   pragma Preelaborate;

   --------------------
   -- Base addresses --
   --------------------

   GPIOA_Base : constant System.Address := System'To_Address (16#48000000#);
   GPIOB_Base : constant System.Address := System'To_Address (16#48000400#);
   GPIOC_Base : constant System.Address := System'To_Address (16#48000800#);
   GPIOD_Base : constant System.Address := System'To_Address (16#48000C00#);
   GPIOF_Base : constant System.Address := System'To_Address (16#48001400#);
   TSC_Base : constant System.Address := System'To_Address (16#40024000#);
   CRC_Base : constant System.Address := System'To_Address (16#40023000#);
   Flash_Base : constant System.Address := System'To_Address (16#40022000#);
   RCC_Base : constant System.Address := System'To_Address (16#40021000#);
   DMA_Base : constant System.Address := System'To_Address (16#40020000#);
   TIM2_Base : constant System.Address := System'To_Address (16#40000000#);
   TIM15_Base : constant System.Address := System'To_Address (16#40014000#);
   TIM16_Base : constant System.Address := System'To_Address (16#40014400#);
   TIM17_Base : constant System.Address := System'To_Address (16#40014800#);
   USART1_Base : constant System.Address := System'To_Address (16#40013800#);
   USART2_Base : constant System.Address := System'To_Address (16#40004400#);
   USART3_Base : constant System.Address := System'To_Address (16#40004800#);
   SPI_Base : constant System.Address := System'To_Address (16#40013000#);
   EXTI_Base : constant System.Address := System'To_Address (16#40010400#);
   PWR_Base : constant System.Address := System'To_Address (16#40007000#);
   I2C_Base : constant System.Address := System'To_Address (16#40005400#);
   IWDG_Base : constant System.Address := System'To_Address (16#40003000#);
   WWDG_Base : constant System.Address := System'To_Address (16#40002C00#);
   RTC_Base : constant System.Address := System'To_Address (16#40002800#);
   TIM6_Base : constant System.Address := System'To_Address (16#40001000#);
   TIM7_Base : constant System.Address := System'To_Address (16#40001400#);
   DAC1_Base : constant System.Address := System'To_Address (16#40007400#);
   DAC2_Base : constant System.Address := System'To_Address (16#40009800#);
   DBGMCU_Base : constant System.Address := System'To_Address (16#E0042000#);
   TIM1_Base : constant System.Address := System'To_Address (16#40012C00#);
   ADC1_Base : constant System.Address := System'To_Address (16#50000000#);
   ADC2_Base : constant System.Address := System'To_Address (16#50000100#);
   SYSCFG_COMP_OPAMP_Base : constant System.Address := System'To_Address (16#40010000#);
   TIM3_Base : constant System.Address := System'To_Address (16#40000400#);
   CAN_Base : constant System.Address := System'To_Address (16#40006400#);
   ADC_Common_Base : constant System.Address := System'To_Address (16#50000300#);
   HRTIM_Master_Base : constant System.Address := System'To_Address (16#40017400#);
   HRTIM_TIMA_Base : constant System.Address := System'To_Address (16#40017480#);
   HRTIM_TIMB_Base : constant System.Address := System'To_Address (16#40017500#);
   HRTIM_TIMC_Base : constant System.Address := System'To_Address (16#40017580#);
   HRTIM_TIMD_Base : constant System.Address := System'To_Address (16#40017600#);
   HRTIM_TIME_Base : constant System.Address := System'To_Address (16#40017680#);
   HRTIM_Common_Base : constant System.Address := System'To_Address (16#40017780#);
   NVIC_Base : constant System.Address := System'To_Address (16#E000E100#);
   FPU_Base : constant System.Address := System'To_Address (16#E000EF34#);
   MPU_Base : constant System.Address := System'To_Address (16#E000ED90#);
   STK_Base : constant System.Address := System'To_Address (16#E000E010#);
   SCB_Base : constant System.Address := System'To_Address (16#E000ED00#);
   NVIC_STIR_Base : constant System.Address := System'To_Address (16#E000EF00#);
   FPU_CPACR_Base : constant System.Address := System'To_Address (16#E000ED88#);
   SCB_ACTRL_Base : constant System.Address := System'To_Address (16#E000E008#);

end STM32_SVD;
