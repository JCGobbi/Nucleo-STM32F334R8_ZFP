pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F3x4.svd

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32_SVD.DBGMCU is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype IDCODE_DEV_ID_Field is HAL.UInt12;
   subtype IDCODE_REV_ID_Field is HAL.UInt16;

   --  MCU Device ID Code Register
   type IDCODE_Register is record
      --  Read-only. Device Identifier
      DEV_ID         : IDCODE_DEV_ID_Field;
      --  unspecified
      Reserved_12_15 : HAL.UInt4;
      --  Read-only. Revision Identifier
      REV_ID         : IDCODE_REV_ID_Field;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IDCODE_Register use record
      DEV_ID         at 0 range 0 .. 11;
      Reserved_12_15 at 0 range 12 .. 15;
      REV_ID         at 0 range 16 .. 31;
   end record;

   subtype CR_TRACE_MODE_Field is HAL.UInt2;

   --  Debug MCU Configuration Register
   type CR_Register is record
      --  Debug Sleep mode
      DBG_SLEEP     : Boolean := False;
      --  Debug Stop Mode
      DBG_STOP      : Boolean := False;
      --  Debug Standby Mode
      DBG_STANDBY   : Boolean := False;
      --  unspecified
      Reserved_3_4  : HAL.UInt2 := 16#0#;
      --  Trace pin assignment control
      TRACE_IOEN    : Boolean := False;
      --  Trace pin assignment control
      TRACE_MODE    : CR_TRACE_MODE_Field := 16#0#;
      --  unspecified
      Reserved_8_31 : HAL.UInt24 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR_Register use record
      DBG_SLEEP     at 0 range 0 .. 0;
      DBG_STOP      at 0 range 1 .. 1;
      DBG_STANDBY   at 0 range 2 .. 2;
      Reserved_3_4  at 0 range 3 .. 4;
      TRACE_IOEN    at 0 range 5 .. 5;
      TRACE_MODE    at 0 range 6 .. 7;
      Reserved_8_31 at 0 range 8 .. 31;
   end record;

   --  APB Low Freeze Register
   type APB1FZ_Register is record
      --  Debug Timer 2 stopped when Core is halted
      DBG_TIM2_STOP      : Boolean := False;
      --  Debug Timer 3 stopped when Core is halted
      DBG_TIM3_STOP      : Boolean := False;
      --  Debug Timer 4 stopped when Core is halted
      DBG_TIM4_STOP      : Boolean := False;
      --  Debug Timer 5 stopped when Core is halted
      DBG_TIM5_STOP      : Boolean := False;
      --  Debug Timer 6 stopped when Core is halted
      DBG_TIM6_STOP      : Boolean := False;
      --  Debug Timer 7 stopped when Core is halted
      DBG_TIM7_STOP      : Boolean := False;
      --  Debug Timer 12 stopped when Core is halted
      DBG_TIM12_STOP     : Boolean := False;
      --  Debug Timer 13 stopped when Core is halted
      DBG_TIM13_STOP     : Boolean := False;
      --  Debug Timer 14 stopped when Core is halted
      DBG_TIMER14_STOP   : Boolean := False;
      --  Debug Timer 18 stopped when Core is halted
      DBG_TIM18_STOP     : Boolean := False;
      --  Debug RTC stopped when Core is halted
      DBG_RTC_STOP       : Boolean := False;
      --  Debug Window Wachdog stopped when Core is halted
      DBG_WWDG_STOP      : Boolean := False;
      --  Debug Independent Wachdog stopped when Core is halted
      DBG_IWDG_STOP      : Boolean := False;
      --  unspecified
      Reserved_13_20     : HAL.UInt8 := 16#0#;
      --  SMBUS timeout mode stopped when Core is halted
      I2C1_SMBUS_TIMEOUT : Boolean := False;
      --  unspecified
      Reserved_22_24     : HAL.UInt3 := 16#0#;
      --  Debug CAN stopped when core is halted
      DBG_CAN_STOP       : Boolean := False;
      --  unspecified
      Reserved_26_31     : HAL.UInt6 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for APB1FZ_Register use record
      DBG_TIM2_STOP      at 0 range 0 .. 0;
      DBG_TIM3_STOP      at 0 range 1 .. 1;
      DBG_TIM4_STOP      at 0 range 2 .. 2;
      DBG_TIM5_STOP      at 0 range 3 .. 3;
      DBG_TIM6_STOP      at 0 range 4 .. 4;
      DBG_TIM7_STOP      at 0 range 5 .. 5;
      DBG_TIM12_STOP     at 0 range 6 .. 6;
      DBG_TIM13_STOP     at 0 range 7 .. 7;
      DBG_TIMER14_STOP   at 0 range 8 .. 8;
      DBG_TIM18_STOP     at 0 range 9 .. 9;
      DBG_RTC_STOP       at 0 range 10 .. 10;
      DBG_WWDG_STOP      at 0 range 11 .. 11;
      DBG_IWDG_STOP      at 0 range 12 .. 12;
      Reserved_13_20     at 0 range 13 .. 20;
      I2C1_SMBUS_TIMEOUT at 0 range 21 .. 21;
      Reserved_22_24     at 0 range 22 .. 24;
      DBG_CAN_STOP       at 0 range 25 .. 25;
      Reserved_26_31     at 0 range 26 .. 31;
   end record;

   --  APB High Freeze Register
   type APB2FZ_Register is record
      --  unspecified
      Reserved_0_1   : HAL.UInt2 := 16#0#;
      --  Debug Timer 15 stopped when Core is halted
      DBG_TIM15_STOP : Boolean := False;
      --  Debug Timer 16 stopped when Core is halted
      DBG_TIM16_STOP : Boolean := False;
      --  Debug Timer 17 stopped when Core is halted
      DBG_TIM17_STO  : Boolean := False;
      --  Debug Timer 19 stopped when Core is halted
      DBG_TIM19_STOP : Boolean := False;
      --  unspecified
      Reserved_6_31  : HAL.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for APB2FZ_Register use record
      Reserved_0_1   at 0 range 0 .. 1;
      DBG_TIM15_STOP at 0 range 2 .. 2;
      DBG_TIM16_STOP at 0 range 3 .. 3;
      DBG_TIM17_STO  at 0 range 4 .. 4;
      DBG_TIM19_STOP at 0 range 5 .. 5;
      Reserved_6_31  at 0 range 6 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Debug support
   type DBGMCU_Peripheral is record
      --  MCU Device ID Code Register
      IDCODE : aliased IDCODE_Register;
      --  Debug MCU Configuration Register
      CR     : aliased CR_Register;
      --  APB Low Freeze Register
      APB1FZ : aliased APB1FZ_Register;
      --  APB High Freeze Register
      APB2FZ : aliased APB2FZ_Register;
   end record
     with Volatile;

   for DBGMCU_Peripheral use record
      IDCODE at 16#0# range 0 .. 31;
      CR     at 16#4# range 0 .. 31;
      APB1FZ at 16#8# range 0 .. 31;
      APB2FZ at 16#C# range 0 .. 31;
   end record;

   --  Debug support
   DBGMCU_Periph : aliased DBGMCU_Peripheral
     with Import, Address => DBGMCU_Base;

end STM32_SVD.DBGMCU;
