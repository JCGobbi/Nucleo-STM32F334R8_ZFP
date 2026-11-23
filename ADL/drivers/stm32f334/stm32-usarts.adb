------------------------------------------------------------------------------
--                                                                          --
--                  Copyright (C) 2015-2017, AdaCore                        --
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
--   @file    stm32f4xx_hal_usart.c                                         --
--   @author  MCD Application Team                                          --
--   @version V1.1.0                                                        --
--   @date    19-June-2014                                                  --
--   @brief   USARTS HAL module driver.                                     --
--                                                                          --
--   COPYRIGHT(c) 2014 STMicroelectronics                                   --
------------------------------------------------------------------------------

with System;          use System;
with STM32_SVD.USART; use STM32_SVD.USART, STM32_SVD;

with STM32.Device;

package body STM32.USARTs is

   ---------------
   -- APB_Clock --
   ---------------

   function APB_Clock (This : USART) return UInt32 is
      use STM32.Device;
      Clocks : constant RCC_System_Clocks := System_Clock_Frequencies;
   begin
      if This.Periph.all'Address = USART1_Base
      then
         return Clocks.PCLK2;
      else
         return Clocks.PCLK1;
      end if;
   end APB_Clock;

   ------------
   -- Enable --
   ------------

   procedure Enable (This : in out USART) is
   begin
      This.Periph.CR1.UE := True;
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable (This : in out USART) is
   begin
      This.Periph.CR1.UE := False;
   end Disable;

   -------------
   -- Enabled --
   -------------

   function Enabled (This : USART) return Boolean is
     (This.Periph.CR1.UE);

   -------------------
   -- Set_Stop_Bits --
   -------------------

   procedure Set_Stop_Bits (This : in out USART; To : Stop_Bits)
   is
   begin
      This.Periph.CR2.STOP := Stop_Bits'Enum_Rep (To);
   end Set_Stop_Bits;

   ---------------------
   -- Set_Word_Length --
   ---------------------

   procedure Set_Word_Length
     (This : in out USART;
      To : Word_Lengths)
   is
   begin
      case To is
         when Word_Length_7 =>
            This.Periph.CR1.M0 := False;
            This.Periph.CR1.M1 := True;
         when Word_Length_8 =>
            This.Periph.CR1.M0 := False;
            This.Periph.CR1.M1 := False;
         when Word_Length_9 =>
            This.Periph.CR1.M0 := True;
            This.Periph.CR1.M1 := False;
      end case;
   end Set_Word_Length;

   ----------------
   -- Set_Parity --
   ----------------

   procedure Set_Parity (This : in out USART; To : Parities) is
   begin
      case To is
         when No_Parity =>
            This.Periph.CR1.PCE := False;
            This.Periph.CR1.PS  := False;
         when Even_Parity =>
            This.Periph.CR1.PCE := True;
            This.Periph.CR1.PS  := False;
         when Odd_Parity =>
            This.Periph.CR1.PCE := True;
            This.Periph.CR1.PS  := True;
      end case;
   end Set_Parity;

   -------------------
   -- Set_Baud_Rate --
   -------------------

   procedure Set_Baud_Rate (This : in out USART; To : Baud_Rates)
   is
      Clock        : constant UInt32 := APB_Clock (This);
      Over_By_8    : constant Boolean := This.Periph.CR1.OVER8;
      Int_Scale    : constant UInt32 := (if Over_By_8 then 2 else 1);
      --  Rounding instead of truncating.
      Int_Divider  : constant UInt32 := (10 * Int_Scale * Clock + 5) / (10 * To);
      --  There is no fractional divider, so the actual Frac_Divider is the
      --  4 LSB of Int_Divider.
      Frac_Divider : constant UInt32 := Int_Divider and 16#000F#;
   begin
      if Over_By_8 then
         This.Periph.BRR.DIV_Fraction :=
           BRR_DIV_Fraction_Field (Shift_Right (Frac_Divider, 1));
      else
         This.Periph.BRR.DIV_Fraction :=
           BRR_DIV_Fraction_Field (Frac_Divider);
      end if;

      This.Periph.BRR.DIV_Mantissa :=
        BRR_DIV_Mantissa_Field (Shift_Right (Int_Divider, 4));
   end Set_Baud_Rate;

   ---------------------------
   -- Set_Oversampling_Mode --
   ---------------------------

   procedure Set_Oversampling_Mode
     (This : in out USART;
      To   : Oversampling_Modes)
   is
   begin
      This.Periph.CR1.OVER8 := To = Oversampling_By_8;
   end Set_Oversampling_Mode;

   --------------
   -- Set_Mode --
   --------------

   procedure Set_Mode (This : in out USART;  To : UART_Modes) is
   begin
      This.Periph.CR1.RE := To /= Tx_Mode;
      This.Periph.CR1.TE := To /= Rx_Mode;
   end Set_Mode;

   ----------------------
   -- Set_Flow_Control --
   ----------------------

   procedure Set_Flow_Control (This : in out USART;  To : Flow_Control) is
   begin
      case To is
         when No_Flow_Control =>
            This.Periph.CR3.RTSE := False;
            This.Periph.CR3.CTSE := False;
         when RTS_Flow_Control =>
            This.Periph.CR3.RTSE := True;
            This.Periph.CR3.CTSE := False;
         when CTS_Flow_Control =>
            This.Periph.CR3.RTSE := False;
            This.Periph.CR3.CTSE := True;
         when RTS_CTS_Flow_Control =>
            This.Periph.CR3.RTSE := True;
            This.Periph.CR3.CTSE := True;
      end case;
   end Set_Flow_Control;

   ---------
   -- Put --
   ---------

   procedure Transmit (This : in out USART;  Data : UInt9) is
   begin
      This.Periph.TDR.TDR := Data;
   end Transmit;

   ---------
   -- Get --
   ---------

   procedure Receive (This : USART;  Data : out UInt9) is
   begin
      Data := Current_Input (This);
   end Receive;

   -------------------
   -- Current_Input --
   -------------------

   function Current_Input (This : USART) return UInt9 is
     (This.Periph.RDR.RDR);

   --------------
   -- Tx_Ready --
   --------------

   function Tx_Ready (This : USART) return Boolean is
   begin
      return This.Periph.ISR.TXE;
   end Tx_Ready;

   --------------
   -- Rx_Ready --
   --------------

   function Rx_Ready (This : USART) return Boolean is
   begin
      return This.Periph.ISR.RXNE;
   end Rx_Ready;

   -----------------------------
   -- Configure_Auto_BaudRate --
   -----------------------------

   procedure Configure_Auto_BaudRate
     (This : in out USART;
      Mode : Auto_BaudRate_Mode) is
   begin
      This.Periph.CR2.ABRMOD.Val := Mode'Enum_Rep;
   end Configure_Auto_BaudRate;

   -----------------------
   -- Set_Auto_BaudRate --
   -----------------------

   procedure Set_Auto_BaudRate (This : in out USART; Enabled : Boolean) is
   begin
      This.Periph.CR2.ABREN := Enabled;
   end Set_Auto_BaudRate;

   ---------------------------
   -- Request_Auto_BaudRate --
   ---------------------------

   procedure Request_Auto_BaudRate (This : in out USART) is
   begin
      This.Periph.RQR.ABRRQ := True;
   end Request_Auto_BaudRate;

   -------------------
   -- Set_Bit_Order --
   -------------------

   procedure Set_Bit_Order (This : in out USART; Order : Bit_Order) is
   begin
      This.Periph.CR2.MSBFIRST := Order = MSB_First;
   end Set_Bit_Order;

   ---------------------
   -- Swap_Tx_Rx_Pins --
   ---------------------

   procedure Swap_Tx_Rx_Pins (This : in out USART; Swap : Boolean) is
   begin
      This.Periph.CR2.SWAP := Swap;
   end Swap_Tx_Rx_Pins;

   ------------------------
   -- Set_Data_Inversion --
   ------------------------

   procedure Set_Data_Inversion
     (This     : in out USART;
      Mode     : Data_Inversion_Type;
      Inverted : Boolean) is
   begin
      case Mode is
         when Logical_Data =>
            This.Periph.CR2.DATAINV := Inverted;
         when Hardware_Tx_Pin =>
            This.Periph.CR2.TXINV := Inverted;
         when Hardware_Rx_Pin =>
            This.Periph.CR2.RXINV := Inverted;
      end case;
   end Set_Data_Inversion;

   --------------------------
   -- Set_Half_Duplex_Mode --
   --------------------------

   procedure Set_Half_Duplex_Mode (This : in out USART; Half : Boolean) is
   begin
      This.Periph.CR3.HDSEL := Half;
   end Set_Half_Duplex_Mode;

   --------------------------------
   -- Set_Break_Detection_Length --
   --------------------------------

   procedure Set_Break_Detection_Length
     (This   : in out USART;
      Length : Break_Detection_Length) is
   begin
      This.Periph.CR2.LBDL := Length = Bits_11;
   end Set_Break_Detection_Length;

   ------------------------
   -- Request_Send_Break --
   ------------------------

   procedure Request_Send_Break (This : in out USART) is
   begin
      This.Periph.RQR.SBKRQ := True;
   end Request_Send_Break;

   --------------------------------
   -- Configure_Receiver_Timeout --
   --------------------------------

   procedure Configure_Receiver_Timeout
     (This  : in out USART;
      Value : UInt24) is
   begin
      This.Periph.RTOR.RTO := Value;
   end Configure_Receiver_Timeout;

   --------------------------
   -- Set_Receiver_Timeout --
   --------------------------

   procedure Set_Receiver_Timeout
     (This    : in out USART;
      Timeout : Boolean) is
   begin
      This.Periph.CR2.RTOEN := Timeout;
   end Set_Receiver_Timeout;

   --------------------------
   -- Configure_Usart_Mode --
   --------------------------

   procedure Configure_Usart_Mode
     (This : in out USART;
      Mode : USART_Mode;
      Data : UInt24 := 16#000000#)
   is
      --  In Modbus ASCII, the end of a block is recognized by a specific
      --  (CR/LF) character sequence. Then we set LF ASCII character (16#0A#).
      End_Char : constant UInt8 := 16#0A#;
   begin
      if Mode /= Normal then
         --  Modbus and LIN are half-duplex protocols
         This.Periph.CR3.HDSEL := True;
         --  Program number of bits for Receiver timeout and enable it.
         This.Periph.RTOR.RTO := Data;
         This.Periph.CR2.RTOEN := True;

         if Mode = Modbus_ASCII then
            --  For Modbus ASCII mode, the LF ASCII character (16#0A#) of the
            --  end of block sequence (CR/LF) is programmed. When the character
            --  match occurs, an interrupt is generated if enabled.
            This.Periph.CR2.ADD.Val := End_Char;
         elsif Mode = LIN then
            --  Disable CK pin
            This.Periph.CR2.CLKEN := False;
            --  Disable smartcard mode
            This.Periph.CR3.SCEN := False;
            --  Disable IrDA mode
            This.Periph.CR3.IREN := False;
            --  Enable LIN mode
            This.Periph.CR2.LINEN := True;
         end if;

      else --  Normal USART communication mode
         This.Periph.CR2.LINEN := False;
         --  Disable half-duplex mode
         This.Periph.CR3.HDSEL := False;
         --  Disable Receiver timeout
         This.Periph.CR2.RTOEN := False;
      end if;

   end Configure_Usart_Mode;

   -----------------------
   -- Enable_Interrupts --
   -----------------------

   procedure Enable_Interrupts
     (This   : in out USART;
      Source : USART_Interrupt)
   is
   begin
      case Source is
         when End_Of_Block =>
            This.Periph.CR1.EOBIE := True;
         when Receiver_Timeout =>
            This.Periph.CR1.RTOIE := True;
         when Character_Match =>
            This.Periph.CR1.CMIE := True;
         when Parity_Error =>
            This.Periph.CR1.PEIE := True;
         when Transmit_Data_Register_Empty =>
            This.Periph.CR1.TXEIE := True;
         when Transmission_Complete =>
            This.Periph.CR1.TCIE := True;
         when Received_Data_Not_Empty =>
            This.Periph.CR1.RXNEIE := True;
         when Idle_Line_Detection =>
            This.Periph.CR1.IDLEIE := True;
         when LIN_Break_Detection =>
            This.Periph.CR2.LBDIE := True;
         when Clear_To_Send =>
            This.Periph.CR3.CTSIE := True;
         when Error =>
            This.Periph.CR3.EIE := True;
      end case;
   end Enable_Interrupts;

   ------------------------
   -- Disable_Interrupts --
   ------------------------

   procedure Disable_Interrupts
     (This   : in out USART;
      Source : USART_Interrupt)
   is
   begin
      case Source is
         when End_Of_Block =>
            This.Periph.CR1.EOBIE := False;
         when Receiver_Timeout =>
            This.Periph.CR1.RTOIE := False;
         when Character_Match =>
            This.Periph.CR1.CMIE := False;
         when Parity_Error =>
            This.Periph.CR1.PEIE := False;
         when Transmit_Data_Register_Empty =>
            This.Periph.CR1.TXEIE := False;
         when Transmission_Complete =>
            This.Periph.CR1.TCIE := False;
         when Received_Data_Not_Empty =>
            This.Periph.CR1.RXNEIE := False;
         when Idle_Line_Detection =>
            This.Periph.CR1.IDLEIE := False;
         when LIN_Break_Detection =>
            This.Periph.CR2.LBDIE := False;
         when Clear_To_Send =>
            This.Periph.CR3.CTSIE := False;
         when Error =>
            This.Periph.CR3.EIE := False;
      end case;
   end Disable_Interrupts;

   -----------------------
   -- Interrupt_Enabled --
   -----------------------

   function Interrupt_Enabled
     (This   : USART;
      Source : USART_Interrupt)
      return Boolean
   is
   begin
      case Source is
         when End_Of_Block =>
            return This.Periph.CR1.EOBIE;
         when Receiver_Timeout =>
            return This.Periph.CR1.RTOIE;
         when Character_Match =>
            return This.Periph.CR1.CMIE;
         when Parity_Error =>
            return This.Periph.CR1.PEIE;
         when Transmit_Data_Register_Empty =>
            return This.Periph.CR1.TXEIE;
         when Transmission_Complete =>
            return This.Periph.CR1.TCIE;
         when Received_Data_Not_Empty =>
            return This.Periph.CR1.RXNEIE;
         when Idle_Line_Detection =>
            return This.Periph.CR1.IDLEIE;
         when LIN_Break_Detection =>
            return This.Periph.CR2.LBDIE;
         when Clear_To_Send =>
            return This.Periph.CR3.CTSIE;
         when Error =>
            return This.Periph.CR3.EIE;
      end case;
   end Interrupt_Enabled;

   ------------
   -- Status --
   ------------

   function Status (This : USART; Flag : USART_Status_Flag) return Boolean is
   begin
      case Flag is
         when End_Of_Block_Indicated =>
            return This.Periph.ISR.EOBF;
         when Receiver_Timeout_Indicated =>
            return This.Periph.ISR.RTOF;
         when Character_Match_Indicated =>
            return This.Periph.ISR.CMF;
         when Parity_Error_Indicated =>
            return This.Periph.ISR.PE;
         when Framing_Error_Indicated =>
            return This.Periph.ISR.FE;
         when USART_Noise_Error_Indicated =>
            return This.Periph.ISR.NF;
         when Overrun_Error_Indicated =>
            return This.Periph.ISR.ORE;
         when Idle_Line_Detection_Indicated =>
            return This.Periph.ISR.IDLE;
         when Read_Data_Register_Not_Empty =>
            return This.Periph.ISR.RXNE;
         when Transmission_Complete_Indicated =>
            return This.Periph.ISR.TC;
         when Transmit_Data_Register_Empty =>
            return This.Periph.ISR.TXE;
         when LIN_Break_Detection_Indicated =>
            return This.Periph.ISR.LBDF;
         when Clear_To_Send_Indicated =>
            return This.Periph.ISR.CTS;
         when Auto_Baud_Rate_Error_Indicated =>
            return This.Periph.ISR.ABRE;
      end case;
   end Status;

   ------------------
   -- Clear_Status --
   ------------------

   procedure Clear_Status (This : in out USART;  Flag : USART_Status_Flag) is
   begin
      case Flag is
         when End_Of_Block_Indicated =>
            This.Periph.ICR.EOBCF := True;
         when Receiver_Timeout_Indicated =>
            This.Periph.ICR.RTOCF := True;
         when Character_Match_Indicated =>
            This.Periph.ICR.CMCF := True;
         when Parity_Error_Indicated =>
            This.Periph.ICR.PECF := True;
         when Framing_Error_Indicated =>
            This.Periph.ICR.FECF := True;
         when USART_Noise_Error_Indicated =>
            This.Periph.ICR.NCF := True;
         when Overrun_Error_Indicated =>
            This.Periph.ICR.ORECF := True;
         when Idle_Line_Detection_Indicated =>
            This.Periph.ICR.IDLECF := True;
         when Read_Data_Register_Not_Empty =>
            null; --  Cleared by a read to the RDR register
         when Transmission_Complete_Indicated =>
            This.Periph.ICR.TCCF := True;
         when Transmit_Data_Register_Empty =>
            null; --  Cleared by a write to TDR register
         when LIN_Break_Detection_Indicated =>
            This.Periph.ICR.LBDCF := True;
         when Clear_To_Send_Indicated =>
            This.Periph.ICR.CTSCF := True;
         when Auto_Baud_Rate_Error_Indicated =>
            null; --  Cleared by writing 1 to ABRRQ bit in the_RQR register
      end case;
   end Clear_Status;

   ----------------------------------
   -- Enable_DMA_Transmit_Requests --
   ----------------------------------

   procedure Enable_DMA_Transmit_Requests (This : in out USART) is
   begin
      This.Periph.CR3.DMAT := True;
   end Enable_DMA_Transmit_Requests;

   ---------------------------------
   -- Enable_DMA_Receive_Requests --
   ---------------------------------

   procedure Enable_DMA_Receive_Requests (This : in out USART) is
   begin
      This.Periph.CR3.DMAR := True;
   end Enable_DMA_Receive_Requests;

   -----------------------------------
   -- Disable_DMA_Transmit_Requests --
   -----------------------------------

   procedure Disable_DMA_Transmit_Requests (This : in out USART) is
   begin
      This.Periph.CR3.DMAT := False;
   end Disable_DMA_Transmit_Requests;

   ----------------------------------
   -- Disable_DMA_Receive_Requests --
   ----------------------------------

   procedure Disable_DMA_Receive_Requests (This : in out USART) is
   begin
      This.Periph.CR3.DMAR := False;
   end Disable_DMA_Receive_Requests;

   -----------------------------------
   -- DMA_Transmit_Requests_Enabled --
   -----------------------------------

   function DMA_Transmit_Requests_Enabled  (This : USART) return Boolean is
      (This.Periph.CR3.DMAT);

   ----------------------------------
   -- DMA_Receive_Requests_Enabled --
   ----------------------------------

   function DMA_Receive_Requests_Enabled  (This : USART) return Boolean is
      (This.Periph.CR3.DMAR);

   -----------------------------
   -- Resume_DMA_Transmission --
   -----------------------------

   procedure Resume_DMA_Transmission (This : in out USART) is
   begin
      Enable_DMA_Transmit_Requests (This);
      if not Enabled (This) then
         Enable (This);
      end if;
   end Resume_DMA_Transmission;

   --------------------------
   -- Resume_DMA_Reception --
   --------------------------

   procedure Resume_DMA_Reception (This : in out USART) is
   begin
      Enable_DMA_Receive_Requests (This);
      if not Enabled (This) then
         Enable (This);
      end if;
   end Resume_DMA_Reception;

   --------------------------------
   -- Read_Data_Register_Address --
   --------------------------------

   function Read_Data_Register_Address (This : USART) return System.Address is
         (This.Periph.RDR'Address);

   ------------------------------------
   -- Transmit_Data_Register_Address --
   ------------------------------------

   function Transmit_Data_Register_Address (This : USART) return System.Address is
         (This.Periph.TDR'Address);

   ---------------
   -- Data_Size --
   ---------------

   overriding
   function Data_Size (This : USART) return HAL.UART.UART_Data_Size
   is
   begin
      if not This.Periph.CR1.M1 and not This.Periph.CR1.M0
      then
         return Data_Size_8b;
      elsif not This.Periph.CR1.M1 and This.Periph.CR1.M0
      then
         return Data_Size_9b;
      else
         return Data_Size_7b;
      end if;
   end Data_Size;

   --------------
   -- Transmit --
   --------------

   overriding
   procedure Transmit
     (This    : in out USART;
      Data    : UART_Data_7b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
   is
      pragma Unreferenced (Status, Timeout);
   begin
      for Elt of Data loop
         loop
            exit when This.Tx_Ready;
         end loop;

         This.Transmit (UInt9 (Elt));
      end loop;
      Status := Ok;
   end Transmit;

   --------------
   -- Transmit --
   --------------

   overriding
   procedure Transmit
     (This    : in out USART;
      Data    : UART_Data_8b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
   is
      pragma Unreferenced (Status, Timeout);
   begin
      for Elt of Data loop
         loop
            exit when This.Tx_Ready;
         end loop;

         This.Transmit (UInt9 (Elt));
      end loop;
      Status := Ok;
   end Transmit;

   --------------
   -- Transmit --
   --------------

   overriding
   procedure Transmit
     (This    : in out USART;
      Data    : UART_Data_9b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
   is
      pragma Unreferenced (Status, Timeout);
   begin
      for Elt of Data loop
         loop
            exit when This.Tx_Ready;
         end loop;

         This.Transmit (Elt);
      end loop;
      Status := Ok;
   end Transmit;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive
     (This    : in out USART;
      Data    : out UART_Data_7b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
   is
      pragma Unreferenced (Status, Timeout);
   begin
      for Elt of Data loop
         loop
            exit when This.Rx_Ready;
         end loop;

         This.Receive (UInt9 (Elt));
      end loop;
      Status := Ok;
   end Receive;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive
     (This    : in out USART;
      Data    : out UART_Data_8b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
   is
      pragma Unreferenced (Status, Timeout);
   begin
      for Elt of Data loop
         loop
            exit when This.Rx_Ready;
         end loop;

         This.Receive (UInt9 (Elt));
      end loop;
      Status := Ok;
   end Receive;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive
     (This    : in out USART;
      Data    : out UART_Data_9b;
      Status  : out UART_Status;
      Timeout : Natural := 1000)
   is
      pragma Unreferenced (Status, Timeout);
   begin
      for Elt of Data loop
         loop
            exit when This.Rx_Ready;
         end loop;

         This.Receive (Elt);
      end loop;
      Status := Ok;
   end Receive;

end STM32.USARTs;
