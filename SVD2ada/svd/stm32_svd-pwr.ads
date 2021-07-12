pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F3x4.svd

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32_SVD.PWR is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CR_PLS_Field is HAL.UInt3;

   --  power control register
   type CR_Register is record
      --  Low-power deep sleep
      LPDS          : Boolean := False;
      --  Power down deepsleep
      PDDS          : Boolean := False;
      --  Clear wakeup flag
      CWUF          : Boolean := False;
      --  Clear standby flag
      CSBF          : Boolean := False;
      --  Power voltage detector enable
      PVDE          : Boolean := False;
      --  PVD level selection
      PLS           : CR_PLS_Field := 16#0#;
      --  Disable backup domain write protection
      DBP           : Boolean := False;
      --  unspecified
      Reserved_9_31 : HAL.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR_Register use record
      LPDS          at 0 range 0 .. 0;
      PDDS          at 0 range 1 .. 1;
      CWUF          at 0 range 2 .. 2;
      CSBF          at 0 range 3 .. 3;
      PVDE          at 0 range 4 .. 4;
      PLS           at 0 range 5 .. 7;
      DBP           at 0 range 8 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   --  CSR_EWUP array
   type CSR_EWUP_Field_Array is array (1 .. 3) of Boolean
     with Component_Size => 1, Size => 3;

   --  Type definition for CSR_EWUP
   type CSR_EWUP_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  EWUP as a value
            Val : HAL.UInt3;
         when True =>
            --  EWUP as an array
            Arr : CSR_EWUP_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 3;

   for CSR_EWUP_Field use record
      Val at 0 range 0 .. 2;
      Arr at 0 range 0 .. 2;
   end record;

   --  power control/status register
   type CSR_Register is record
      --  Read-only. Wakeup flag
      WUF            : Boolean := False;
      --  Read-only. Standby flag
      SBF            : Boolean := False;
      --  Read-only. PVD output
      PVDO           : Boolean := False;
      --  unspecified
      Reserved_3_7   : HAL.UInt5 := 16#0#;
      --  Enable WKUP1 pin
      EWUP           : CSR_EWUP_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_11_31 : HAL.UInt21 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CSR_Register use record
      WUF            at 0 range 0 .. 0;
      SBF            at 0 range 1 .. 1;
      PVDO           at 0 range 2 .. 2;
      Reserved_3_7   at 0 range 3 .. 7;
      EWUP           at 0 range 8 .. 10;
      Reserved_11_31 at 0 range 11 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Power control
   type PWR_Peripheral is record
      --  power control register
      CR  : aliased CR_Register;
      --  power control/status register
      CSR : aliased CSR_Register;
   end record
     with Volatile;

   for PWR_Peripheral use record
      CR  at 16#0# range 0 .. 31;
      CSR at 16#4# range 0 .. 31;
   end record;

   --  Power control
   PWR_Periph : aliased PWR_Peripheral
     with Import, Address => PWR_Base;

end STM32_SVD.PWR;
