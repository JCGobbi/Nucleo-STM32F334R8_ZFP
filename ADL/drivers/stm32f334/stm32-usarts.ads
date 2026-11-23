------------------------------------------------------------------------------
--                                                                          --
--                  Copyright (C) 2015-2016, AdaCore                        --
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
--     3. Neither the name of STMicroelectronics nor the names of its       --
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
--                                                                          --
--  This file is based on:                                                  --
--                                                                          --
--   @file    stm32f4xx_hal_usart.h                                         --
--   @author  MCD Application Team                                          --
--   @version V1.1.0                                                        --
--   @date    19-June-2014                                                  --
--   @brief   Header file of USARTS HAL module.                             --
--                                                                          --
--   COPYRIGHT(c) 2014 STMicroelectronics                                   --
------------------------------------------------------------------------------

--  This file provides register definitions for the STM32F3 (ARM Cortex M4F)
--  USART from ST Microelectronics.

--  Note that there are board implementation assumptions represented by the
--  private function APB_Clock.

with System;
with HAL.UART; use HAL.UART;
private with STM32_SVD.USART;

package STM32.USARTs is

   type Internal_USART is limited private;

   type USART (Periph : not null access Internal_USART) is
     limited new HAL.UART.UART_Port with private;

   procedure Enable (This : in out USART) with
     Post => Enabled (This),
     Inline;

   procedure Disable (This : in out USART) with
     Post => not Enabled (This),
     Inline;

   function Enabled (This : USART) return Boolean with Inline;

   procedure Receive (This : USART;  Data : out UInt9) with Inline;
   --  reads Device.DR into Data

   function Current_Input (This : USART) return UInt9 with Inline;
   --  returns Device.DR

   procedure Transmit (This : in out USART;  Data : UInt9) with Inline;

   function Tx_Ready (This : USART) return Boolean with Inline;

   function Rx_Ready (This : USART) return Boolean with Inline;

   type Stop_Bits is (Stopbits_1, Stopbits_2) with Size => 2;

   for Stop_Bits use (Stopbits_1 => 0, Stopbits_2 => 2#10#);

   procedure Set_Stop_Bits (This : in out USART;  To : Stop_Bits);

   type Word_Lengths is (Word_Length_7, Word_Length_8, Word_Length_9);

   procedure Set_Word_Length (This : in out USART;  To : Word_Lengths);

   type Parities is (No_Parity, Even_Parity, Odd_Parity);

   procedure Set_Parity (This : in out USART;  To : Parities);

   subtype Baud_Rates is UInt32;

   procedure Set_Baud_Rate (This : in out USART;  To : Baud_Rates);
   --  There is no fractional baud rate generator. When OVER8 = 0 (16x
   --  oversampling), USARTDIV [15:0] = BRR [15:0] = fCK/baud rate. When
   --  OVER8 = 1 (8x oversampling), USARTDIV [15:0] = 2*fCK/baud rate but
   --  BRR [15:4] = USARTDIV [15:4] and BRR [3:0] = USARTDIV [3:0] shifted 1 bit
   --  to the right, so BRR [3] = 0.

   type Oversampling_Modes is (Oversampling_By_8, Oversampling_By_16);
   --  oversampling by 16 is the default

   procedure Set_Oversampling_Mode
     (This : in out USART;
      To   : Oversampling_Modes);

   type UART_Modes is (Rx_Mode, Tx_Mode, Tx_Rx_Mode);

   procedure Set_Mode (This : in out USART;  To : UART_Modes);

   type Flow_Control is
     (No_Flow_Control,
      RTS_Flow_Control,
      CTS_Flow_Control,
      RTS_CTS_Flow_Control);

   procedure Set_Flow_Control (This : in out USART; To : Flow_Control);

   type Auto_BaudRate_Mode is
     (Falling_To_Rising,  --  Duration of start bit
      Falling_To_Falling, --  10xx pattern, start bit + first data bit
      Char_0x7F,          --  0x7F character frame
      Char_0x55);         --  0x55 character frame

   procedure Configure_Auto_BaudRate
     (This : in out USART;
      Mode : Auto_BaudRate_Mode)
     with Pre => not Enabled (This);
   --  Select the mode of auto baud rate: duration of start bit, start + first
   --  data bit duration, 0x7F character or 0x55 character. The autobaud rate
   --  function must be disabled before change.

   procedure Set_Auto_BaudRate (This : in out USART; Enabled : Boolean);
   --  Enable/disable auto baud rate detection.

   procedure Request_Auto_BaudRate (This : in out USART);
   --  Request an auto baud rate measurement on the next received data frame.

   type Bit_Order is
     (LSB_First,  --  data is transmitted/received with data bit 0 first
      MSB_First); --  data is transmitted/received with data bit 7/8 first

   procedure Set_Bit_Order (This : in out USART; Order : Bit_Order)
     with Pre => not Enabled (This);
   --  Select to send/receive data with LSB (bit 0) first or MSB (bit 6/7) first.

   procedure Swap_Tx_Rx_Pins (This : in out USART; Swap : Boolean)
     with Pre => not Enabled (This);
   --  Swap Tx with Rx pins.

   type Data_Inversion_Type is
     (Logical_Data,
      Hardware_Tx_Pin,
      Hardware_Rx_Pin);

   procedure Set_Data_Inversion
     (This     : in out USART;
      Mode     : Data_Inversion_Type;
      Inverted : Boolean)
     with Pre => not Enabled (This);
   --  Select positive/direct or negative/invert binary data sent/received
   --  from/to data register or Tx/Rx pins active level.

   procedure Set_Half_Duplex_Mode (This : in out USART; Half : Boolean)
     with Pre => not Enabled (This);
   --  Selection of Single-wire Half-duplex mode.

   type Break_Detection_Length is (Bits_10, Bits_11);
   --  LIN break detection length selection, 10-bit or 11-bit break threshold.

   procedure Set_Break_Detection_Length
     (This   : in out USART;
      Length : Break_Detection_Length);
   --  LIN break detection length selection between 10-bit and 11-bit break.
   --  A slave node shall use a break detection threshold of 11 dominant local
   --  slave bit times. Slave nodes with a bit rate tolerance better than 14%,
   --  (typically a crystal or ceramic resonator) may use a 9.5 dominant nominal
   --  bit times break detection threshold. It is not required that a slave node
   --  checks that the break delimiter is at least one nominal bit time long.
   --  See LIN Specification Package revision 2.2A, section 2.3.1.1 Break Field.

   procedure Request_Send_Break (This : in out USART);
   --  Setting the SBK bit sends 13‘0 bits as a break character. Then a bit of
   --  value 1 is sent to allow the next start detection. In total, the break
   --  field will take 14 bits time. It can be set and cleared by software.
   --  It should be set by software, and will be reset by hardware during the
   --  stop bit of break.

   procedure Configure_Receiver_Timeout
     (This  : in out USART;
      Value : UInt24);
   --  Save the Receiver timeout value in terms of number of bits during which
   --  there is no activity on the RX line. In standard mode, the RTOF flag is
   --  set if, after the last received character, no new start bit is detected
   --  for more than the RTO value.

   procedure Set_Receiver_Timeout
     (This    : in out USART;
      Timeout : Boolean);
   --  Enable/disable Receiver timeout during which there is no activity on the
   --  RX line. When the receive line is idle for this duration, after the last
   --  stop bit is received, an interrupt is generated, if enabled, informing
   --  the software that the current block reception is completed.

   type USART_Mode is (Normal, Modbus_RTU, Modbus_ASCII, LIN);

   procedure Configure_Usart_Mode
     (This : in out USART;
      Mode : USART_Mode;
      Data : UInt24 := 16#000000#)
     with Pre => not Enabled (This);
   --  For Modbus RTU mode, the timeout of 2 character times is programmed. If
   --  the character has 11 bits, then program value 22 (16#16#). For LIN, this
   --  will be the Response timeout. When the receive line is idle for this
   --  duration, after the last stop bit is received, an interrupt is generated,
   --  if enabled, informing the software that the current block reception is
   --  completed. For Modbus ASCII mode, there is no need to program timeout.
   --  See chapter 37.5.11 at pg. 1620 in RM0440 rev. 6.
   --  For LIN mode, See chapter 37.5.13 at pg. 1622 in RM0440 rev. 6.

   type USART_Interrupt is
     (End_Of_Block,
      Receiver_Timeout,
      Character_Match,
      Parity_Error,
      Transmit_Data_Register_Empty,
      Transmission_Complete,
      Received_Data_Not_Empty,
      Idle_Line_Detection,
      LIN_Break_Detection,
      Clear_To_Send,
      Error);

   procedure Enable_Interrupts
     (This   : in out USART;
      Source : USART_Interrupt)
     with
       Post => Interrupt_Enabled (This, Source),
       Inline;

   procedure Disable_Interrupts
     (This   : in out USART;
      Source : USART_Interrupt)
     with
       Post => not Interrupt_Enabled (This, Source),
        Inline;

   function Interrupt_Enabled
     (This   : USART;
      Source : USART_Interrupt)
      return Boolean
     with Inline;

   type USART_Status_Flag is
     (End_Of_Block_Indicated,
      Receiver_Timeout_Indicated,
      Character_Match_Indicated,
      Parity_Error_Indicated,
      Framing_Error_Indicated,
      USART_Noise_Error_Indicated,
      Overrun_Error_Indicated,
      Idle_Line_Detection_Indicated,
      Read_Data_Register_Not_Empty,
      Transmission_Complete_Indicated,
      Transmit_Data_Register_Empty,
      LIN_Break_Detection_Indicated,
      Clear_To_Send_Indicated,
      Auto_Baud_Rate_Error_Indicated);

   function Status (This : USART; Flag : USART_Status_Flag) return Boolean
     with Inline;

   procedure Clear_Status (This : in out USART; Flag : USART_Status_Flag)
     with Inline;

   procedure Enable_DMA_Transmit_Requests (This : in out USART) with
     Inline,
     Post => DMA_Transmit_Requests_Enabled (This);

   procedure Disable_DMA_Transmit_Requests (This : in out USART) with
     Inline,
     Post => not DMA_Transmit_Requests_Enabled (This);

   function DMA_Transmit_Requests_Enabled  (This : USART) return Boolean with
     Inline;

   procedure Enable_DMA_Receive_Requests (This : in out USART) with
     Inline,
     Post => DMA_Receive_Requests_Enabled (This);

   procedure Disable_DMA_Receive_Requests (This : in out USART) with
     Inline,
     Post => not DMA_Receive_Requests_Enabled (This);

   function DMA_Receive_Requests_Enabled  (This : USART) return Boolean with
     Inline;

   procedure Pause_DMA_Transmission (This : in out USART)
     renames Disable_DMA_Transmit_Requests;

   procedure Resume_DMA_Transmission (This : in out USART) with
     Inline,
     Post => DMA_Transmit_Requests_Enabled (This) and
             Enabled (This);

   procedure Pause_DMA_Reception (This : in out USART)
     renames Disable_DMA_Receive_Requests;

   procedure Resume_DMA_Reception (This : in out USART) with
     Inline,
     Post => DMA_Receive_Requests_Enabled (This) and
             Enabled (This);

   function Read_Data_Register_Address (This : USART) return System.Address with
     Inline;
   function Transmit_Data_Register_Address (This : USART) return System.Address with
     Inline;
   --  Returns the address of the USART Data Register. This is exported
   --  STRICTLY for the sake of clients driving a USART via DMA. All other
   --  clients of this package should use the procedural interfaces Transmit
   --  and Receive instead of directly accessing the Data Register!
   --  Seriously, don't use this function otherwise.

   -----------------------------
   -- HAL.UART implementation --
   -----------------------------

   overriding
   function Data_Size (This : USART) return HAL.UART.UART_Data_Size;

   overriding
   procedure Transmit
     (This    : in out USART;
      Data    : UART_Data_7b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
     with
       Pre'Class => Data_Size (This) = Data_Size_7b;

   overriding
   procedure Transmit
     (This    : in out USART;
      Data    : UART_Data_8b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
     with
       Pre'Class => Data_Size (This) = Data_Size_8b;

   overriding
   procedure Transmit
     (This    : in out USART;
      Data    : UART_Data_9b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
     with
       Pre'Class => Data_Size (This) = Data_Size_9b;

   overriding
   procedure Receive
     (This    : in out USART;
      Data    : out UART_Data_7b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
     with
       Pre'Class => Data_Size (This) = Data_Size_7b;

   overriding
   procedure Receive
     (This    : in out USART;
      Data    : out UART_Data_8b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
     with
       Pre'Class => Data_Size (This) = Data_Size_8b;

   overriding
   procedure Receive
     (This    : in out USART;
      Data    : out UART_Data_9b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
     with
       Pre'Class => Data_Size (This) = Data_Size_9b;

private

   function APB_Clock (This : USART) return UInt32 with Inline;
   --  Returns either APB1 or APB2 clock rate, in Hertz, depending on the
   --  USART. For the sake of not making this package board-specific, we assume
   --  that we are given a valid USART object at a valid address, AND that the
   --  USART devices really are configured such that only 1 and 6 are on APB2.
   --  Therefore, if a board has additional USARTs beyond USART6, eg USART8 on
   --  the F429I Discovery board, they better conform to that assumption.
   --  See Note # 2 in each of Tables 139-141 of the RM on pages 970 - 972.

   type Internal_USART is new STM32_SVD.USART.USART_Peripheral;

   type USART (Periph : not null access Internal_USART) is
     limited new HAL.UART.UART_Port with null record;

end STM32.USARTs;
