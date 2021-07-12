pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F3x4.svd

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32_SVD.EXTI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  IMR1_MR array
   type IMR1_MR_Field_Array is array (0 .. 17) of Boolean
     with Component_Size => 1, Size => 18;

   --  Type definition for IMR1_MR
   type IMR1_MR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  MR as a value
            Val : HAL.UInt18;
         when True =>
            --  MR as an array
            Arr : IMR1_MR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 18;

   for IMR1_MR_Field use record
      Val at 0 range 0 .. 17;
      Arr at 0 range 0 .. 17;
   end record;

   --  IMR1_MR array
   type IMR1_MR_Field_Array_1 is array (19 .. 20) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for IMR1_MR
   type IMR1_MR_Field_1
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  MR as a value
            Val : HAL.UInt2;
         when True =>
            --  MR as an array
            Arr : IMR1_MR_Field_Array_1;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for IMR1_MR_Field_1 use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  IMR1_MR array
   type IMR1_MR_Field_Array_2 is array (22 .. 23) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for IMR1_MR
   type IMR1_MR_Field_2
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  MR as a value
            Val : HAL.UInt2;
         when True =>
            --  MR as an array
            Arr : IMR1_MR_Field_Array_2;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for IMR1_MR_Field_2 use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Interrupt mask register
   type IMR1_Register is record
      --  Interrupt Mask on line 0
      MR             : IMR1_MR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Interrupt Mask on line 19
      MR_1           : IMR1_MR_Field_1 := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_21_21 : HAL.Bit := 16#0#;
      --  Interrupt Mask on line 22
      MR_2           : IMR1_MR_Field_2 := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_24_24 : HAL.Bit := 16#1#;
      --  Interrupt Mask on line 25
      MR25           : Boolean := True;
      --  unspecified
      Reserved_26_29 : HAL.UInt4 := 16#7#;
      --  Interrupt Mask on line 30
      MR30           : Boolean := False;
      --  unspecified
      Reserved_31_31 : HAL.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IMR1_Register use record
      MR             at 0 range 0 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      MR_1           at 0 range 19 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      MR_2           at 0 range 22 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      MR25           at 0 range 25 .. 25;
      Reserved_26_29 at 0 range 26 .. 29;
      MR30           at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  EMR1_MR array
   type EMR1_MR_Field_Array is array (0 .. 17) of Boolean
     with Component_Size => 1, Size => 18;

   --  Type definition for EMR1_MR
   type EMR1_MR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  MR as a value
            Val : HAL.UInt18;
         when True =>
            --  MR as an array
            Arr : EMR1_MR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 18;

   for EMR1_MR_Field use record
      Val at 0 range 0 .. 17;
      Arr at 0 range 0 .. 17;
   end record;

   --  EMR1_MR array
   type EMR1_MR_Field_Array_1 is array (19 .. 20) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for EMR1_MR
   type EMR1_MR_Field_1
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  MR as a value
            Val : HAL.UInt2;
         when True =>
            --  MR as an array
            Arr : EMR1_MR_Field_Array_1;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for EMR1_MR_Field_1 use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  EMR1_MR array
   type EMR1_MR_Field_Array_2 is array (22 .. 23) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for EMR1_MR
   type EMR1_MR_Field_2
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  MR as a value
            Val : HAL.UInt2;
         when True =>
            --  MR as an array
            Arr : EMR1_MR_Field_Array_2;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for EMR1_MR_Field_2 use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Event mask register
   type EMR1_Register is record
      --  Event Mask on line 0
      MR             : EMR1_MR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Event Mask on line 19
      MR_1           : EMR1_MR_Field_1 := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_21_21 : HAL.Bit := 16#0#;
      --  Event Mask on line 22
      MR_2           : EMR1_MR_Field_2 := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_24_24 : HAL.Bit := 16#0#;
      --  Event Mask on line 25
      MR25           : Boolean := False;
      --  unspecified
      Reserved_26_29 : HAL.UInt4 := 16#0#;
      --  Event Mask on line 30
      MR30           : Boolean := False;
      --  unspecified
      Reserved_31_31 : HAL.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMR1_Register use record
      MR             at 0 range 0 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      MR_1           at 0 range 19 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      MR_2           at 0 range 22 .. 23;
      Reserved_24_24 at 0 range 24 .. 24;
      MR25           at 0 range 25 .. 25;
      Reserved_26_29 at 0 range 26 .. 29;
      MR30           at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  RTSR1_TR array
   type RTSR1_TR_Field_Array is array (0 .. 17) of Boolean
     with Component_Size => 1, Size => 18;

   --  Type definition for RTSR1_TR
   type RTSR1_TR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TR as a value
            Val : HAL.UInt18;
         when True =>
            --  TR as an array
            Arr : RTSR1_TR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 18;

   for RTSR1_TR_Field use record
      Val at 0 range 0 .. 17;
      Arr at 0 range 0 .. 17;
   end record;

   --  RTSR1_TR array
   type RTSR1_TR_Field_Array_1 is array (19 .. 20) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for RTSR1_TR
   type RTSR1_TR_Field_1
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TR as a value
            Val : HAL.UInt2;
         when True =>
            --  TR as an array
            Arr : RTSR1_TR_Field_Array_1;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for RTSR1_TR_Field_1 use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Rising Trigger selection register
   type RTSR1_Register is record
      --  Rising trigger event configuration of line 0
      TR             : RTSR1_TR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Rising trigger event configuration of line 19
      TR_1           : RTSR1_TR_Field_1 := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_21_21 : HAL.Bit := 16#0#;
      --  Rising trigger event configuration of line 22
      TR22           : Boolean := False;
      --  unspecified
      Reserved_23_29 : HAL.UInt7 := 16#0#;
      --  Rising trigger event configuration of line 30
      TR30           : Boolean := False;
      --  unspecified
      Reserved_31_31 : HAL.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTSR1_Register use record
      TR             at 0 range 0 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      TR_1           at 0 range 19 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      TR22           at 0 range 22 .. 22;
      Reserved_23_29 at 0 range 23 .. 29;
      TR30           at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  FTSR1_TR array
   type FTSR1_TR_Field_Array is array (0 .. 17) of Boolean
     with Component_Size => 1, Size => 18;

   --  Type definition for FTSR1_TR
   type FTSR1_TR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TR as a value
            Val : HAL.UInt18;
         when True =>
            --  TR as an array
            Arr : FTSR1_TR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 18;

   for FTSR1_TR_Field use record
      Val at 0 range 0 .. 17;
      Arr at 0 range 0 .. 17;
   end record;

   --  FTSR1_TR array
   type FTSR1_TR_Field_Array_1 is array (19 .. 20) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for FTSR1_TR
   type FTSR1_TR_Field_1
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  TR as a value
            Val : HAL.UInt2;
         when True =>
            --  TR as an array
            Arr : FTSR1_TR_Field_Array_1;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for FTSR1_TR_Field_1 use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Falling Trigger selection register
   type FTSR1_Register is record
      --  Falling trigger event configuration of line 0
      TR             : FTSR1_TR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Falling trigger event configuration of line 19
      TR_1           : FTSR1_TR_Field_1 := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_21_21 : HAL.Bit := 16#0#;
      --  Falling trigger event configuration of line 22
      TR22           : Boolean := False;
      --  unspecified
      Reserved_23_29 : HAL.UInt7 := 16#0#;
      --  Falling trigger event configuration of line 30.
      TR30           : Boolean := False;
      --  unspecified
      Reserved_31_31 : HAL.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTSR1_Register use record
      TR             at 0 range 0 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      TR_1           at 0 range 19 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      TR22           at 0 range 22 .. 22;
      Reserved_23_29 at 0 range 23 .. 29;
      TR30           at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  SWIER1_SWIER array
   type SWIER1_SWIER_Field_Array is array (0 .. 17) of Boolean
     with Component_Size => 1, Size => 18;

   --  Type definition for SWIER1_SWIER
   type SWIER1_SWIER_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  SWIER as a value
            Val : HAL.UInt18;
         when True =>
            --  SWIER as an array
            Arr : SWIER1_SWIER_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 18;

   for SWIER1_SWIER_Field use record
      Val at 0 range 0 .. 17;
      Arr at 0 range 0 .. 17;
   end record;

   --  SWIER1_SWIER array
   type SWIER1_SWIER_Field_Array_1 is array (19 .. 20) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for SWIER1_SWIER
   type SWIER1_SWIER_Field_1
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  SWIER as a value
            Val : HAL.UInt2;
         when True =>
            --  SWIER as an array
            Arr : SWIER1_SWIER_Field_Array_1;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for SWIER1_SWIER_Field_1 use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Software interrupt event register
   type SWIER1_Register is record
      --  Software Interrupt on line 0
      SWIER          : SWIER1_SWIER_Field :=
                        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Software Interrupt on line 19
      SWIER_1        : SWIER1_SWIER_Field_1 :=
                        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_21_21 : HAL.Bit := 16#0#;
      --  Software Interrupt on line 22
      SWIER22        : Boolean := False;
      --  unspecified
      Reserved_23_29 : HAL.UInt7 := 16#0#;
      --  Software Interrupt on line 309
      SWIER30        : Boolean := False;
      --  unspecified
      Reserved_31_31 : HAL.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SWIER1_Register use record
      SWIER          at 0 range 0 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      SWIER_1        at 0 range 19 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      SWIER22        at 0 range 22 .. 22;
      Reserved_23_29 at 0 range 23 .. 29;
      SWIER30        at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  PR1_PR array
   type PR1_PR_Field_Array is array (0 .. 17) of Boolean
     with Component_Size => 1, Size => 18;

   --  Type definition for PR1_PR
   type PR1_PR_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PR as a value
            Val : HAL.UInt18;
         when True =>
            --  PR as an array
            Arr : PR1_PR_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 18;

   for PR1_PR_Field use record
      Val at 0 range 0 .. 17;
      Arr at 0 range 0 .. 17;
   end record;

   --  PR1_PR array
   type PR1_PR_Field_Array_1 is array (19 .. 20) of Boolean
     with Component_Size => 1, Size => 2;

   --  Type definition for PR1_PR
   type PR1_PR_Field_1
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  PR as a value
            Val : HAL.UInt2;
         when True =>
            --  PR as an array
            Arr : PR1_PR_Field_Array_1;
      end case;
   end record
     with Unchecked_Union, Size => 2;

   for PR1_PR_Field_1 use record
      Val at 0 range 0 .. 1;
      Arr at 0 range 0 .. 1;
   end record;

   --  Pending register
   type PR1_Register is record
      --  Pending bit 0
      PR             : PR1_PR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Pending bit 19
      PR_1           : PR1_PR_Field_1 := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_21_21 : HAL.Bit := 16#0#;
      --  Pending bit 22
      PR22           : Boolean := False;
      --  unspecified
      Reserved_23_29 : HAL.UInt7 := 16#0#;
      --  Pending bit 30
      PR30           : Boolean := False;
      --  unspecified
      Reserved_31_31 : HAL.Bit := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PR1_Register use record
      PR             at 0 range 0 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      PR_1           at 0 range 19 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      PR22           at 0 range 22 .. 22;
      Reserved_23_29 at 0 range 23 .. 29;
      PR30           at 0 range 30 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   --  Interrupt mask register
   type IMR2_Register is record
      --  Interrupt Mask on external/internal line 32
      MR32          : Boolean := False;
      --  unspecified
      Reserved_1_31 : HAL.UInt31 := 16#7FFFFFFE#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IMR2_Register use record
      MR32          at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Event mask register
   type EMR2_Register is record
      --  Event mask on external/internal line 32
      MR32          : Boolean := False;
      --  unspecified
      Reserved_1_31 : HAL.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for EMR2_Register use record
      MR32          at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Rising Trigger selection register
   type RTSR2_Register is record
      --  Rising trigger event configuration bit of line 32
      TR32          : Boolean := False;
      --  unspecified
      Reserved_1_31 : HAL.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTSR2_Register use record
      TR32          at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Falling Trigger selection register
   type FTSR2_Register is record
      --  Falling trigger event configuration bit of line 32
      TR32          : Boolean := False;
      --  unspecified
      Reserved_1_31 : HAL.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FTSR2_Register use record
      TR32          at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Software interrupt event register
   type SWIER2_Register is record
      --  Software interrupt on line 32
      SWIER32       : Boolean := False;
      --  unspecified
      Reserved_1_31 : HAL.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SWIER2_Register use record
      SWIER32       at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   --  Pending register
   type PR2_Register is record
      --  Pending bit on line 32
      PR32          : Boolean := False;
      --  unspecified
      Reserved_1_31 : HAL.UInt31 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PR2_Register use record
      PR32          at 0 range 0 .. 0;
      Reserved_1_31 at 0 range 1 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  External interrupt/event controller
   type EXTI_Peripheral is record
      --  Interrupt mask register
      IMR1   : aliased IMR1_Register;
      --  Event mask register
      EMR1   : aliased EMR1_Register;
      --  Rising Trigger selection register
      RTSR1  : aliased RTSR1_Register;
      --  Falling Trigger selection register
      FTSR1  : aliased FTSR1_Register;
      --  Software interrupt event register
      SWIER1 : aliased SWIER1_Register;
      --  Pending register
      PR1    : aliased PR1_Register;
      --  Interrupt mask register
      IMR2   : aliased IMR2_Register;
      --  Event mask register
      EMR2   : aliased EMR2_Register;
      --  Rising Trigger selection register
      RTSR2  : aliased RTSR2_Register;
      --  Falling Trigger selection register
      FTSR2  : aliased FTSR2_Register;
      --  Software interrupt event register
      SWIER2 : aliased SWIER2_Register;
      --  Pending register
      PR2    : aliased PR2_Register;
   end record
     with Volatile;

   for EXTI_Peripheral use record
      IMR1   at 16#0# range 0 .. 31;
      EMR1   at 16#4# range 0 .. 31;
      RTSR1  at 16#8# range 0 .. 31;
      FTSR1  at 16#C# range 0 .. 31;
      SWIER1 at 16#10# range 0 .. 31;
      PR1    at 16#14# range 0 .. 31;
      IMR2   at 16#18# range 0 .. 31;
      EMR2   at 16#1C# range 0 .. 31;
      RTSR2  at 16#20# range 0 .. 31;
      FTSR2  at 16#24# range 0 .. 31;
      SWIER2 at 16#28# range 0 .. 31;
      PR2    at 16#2C# range 0 .. 31;
   end record;

   --  External interrupt/event controller
   EXTI_Periph : aliased EXTI_Peripheral
     with Import, Address => EXTI_Base;

end STM32_SVD.EXTI;
