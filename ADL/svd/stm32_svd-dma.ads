pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F3x4.svd

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32_SVD.DMA is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  DMA interrupt status register (DMA_ISR)
   type ISR_Register is record
      --  Read-only. Channel 1 Global interrupt flag
      GIF1           : Boolean;
      --  Read-only. Channel 1 Transfer Complete flag
      TCIF1          : Boolean;
      --  Read-only. Channel 1 Half Transfer Complete flag
      HTIF1          : Boolean;
      --  Read-only. Channel 1 Transfer Error flag
      TEIF1          : Boolean;
      --  Read-only. Channel 2 Global interrupt flag
      GIF2           : Boolean;
      --  Read-only. Channel 2 Transfer Complete flag
      TCIF2          : Boolean;
      --  Read-only. Channel 2 Half Transfer Complete flag
      HTIF2          : Boolean;
      --  Read-only. Channel 2 Transfer Error flag
      TEIF2          : Boolean;
      --  Read-only. Channel 3 Global interrupt flag
      GIF3           : Boolean;
      --  Read-only. Channel 3 Transfer Complete flag
      TCIF3          : Boolean;
      --  Read-only. Channel 3 Half Transfer Complete flag
      HTIF3          : Boolean;
      --  Read-only. Channel 3 Transfer Error flag
      TEIF3          : Boolean;
      --  Read-only. Channel 4 Global interrupt flag
      GIF4           : Boolean;
      --  Read-only. Channel 4 Transfer Complete flag
      TCIF4          : Boolean;
      --  Read-only. Channel 4 Half Transfer Complete flag
      HTIF4          : Boolean;
      --  Read-only. Channel 4 Transfer Error flag
      TEIF4          : Boolean;
      --  Read-only. Channel 5 Global interrupt flag
      GIF5           : Boolean;
      --  Read-only. Channel 5 Transfer Complete flag
      TCIF5          : Boolean;
      --  Read-only. Channel 5 Half Transfer Complete flag
      HTIF5          : Boolean;
      --  Read-only. Channel 5 Transfer Error flag
      TEIF5          : Boolean;
      --  Read-only. Channel 6 Global interrupt flag
      GIF6           : Boolean;
      --  Read-only. Channel 6 Transfer Complete flag
      TCIF6          : Boolean;
      --  Read-only. Channel 6 Half Transfer Complete flag
      HTIF6          : Boolean;
      --  Read-only. Channel 6 Transfer Error flag
      TEIF6          : Boolean;
      --  Read-only. Channel 7 Global interrupt flag
      GIF7           : Boolean;
      --  Read-only. Channel 7 Transfer Complete flag
      TCIF7          : Boolean;
      --  Read-only. Channel 7 Half Transfer Complete flag
      HTIF7          : Boolean;
      --  Read-only. Channel 7 Transfer Error flag
      TEIF7          : Boolean;
      --  unspecified
      Reserved_28_31 : HAL.UInt4;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ISR_Register use record
      GIF1           at 0 range 0 .. 0;
      TCIF1          at 0 range 1 .. 1;
      HTIF1          at 0 range 2 .. 2;
      TEIF1          at 0 range 3 .. 3;
      GIF2           at 0 range 4 .. 4;
      TCIF2          at 0 range 5 .. 5;
      HTIF2          at 0 range 6 .. 6;
      TEIF2          at 0 range 7 .. 7;
      GIF3           at 0 range 8 .. 8;
      TCIF3          at 0 range 9 .. 9;
      HTIF3          at 0 range 10 .. 10;
      TEIF3          at 0 range 11 .. 11;
      GIF4           at 0 range 12 .. 12;
      TCIF4          at 0 range 13 .. 13;
      HTIF4          at 0 range 14 .. 14;
      TEIF4          at 0 range 15 .. 15;
      GIF5           at 0 range 16 .. 16;
      TCIF5          at 0 range 17 .. 17;
      HTIF5          at 0 range 18 .. 18;
      TEIF5          at 0 range 19 .. 19;
      GIF6           at 0 range 20 .. 20;
      TCIF6          at 0 range 21 .. 21;
      HTIF6          at 0 range 22 .. 22;
      TEIF6          at 0 range 23 .. 23;
      GIF7           at 0 range 24 .. 24;
      TCIF7          at 0 range 25 .. 25;
      HTIF7          at 0 range 26 .. 26;
      TEIF7          at 0 range 27 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   --  DMA interrupt flag clear register (DMA_IFCR)
   type IFCR_Register is record
      --  Write-only. Channel 1 Global interrupt clear
      CGIF1          : Boolean := False;
      --  Write-only. Channel 1 Transfer Complete clear
      CTCIF1         : Boolean := False;
      --  Write-only. Channel 1 Half Transfer clear
      CHTIF1         : Boolean := False;
      --  Write-only. Channel 1 Transfer Error clear
      CTEIF1         : Boolean := False;
      --  Write-only. Channel 2 Global interrupt clear
      CGIF2          : Boolean := False;
      --  Write-only. Channel 2 Transfer Complete clear
      CTCIF2         : Boolean := False;
      --  Write-only. Channel 2 Half Transfer clear
      CHTIF2         : Boolean := False;
      --  Write-only. Channel 2 Transfer Error clear
      CTEIF2         : Boolean := False;
      --  Write-only. Channel 3 Global interrupt clear
      CGIF3          : Boolean := False;
      --  Write-only. Channel 3 Transfer Complete clear
      CTCIF3         : Boolean := False;
      --  Write-only. Channel 3 Half Transfer clear
      CHTIF3         : Boolean := False;
      --  Write-only. Channel 3 Transfer Error clear
      CTEIF3         : Boolean := False;
      --  Write-only. Channel 4 Global interrupt clear
      CGIF4          : Boolean := False;
      --  Write-only. Channel 4 Transfer Complete clear
      CTCIF4         : Boolean := False;
      --  Write-only. Channel 4 Half Transfer clear
      CHTIF4         : Boolean := False;
      --  Write-only. Channel 4 Transfer Error clear
      CTEIF4         : Boolean := False;
      --  Write-only. Channel 5 Global interrupt clear
      CGIF5          : Boolean := False;
      --  Write-only. Channel 5 Transfer Complete clear
      CTCIF5         : Boolean := False;
      --  Write-only. Channel 5 Half Transfer clear
      CHTIF5         : Boolean := False;
      --  Write-only. Channel 5 Transfer Error clear
      CTEIF5         : Boolean := False;
      --  Write-only. Channel 6 Global interrupt clear
      CGIF6          : Boolean := False;
      --  Write-only. Channel 6 Transfer Complete clear
      CTCIF6         : Boolean := False;
      --  Write-only. Channel 6 Half Transfer clear
      CHTIF6         : Boolean := False;
      --  Write-only. Channel 6 Transfer Error clear
      CTEIF6         : Boolean := False;
      --  Write-only. Channel 7 Global interrupt clear
      CGIF7          : Boolean := False;
      --  Write-only. Channel 7 Transfer Complete clear
      CTCIF7         : Boolean := False;
      --  Write-only. Channel 7 Half Transfer clear
      CHTIF7         : Boolean := False;
      --  Write-only. Channel 7 Transfer Error clear
      CTEIF7         : Boolean := False;
      --  unspecified
      Reserved_28_31 : HAL.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IFCR_Register use record
      CGIF1          at 0 range 0 .. 0;
      CTCIF1         at 0 range 1 .. 1;
      CHTIF1         at 0 range 2 .. 2;
      CTEIF1         at 0 range 3 .. 3;
      CGIF2          at 0 range 4 .. 4;
      CTCIF2         at 0 range 5 .. 5;
      CHTIF2         at 0 range 6 .. 6;
      CTEIF2         at 0 range 7 .. 7;
      CGIF3          at 0 range 8 .. 8;
      CTCIF3         at 0 range 9 .. 9;
      CHTIF3         at 0 range 10 .. 10;
      CTEIF3         at 0 range 11 .. 11;
      CGIF4          at 0 range 12 .. 12;
      CTCIF4         at 0 range 13 .. 13;
      CHTIF4         at 0 range 14 .. 14;
      CTEIF4         at 0 range 15 .. 15;
      CGIF5          at 0 range 16 .. 16;
      CTCIF5         at 0 range 17 .. 17;
      CHTIF5         at 0 range 18 .. 18;
      CTEIF5         at 0 range 19 .. 19;
      CGIF6          at 0 range 20 .. 20;
      CTCIF6         at 0 range 21 .. 21;
      CHTIF6         at 0 range 22 .. 22;
      CTEIF6         at 0 range 23 .. 23;
      CGIF7          at 0 range 24 .. 24;
      CTCIF7         at 0 range 25 .. 25;
      CHTIF7         at 0 range 26 .. 26;
      CTEIF7         at 0 range 27 .. 27;
      Reserved_28_31 at 0 range 28 .. 31;
   end record;

   subtype CCR_PSIZE_Field is HAL.UInt2;
   subtype CCR_MSIZE_Field is HAL.UInt2;
   subtype CCR_PL_Field is HAL.UInt2;

   --  DMA channel configuration register (DMA_CCR)
   type CCR_Register is record
      --  Channel enable
      EN             : Boolean := False;
      --  Transfer complete interrupt enable
      TCIE           : Boolean := False;
      --  Half Transfer interrupt enable
      HTIE           : Boolean := False;
      --  Transfer error interrupt enable
      TEIE           : Boolean := False;
      --  Data transfer direction
      DIR            : Boolean := False;
      --  Circular mode
      CIRC           : Boolean := False;
      --  Peripheral increment mode
      PINC           : Boolean := False;
      --  Memory increment mode
      MINC           : Boolean := False;
      --  Peripheral size
      PSIZE          : CCR_PSIZE_Field := 16#0#;
      --  Memory size
      MSIZE          : CCR_MSIZE_Field := 16#0#;
      --  Channel Priority level
      PL             : CCR_PL_Field := 16#0#;
      --  Memory to memory mode
      MEM2MEM        : Boolean := False;
      --  unspecified
      Reserved_15_31 : HAL.UInt17 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CCR_Register use record
      EN             at 0 range 0 .. 0;
      TCIE           at 0 range 1 .. 1;
      HTIE           at 0 range 2 .. 2;
      TEIE           at 0 range 3 .. 3;
      DIR            at 0 range 4 .. 4;
      CIRC           at 0 range 5 .. 5;
      PINC           at 0 range 6 .. 6;
      MINC           at 0 range 7 .. 7;
      PSIZE          at 0 range 8 .. 9;
      MSIZE          at 0 range 10 .. 11;
      PL             at 0 range 12 .. 13;
      MEM2MEM        at 0 range 14 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   subtype CNDTR_NDT_Field is HAL.UInt16;

   --  DMA channel 1 number of data register
   type CNDTR_Register is record
      --  Number of data to transfer
      NDT            : CNDTR_NDT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : HAL.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CNDTR_Register use record
      NDT            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  DMA controller 1
   type DMA_Peripheral is record
      --  DMA interrupt status register (DMA_ISR)
      ISR    : aliased ISR_Register;
      --  DMA interrupt flag clear register (DMA_IFCR)
      IFCR   : aliased IFCR_Register;
      --  DMA channel configuration register (DMA_CCR)
      CCR1   : aliased CCR_Register;
      --  DMA channel 1 number of data register
      CNDTR1 : aliased CNDTR_Register;
      --  DMA channel 1 peripheral address register
      CPAR1  : aliased HAL.UInt32;
      --  DMA channel 1 memory address register
      CMAR1  : aliased HAL.UInt32;
      --  DMA channel configuration register (DMA_CCR)
      CCR2   : aliased CCR_Register;
      --  DMA channel 2 number of data register
      CNDTR2 : aliased CNDTR_Register;
      --  DMA channel 2 peripheral address register
      CPAR2  : aliased HAL.UInt32;
      --  DMA channel 2 memory address register
      CMAR2  : aliased HAL.UInt32;
      --  DMA channel configuration register (DMA_CCR)
      CCR3   : aliased CCR_Register;
      --  DMA channel 3 number of data register
      CNDTR3 : aliased CNDTR_Register;
      --  DMA channel 3 peripheral address register
      CPAR3  : aliased HAL.UInt32;
      --  DMA channel 3 memory address register
      CMAR3  : aliased HAL.UInt32;
      --  DMA channel configuration register (DMA_CCR)
      CCR4   : aliased CCR_Register;
      --  DMA channel 4 number of data register
      CNDTR4 : aliased CNDTR_Register;
      --  DMA channel 4 peripheral address register
      CPAR4  : aliased HAL.UInt32;
      --  DMA channel 4 memory address register
      CMAR4  : aliased HAL.UInt32;
      --  DMA channel configuration register (DMA_CCR)
      CCR5   : aliased CCR_Register;
      --  DMA channel 5 number of data register
      CNDTR5 : aliased CNDTR_Register;
      --  DMA channel 5 peripheral address register
      CPAR5  : aliased HAL.UInt32;
      --  DMA channel 5 memory address register
      CMAR5  : aliased HAL.UInt32;
      --  DMA channel configuration register (DMA_CCR)
      CCR6   : aliased CCR_Register;
      --  DMA channel 6 number of data register
      CNDTR6 : aliased CNDTR_Register;
      --  DMA channel 6 peripheral address register
      CPAR6  : aliased HAL.UInt32;
      --  DMA channel 6 memory address register
      CMAR6  : aliased HAL.UInt32;
      --  DMA channel configuration register (DMA_CCR)
      CCR7   : aliased CCR_Register;
      --  DMA channel 7 number of data register
      CNDTR7 : aliased CNDTR_Register;
      --  DMA channel 7 peripheral address register
      CPAR7  : aliased HAL.UInt32;
      --  DMA channel 7 memory address register
      CMAR7  : aliased HAL.UInt32;
   end record
     with Volatile;

   for DMA_Peripheral use record
      ISR    at 16#0# range 0 .. 31;
      IFCR   at 16#4# range 0 .. 31;
      CCR1   at 16#8# range 0 .. 31;
      CNDTR1 at 16#C# range 0 .. 31;
      CPAR1  at 16#10# range 0 .. 31;
      CMAR1  at 16#14# range 0 .. 31;
      CCR2   at 16#1C# range 0 .. 31;
      CNDTR2 at 16#20# range 0 .. 31;
      CPAR2  at 16#24# range 0 .. 31;
      CMAR2  at 16#28# range 0 .. 31;
      CCR3   at 16#30# range 0 .. 31;
      CNDTR3 at 16#34# range 0 .. 31;
      CPAR3  at 16#38# range 0 .. 31;
      CMAR3  at 16#3C# range 0 .. 31;
      CCR4   at 16#44# range 0 .. 31;
      CNDTR4 at 16#48# range 0 .. 31;
      CPAR4  at 16#4C# range 0 .. 31;
      CMAR4  at 16#50# range 0 .. 31;
      CCR5   at 16#58# range 0 .. 31;
      CNDTR5 at 16#5C# range 0 .. 31;
      CPAR5  at 16#60# range 0 .. 31;
      CMAR5  at 16#64# range 0 .. 31;
      CCR6   at 16#6C# range 0 .. 31;
      CNDTR6 at 16#70# range 0 .. 31;
      CPAR6  at 16#74# range 0 .. 31;
      CMAR6  at 16#78# range 0 .. 31;
      CCR7   at 16#80# range 0 .. 31;
      CNDTR7 at 16#84# range 0 .. 31;
      CPAR7  at 16#88# range 0 .. 31;
      CMAR7  at 16#8C# range 0 .. 31;
   end record;

   --  DMA controller 1
   DMA_Periph : aliased DMA_Peripheral
     with Import, Address => DMA_Base;

end STM32_SVD.DMA;
