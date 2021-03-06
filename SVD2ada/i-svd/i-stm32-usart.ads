--
--  Copyright (C) 2022, AdaCore
--

pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F3x4.svd


with System;

package Interfaces.STM32.USART is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   subtype CR1_UE_Field is Interfaces.STM32.Bit;
   subtype CR1_UESM_Field is Interfaces.STM32.Bit;
   subtype CR1_RE_Field is Interfaces.STM32.Bit;
   subtype CR1_TE_Field is Interfaces.STM32.Bit;
   subtype CR1_IDLEIE_Field is Interfaces.STM32.Bit;
   subtype CR1_RXNEIE_Field is Interfaces.STM32.Bit;
   subtype CR1_TCIE_Field is Interfaces.STM32.Bit;
   subtype CR1_TXEIE_Field is Interfaces.STM32.Bit;
   subtype CR1_PEIE_Field is Interfaces.STM32.Bit;
   subtype CR1_PS_Field is Interfaces.STM32.Bit;
   subtype CR1_PCE_Field is Interfaces.STM32.Bit;
   subtype CR1_WAKE_Field is Interfaces.STM32.Bit;
   subtype CR1_M0_Field is Interfaces.STM32.Bit;
   subtype CR1_MME_Field is Interfaces.STM32.Bit;
   subtype CR1_CMIE_Field is Interfaces.STM32.Bit;
   subtype CR1_OVER8_Field is Interfaces.STM32.Bit;
   subtype CR1_DEDT_Field is Interfaces.STM32.UInt5;
   subtype CR1_DEAT_Field is Interfaces.STM32.UInt5;
   subtype CR1_RTOIE_Field is Interfaces.STM32.Bit;
   subtype CR1_EOBIE_Field is Interfaces.STM32.Bit;
   subtype CR1_M1_Field is Interfaces.STM32.Bit;

   --  Control register 1
   type CR1_Register is record
      --  USART enable
      UE             : CR1_UE_Field := 16#0#;
      --  USART enable in Stop mode
      UESM           : CR1_UESM_Field := 16#0#;
      --  Receiver enable
      RE             : CR1_RE_Field := 16#0#;
      --  Transmitter enable
      TE             : CR1_TE_Field := 16#0#;
      --  IDLE interrupt enable
      IDLEIE         : CR1_IDLEIE_Field := 16#0#;
      --  RXNE interrupt enable
      RXNEIE         : CR1_RXNEIE_Field := 16#0#;
      --  Transmission complete interrupt enable
      TCIE           : CR1_TCIE_Field := 16#0#;
      --  interrupt enable
      TXEIE          : CR1_TXEIE_Field := 16#0#;
      --  PE interrupt enable
      PEIE           : CR1_PEIE_Field := 16#0#;
      --  Parity selection
      PS             : CR1_PS_Field := 16#0#;
      --  Parity control enable
      PCE            : CR1_PCE_Field := 16#0#;
      --  Receiver wakeup method
      WAKE           : CR1_WAKE_Field := 16#0#;
      --  Word length bit 0
      M0             : CR1_M0_Field := 16#0#;
      --  Mute mode enable
      MME            : CR1_MME_Field := 16#0#;
      --  Character match interrupt enable
      CMIE           : CR1_CMIE_Field := 16#0#;
      --  Oversampling mode
      OVER8          : CR1_OVER8_Field := 16#0#;
      --  Driver Enable deassertion time
      DEDT           : CR1_DEDT_Field := 16#0#;
      --  Driver Enable assertion time
      DEAT           : CR1_DEAT_Field := 16#0#;
      --  Receiver timeout interrupt enable
      RTOIE          : CR1_RTOIE_Field := 16#0#;
      --  End of Block interrupt enable
      EOBIE          : CR1_EOBIE_Field := 16#0#;
      --  Word length bit 1
      M1             : CR1_M1_Field := 16#0#;
      --  unspecified
      Reserved_29_31 : Interfaces.STM32.UInt3 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR1_Register use record
      UE             at 0 range 0 .. 0;
      UESM           at 0 range 1 .. 1;
      RE             at 0 range 2 .. 2;
      TE             at 0 range 3 .. 3;
      IDLEIE         at 0 range 4 .. 4;
      RXNEIE         at 0 range 5 .. 5;
      TCIE           at 0 range 6 .. 6;
      TXEIE          at 0 range 7 .. 7;
      PEIE           at 0 range 8 .. 8;
      PS             at 0 range 9 .. 9;
      PCE            at 0 range 10 .. 10;
      WAKE           at 0 range 11 .. 11;
      M0             at 0 range 12 .. 12;
      MME            at 0 range 13 .. 13;
      CMIE           at 0 range 14 .. 14;
      OVER8          at 0 range 15 .. 15;
      DEDT           at 0 range 16 .. 20;
      DEAT           at 0 range 21 .. 25;
      RTOIE          at 0 range 26 .. 26;
      EOBIE          at 0 range 27 .. 27;
      M1             at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   subtype CR2_ADDM7_Field is Interfaces.STM32.Bit;
   subtype CR2_LBDL_Field is Interfaces.STM32.Bit;
   subtype CR2_LBDIE_Field is Interfaces.STM32.Bit;
   subtype CR2_LBCL_Field is Interfaces.STM32.Bit;
   subtype CR2_CPHA_Field is Interfaces.STM32.Bit;
   subtype CR2_CPOL_Field is Interfaces.STM32.Bit;
   subtype CR2_CLKEN_Field is Interfaces.STM32.Bit;
   subtype CR2_STOP_Field is Interfaces.STM32.UInt2;
   subtype CR2_LINEN_Field is Interfaces.STM32.Bit;
   subtype CR2_SWAP_Field is Interfaces.STM32.Bit;
   subtype CR2_RXINV_Field is Interfaces.STM32.Bit;
   subtype CR2_TXINV_Field is Interfaces.STM32.Bit;
   subtype CR2_DATAINV_Field is Interfaces.STM32.Bit;
   subtype CR2_MSBFIRST_Field is Interfaces.STM32.Bit;
   subtype CR2_ABREN_Field is Interfaces.STM32.Bit;
   subtype CR2_ABRMOD_Field is Interfaces.STM32.UInt2;
   subtype CR2_RTOEN_Field is Interfaces.STM32.Bit;
   --  CR2_ADD array element
   subtype CR2_ADD_Element is Interfaces.STM32.UInt4;

   --  CR2_ADD array
   type CR2_ADD_Field_Array is array (0 .. 1) of CR2_ADD_Element
     with Component_Size => 4, Size => 8;

   --  Type definition for CR2_ADD
   type CR2_ADD_Field
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  ADD as a value
            Val : Interfaces.STM32.Byte;
         when True =>
            --  ADD as an array
            Arr : CR2_ADD_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 8;

   for CR2_ADD_Field use record
      Val at 0 range 0 .. 7;
      Arr at 0 range 0 .. 7;
   end record;

   --  Control register 2
   type CR2_Register is record
      --  unspecified
      Reserved_0_3 : Interfaces.STM32.UInt4 := 16#0#;
      --  7-bit Address Detection/4-bit Address Detection
      ADDM7        : CR2_ADDM7_Field := 16#0#;
      --  LIN break detection length
      LBDL         : CR2_LBDL_Field := 16#0#;
      --  LIN break detection interrupt enable
      LBDIE        : CR2_LBDIE_Field := 16#0#;
      --  unspecified
      Reserved_7_7 : Interfaces.STM32.Bit := 16#0#;
      --  Last bit clock pulse
      LBCL         : CR2_LBCL_Field := 16#0#;
      --  Clock phase
      CPHA         : CR2_CPHA_Field := 16#0#;
      --  Clock polarity
      CPOL         : CR2_CPOL_Field := 16#0#;
      --  Clock enable
      CLKEN        : CR2_CLKEN_Field := 16#0#;
      --  STOP bits
      STOP         : CR2_STOP_Field := 16#0#;
      --  LIN mode enable
      LINEN        : CR2_LINEN_Field := 16#0#;
      --  Swap TX/RX pins
      SWAP         : CR2_SWAP_Field := 16#0#;
      --  RX pin active level inversion
      RXINV        : CR2_RXINV_Field := 16#0#;
      --  TX pin active level inversion
      TXINV        : CR2_TXINV_Field := 16#0#;
      --  Binary data inversion
      DATAINV      : CR2_DATAINV_Field := 16#0#;
      --  Most significant bit first
      MSBFIRST     : CR2_MSBFIRST_Field := 16#0#;
      --  Auto baud rate enable
      ABREN        : CR2_ABREN_Field := 16#0#;
      --  Auto baud rate mode
      ABRMOD       : CR2_ABRMOD_Field := 16#0#;
      --  Receiver timeout enable
      RTOEN        : CR2_RTOEN_Field := 16#0#;
      --  Address of the USART node
      ADD          : CR2_ADD_Field := (As_Array => False, Val => 16#0#);
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR2_Register use record
      Reserved_0_3 at 0 range 0 .. 3;
      ADDM7        at 0 range 4 .. 4;
      LBDL         at 0 range 5 .. 5;
      LBDIE        at 0 range 6 .. 6;
      Reserved_7_7 at 0 range 7 .. 7;
      LBCL         at 0 range 8 .. 8;
      CPHA         at 0 range 9 .. 9;
      CPOL         at 0 range 10 .. 10;
      CLKEN        at 0 range 11 .. 11;
      STOP         at 0 range 12 .. 13;
      LINEN        at 0 range 14 .. 14;
      SWAP         at 0 range 15 .. 15;
      RXINV        at 0 range 16 .. 16;
      TXINV        at 0 range 17 .. 17;
      DATAINV      at 0 range 18 .. 18;
      MSBFIRST     at 0 range 19 .. 19;
      ABREN        at 0 range 20 .. 20;
      ABRMOD       at 0 range 21 .. 22;
      RTOEN        at 0 range 23 .. 23;
      ADD          at 0 range 24 .. 31;
   end record;

   subtype CR3_EIE_Field is Interfaces.STM32.Bit;
   subtype CR3_IREN_Field is Interfaces.STM32.Bit;
   subtype CR3_IRLP_Field is Interfaces.STM32.Bit;
   subtype CR3_HDSEL_Field is Interfaces.STM32.Bit;
   subtype CR3_NACK_Field is Interfaces.STM32.Bit;
   subtype CR3_SCEN_Field is Interfaces.STM32.Bit;
   subtype CR3_DMAR_Field is Interfaces.STM32.Bit;
   subtype CR3_DMAT_Field is Interfaces.STM32.Bit;
   subtype CR3_RTSE_Field is Interfaces.STM32.Bit;
   subtype CR3_CTSE_Field is Interfaces.STM32.Bit;
   subtype CR3_CTSIE_Field is Interfaces.STM32.Bit;
   subtype CR3_ONEBIT_Field is Interfaces.STM32.Bit;
   subtype CR3_OVRDIS_Field is Interfaces.STM32.Bit;
   subtype CR3_DDRE_Field is Interfaces.STM32.Bit;
   subtype CR3_DEM_Field is Interfaces.STM32.Bit;
   subtype CR3_DEP_Field is Interfaces.STM32.Bit;
   subtype CR3_SCARCNT_Field is Interfaces.STM32.UInt3;
   subtype CR3_WUS_Field is Interfaces.STM32.UInt2;
   subtype CR3_WUFIE_Field is Interfaces.STM32.Bit;

   --  Control register 3
   type CR3_Register is record
      --  Error interrupt enable
      EIE            : CR3_EIE_Field := 16#0#;
      --  IrDA mode enable
      IREN           : CR3_IREN_Field := 16#0#;
      --  IrDA low-power
      IRLP           : CR3_IRLP_Field := 16#0#;
      --  Half-duplex selection
      HDSEL          : CR3_HDSEL_Field := 16#0#;
      --  Smartcard NACK enable
      NACK           : CR3_NACK_Field := 16#0#;
      --  Smartcard mode enable
      SCEN           : CR3_SCEN_Field := 16#0#;
      --  DMA enable receiver
      DMAR           : CR3_DMAR_Field := 16#0#;
      --  DMA enable transmitter
      DMAT           : CR3_DMAT_Field := 16#0#;
      --  RTS enable
      RTSE           : CR3_RTSE_Field := 16#0#;
      --  CTS enable
      CTSE           : CR3_CTSE_Field := 16#0#;
      --  CTS interrupt enable
      CTSIE          : CR3_CTSIE_Field := 16#0#;
      --  One sample bit method enable
      ONEBIT         : CR3_ONEBIT_Field := 16#0#;
      --  Overrun Disable
      OVRDIS         : CR3_OVRDIS_Field := 16#0#;
      --  DMA Disable on Reception Error
      DDRE           : CR3_DDRE_Field := 16#0#;
      --  Driver enable mode
      DEM            : CR3_DEM_Field := 16#0#;
      --  Driver enable polarity selection
      DEP            : CR3_DEP_Field := 16#0#;
      --  unspecified
      Reserved_16_16 : Interfaces.STM32.Bit := 16#0#;
      --  Smartcard auto-retry count
      SCARCNT        : CR3_SCARCNT_Field := 16#0#;
      --  Wakeup from Stop mode interrupt flag selection
      WUS            : CR3_WUS_Field := 16#0#;
      --  Wakeup from Stop mode interrupt enable
      WUFIE          : CR3_WUFIE_Field := 16#0#;
      --  unspecified
      Reserved_23_31 : Interfaces.STM32.UInt9 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR3_Register use record
      EIE            at 0 range 0 .. 0;
      IREN           at 0 range 1 .. 1;
      IRLP           at 0 range 2 .. 2;
      HDSEL          at 0 range 3 .. 3;
      NACK           at 0 range 4 .. 4;
      SCEN           at 0 range 5 .. 5;
      DMAR           at 0 range 6 .. 6;
      DMAT           at 0 range 7 .. 7;
      RTSE           at 0 range 8 .. 8;
      CTSE           at 0 range 9 .. 9;
      CTSIE          at 0 range 10 .. 10;
      ONEBIT         at 0 range 11 .. 11;
      OVRDIS         at 0 range 12 .. 12;
      DDRE           at 0 range 13 .. 13;
      DEM            at 0 range 14 .. 14;
      DEP            at 0 range 15 .. 15;
      Reserved_16_16 at 0 range 16 .. 16;
      SCARCNT        at 0 range 17 .. 19;
      WUS            at 0 range 20 .. 21;
      WUFIE          at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype BRR_DIV_Fraction_Field is Interfaces.STM32.UInt4;
   subtype BRR_DIV_Mantissa_Field is Interfaces.STM32.UInt12;

   --  Baud rate register
   type BRR_Register is record
      --  fraction of USARTDIV
      DIV_Fraction   : BRR_DIV_Fraction_Field := 16#0#;
      --  mantissa of USARTDIV
      DIV_Mantissa   : BRR_DIV_Mantissa_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for BRR_Register use record
      DIV_Fraction   at 0 range 0 .. 3;
      DIV_Mantissa   at 0 range 4 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype GTPR_PSC_Field is Interfaces.STM32.Byte;
   subtype GTPR_GT_Field is Interfaces.STM32.Byte;

   --  Guard time and prescaler register
   type GTPR_Register is record
      --  Prescaler value
      PSC            : GTPR_PSC_Field := 16#0#;
      --  Guard time value
      GT             : GTPR_GT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : Interfaces.STM32.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for GTPR_Register use record
      PSC            at 0 range 0 .. 7;
      GT             at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype RTOR_RTO_Field is Interfaces.STM32.UInt24;
   subtype RTOR_BLEN_Field is Interfaces.STM32.Byte;

   --  Receiver timeout register
   type RTOR_Register is record
      --  Receiver timeout value
      RTO  : RTOR_RTO_Field := 16#0#;
      --  Block Length
      BLEN : RTOR_BLEN_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RTOR_Register use record
      RTO  at 0 range 0 .. 23;
      BLEN at 0 range 24 .. 31;
   end record;

   subtype RQR_ABRRQ_Field is Interfaces.STM32.Bit;
   subtype RQR_SBKRQ_Field is Interfaces.STM32.Bit;
   subtype RQR_MMRQ_Field is Interfaces.STM32.Bit;
   subtype RQR_RXFRQ_Field is Interfaces.STM32.Bit;
   subtype RQR_TXFRQ_Field is Interfaces.STM32.Bit;

   --  Request register
   type RQR_Register is record
      --  Auto baud rate request
      ABRRQ         : RQR_ABRRQ_Field := 16#0#;
      --  Send break request
      SBKRQ         : RQR_SBKRQ_Field := 16#0#;
      --  Mute mode request
      MMRQ          : RQR_MMRQ_Field := 16#0#;
      --  Receive data flush request
      RXFRQ         : RQR_RXFRQ_Field := 16#0#;
      --  Transmit data flush request
      TXFRQ         : RQR_TXFRQ_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : Interfaces.STM32.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RQR_Register use record
      ABRRQ         at 0 range 0 .. 0;
      SBKRQ         at 0 range 1 .. 1;
      MMRQ          at 0 range 2 .. 2;
      RXFRQ         at 0 range 3 .. 3;
      TXFRQ         at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype ISR_PE_Field is Interfaces.STM32.Bit;
   subtype ISR_FE_Field is Interfaces.STM32.Bit;
   subtype ISR_NF_Field is Interfaces.STM32.Bit;
   subtype ISR_ORE_Field is Interfaces.STM32.Bit;
   subtype ISR_IDLE_Field is Interfaces.STM32.Bit;
   subtype ISR_RXNE_Field is Interfaces.STM32.Bit;
   subtype ISR_TC_Field is Interfaces.STM32.Bit;
   subtype ISR_TXE_Field is Interfaces.STM32.Bit;
   subtype ISR_LBDF_Field is Interfaces.STM32.Bit;
   subtype ISR_CTSIF_Field is Interfaces.STM32.Bit;
   subtype ISR_CTS_Field is Interfaces.STM32.Bit;
   subtype ISR_RTOF_Field is Interfaces.STM32.Bit;
   subtype ISR_EOBF_Field is Interfaces.STM32.Bit;
   subtype ISR_ABRE_Field is Interfaces.STM32.Bit;
   subtype ISR_ABRF_Field is Interfaces.STM32.Bit;
   subtype ISR_BUSY_Field is Interfaces.STM32.Bit;
   subtype ISR_CMF_Field is Interfaces.STM32.Bit;
   subtype ISR_SBKF_Field is Interfaces.STM32.Bit;
   subtype ISR_RWU_Field is Interfaces.STM32.Bit;
   subtype ISR_WUF_Field is Interfaces.STM32.Bit;
   subtype ISR_TEACK_Field is Interfaces.STM32.Bit;
   subtype ISR_REACK_Field is Interfaces.STM32.Bit;

   --  Interrupt & status register
   type ISR_Register is record
      --  Read-only. Parity error
      PE             : ISR_PE_Field;
      --  Read-only. Framing error
      FE             : ISR_FE_Field;
      --  Read-only. Noise detected flag
      NF             : ISR_NF_Field;
      --  Read-only. Overrun error
      ORE            : ISR_ORE_Field;
      --  Read-only. Idle line detected
      IDLE           : ISR_IDLE_Field;
      --  Read-only. Read data register not empty
      RXNE           : ISR_RXNE_Field;
      --  Read-only. Transmission complete
      TC             : ISR_TC_Field;
      --  Read-only. Transmit data register empty
      TXE            : ISR_TXE_Field;
      --  Read-only. LIN break detection flag
      LBDF           : ISR_LBDF_Field;
      --  Read-only. CTS interrupt flag
      CTSIF          : ISR_CTSIF_Field;
      --  Read-only. CTS flag
      CTS            : ISR_CTS_Field;
      --  Read-only. Receiver timeout
      RTOF           : ISR_RTOF_Field;
      --  Read-only. End of block flag
      EOBF           : ISR_EOBF_Field;
      --  unspecified
      Reserved_13_13 : Interfaces.STM32.Bit;
      --  Read-only. Auto baud rate error
      ABRE           : ISR_ABRE_Field;
      --  Read-only. Auto baud rate flag
      ABRF           : ISR_ABRF_Field;
      --  Read-only. Busy flag
      BUSY           : ISR_BUSY_Field;
      --  Read-only. character match flag
      CMF            : ISR_CMF_Field;
      --  Read-only. Send break flag
      SBKF           : ISR_SBKF_Field;
      --  Read-only. Receiver wakeup from Mute mode
      RWU            : ISR_RWU_Field;
      --  Read-only. Wakeup from Stop mode flag
      WUF            : ISR_WUF_Field;
      --  Read-only. Transmit enable acknowledge flag
      TEACK          : ISR_TEACK_Field;
      --  Read-only. Receive enable acknowledge flag
      REACK          : ISR_REACK_Field;
      --  unspecified
      Reserved_23_31 : Interfaces.STM32.UInt9;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ISR_Register use record
      PE             at 0 range 0 .. 0;
      FE             at 0 range 1 .. 1;
      NF             at 0 range 2 .. 2;
      ORE            at 0 range 3 .. 3;
      IDLE           at 0 range 4 .. 4;
      RXNE           at 0 range 5 .. 5;
      TC             at 0 range 6 .. 6;
      TXE            at 0 range 7 .. 7;
      LBDF           at 0 range 8 .. 8;
      CTSIF          at 0 range 9 .. 9;
      CTS            at 0 range 10 .. 10;
      RTOF           at 0 range 11 .. 11;
      EOBF           at 0 range 12 .. 12;
      Reserved_13_13 at 0 range 13 .. 13;
      ABRE           at 0 range 14 .. 14;
      ABRF           at 0 range 15 .. 15;
      BUSY           at 0 range 16 .. 16;
      CMF            at 0 range 17 .. 17;
      SBKF           at 0 range 18 .. 18;
      RWU            at 0 range 19 .. 19;
      WUF            at 0 range 20 .. 20;
      TEACK          at 0 range 21 .. 21;
      REACK          at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   subtype ICR_PECF_Field is Interfaces.STM32.Bit;
   subtype ICR_FECF_Field is Interfaces.STM32.Bit;
   subtype ICR_NCF_Field is Interfaces.STM32.Bit;
   subtype ICR_ORECF_Field is Interfaces.STM32.Bit;
   subtype ICR_IDLECF_Field is Interfaces.STM32.Bit;
   subtype ICR_TCCF_Field is Interfaces.STM32.Bit;
   subtype ICR_LBDCF_Field is Interfaces.STM32.Bit;
   subtype ICR_CTSCF_Field is Interfaces.STM32.Bit;
   subtype ICR_RTOCF_Field is Interfaces.STM32.Bit;
   subtype ICR_EOBCF_Field is Interfaces.STM32.Bit;
   subtype ICR_CMCF_Field is Interfaces.STM32.Bit;
   subtype ICR_WUCF_Field is Interfaces.STM32.Bit;

   --  Interrupt flag clear register
   type ICR_Register is record
      --  Parity error clear flag
      PECF           : ICR_PECF_Field := 16#0#;
      --  Framing error clear flag
      FECF           : ICR_FECF_Field := 16#0#;
      --  Noise detected clear flag
      NCF            : ICR_NCF_Field := 16#0#;
      --  Overrun error clear flag
      ORECF          : ICR_ORECF_Field := 16#0#;
      --  Idle line detected clear flag
      IDLECF         : ICR_IDLECF_Field := 16#0#;
      --  unspecified
      Reserved_5_5   : Interfaces.STM32.Bit := 16#0#;
      --  Transmission complete clear flag
      TCCF           : ICR_TCCF_Field := 16#0#;
      --  unspecified
      Reserved_7_7   : Interfaces.STM32.Bit := 16#0#;
      --  LIN break detection clear flag
      LBDCF          : ICR_LBDCF_Field := 16#0#;
      --  CTS clear flag
      CTSCF          : ICR_CTSCF_Field := 16#0#;
      --  unspecified
      Reserved_10_10 : Interfaces.STM32.Bit := 16#0#;
      --  Receiver timeout clear flag
      RTOCF          : ICR_RTOCF_Field := 16#0#;
      --  End of timeout clear flag
      EOBCF          : ICR_EOBCF_Field := 16#0#;
      --  unspecified
      Reserved_13_16 : Interfaces.STM32.UInt4 := 16#0#;
      --  Character match clear flag
      CMCF           : ICR_CMCF_Field := 16#0#;
      --  unspecified
      Reserved_18_19 : Interfaces.STM32.UInt2 := 16#0#;
      --  Wakeup from Stop mode clear flag
      WUCF           : ICR_WUCF_Field := 16#0#;
      --  unspecified
      Reserved_21_31 : Interfaces.STM32.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for ICR_Register use record
      PECF           at 0 range 0 .. 0;
      FECF           at 0 range 1 .. 1;
      NCF            at 0 range 2 .. 2;
      ORECF          at 0 range 3 .. 3;
      IDLECF         at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      TCCF           at 0 range 6 .. 6;
      Reserved_7_7   at 0 range 7 .. 7;
      LBDCF          at 0 range 8 .. 8;
      CTSCF          at 0 range 9 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      RTOCF          at 0 range 11 .. 11;
      EOBCF          at 0 range 12 .. 12;
      Reserved_13_16 at 0 range 13 .. 16;
      CMCF           at 0 range 17 .. 17;
      Reserved_18_19 at 0 range 18 .. 19;
      WUCF           at 0 range 20 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   subtype RDR_RDR_Field is Interfaces.STM32.UInt9;

   --  Receive data register
   type RDR_Register is record
      --  Read-only. Receive data value
      RDR           : RDR_RDR_Field;
      --  unspecified
      Reserved_9_31 : Interfaces.STM32.UInt23;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RDR_Register use record
      RDR           at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   subtype TDR_TDR_Field is Interfaces.STM32.UInt9;

   --  Transmit data register
   type TDR_Register is record
      --  Transmit data value
      TDR           : TDR_TDR_Field := 16#0#;
      --  unspecified
      Reserved_9_31 : Interfaces.STM32.UInt23 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for TDR_Register use record
      TDR           at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Universal synchronous asynchronous receiver-transmitter
   type USART_Peripheral is record
      --  Control register 1
      CR1  : aliased CR1_Register;
      --  Control register 2
      CR2  : aliased CR2_Register;
      --  Control register 3
      CR3  : aliased CR3_Register;
      --  Baud rate register
      BRR  : aliased BRR_Register;
      --  Guard time and prescaler register
      GTPR : aliased GTPR_Register;
      --  Receiver timeout register
      RTOR : aliased RTOR_Register;
      --  Request register
      RQR  : aliased RQR_Register;
      --  Interrupt & status register
      ISR  : aliased ISR_Register;
      --  Interrupt flag clear register
      ICR  : aliased ICR_Register;
      --  Receive data register
      RDR  : aliased RDR_Register;
      --  Transmit data register
      TDR  : aliased TDR_Register;
   end record
     with Volatile;

   for USART_Peripheral use record
      CR1  at 16#0# range 0 .. 31;
      CR2  at 16#4# range 0 .. 31;
      CR3  at 16#8# range 0 .. 31;
      BRR  at 16#C# range 0 .. 31;
      GTPR at 16#10# range 0 .. 31;
      RTOR at 16#14# range 0 .. 31;
      RQR  at 16#18# range 0 .. 31;
      ISR  at 16#1C# range 0 .. 31;
      ICR  at 16#20# range 0 .. 31;
      RDR  at 16#24# range 0 .. 31;
      TDR  at 16#28# range 0 .. 31;
   end record;

   --  Universal synchronous asynchronous receiver-transmitter
   USART1_Periph : aliased USART_Peripheral
     with Import, Address => USART1_Base;

   --  Universal synchronous asynchronous receiver-transmitter
   USART2_Periph : aliased USART_Peripheral
     with Import, Address => USART2_Base;

   --  Universal synchronous asynchronous receiver-transmitter
   USART3_Periph : aliased USART_Peripheral
     with Import, Address => USART3_Base;

end Interfaces.STM32.USART;
