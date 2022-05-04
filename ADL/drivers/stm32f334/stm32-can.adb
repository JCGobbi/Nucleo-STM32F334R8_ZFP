------------------------------------------------------------------------------
--                                                                          --
--                  Copyright (C) 2015-2018, AdaCore                        --
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
------------------------------------------------------------------------------

with STM32_SVD.CAN; use STM32_SVD.CAN;
with STM32.Device;

package body STM32.CAN is

   use Sys.Real_Time;

   ---------------
   -- Reset_CAN --
   ---------------

   procedure Reset_CAN
     (This : in out CAN_Controller)
   is
   begin
      This.MCR.RESET := True;
   end Reset_CAN;

   -------------------
   -- Set_Init_Mode --
   -------------------

   procedure Set_Init_Mode
     (This    : in out CAN_Controller;
      Enabled : in     Boolean)
   is
      Deadline : constant Time := Clock + Default_Timeout;
      Success : Boolean;
   begin
      This.MCR.INRQ := Enabled;

      while Clock < Deadline loop
         if Enabled then
            Success := Is_Init_Mode (This);
         else
            Success := not Is_Init_Mode (This);
         end if;
         exit when Success;
      end loop;
   end Set_Init_Mode;

   ---------------------
   -- Enter_Init_Mode --
   ---------------------

   procedure Enter_Init_Mode
     (This : in out CAN_Controller)
   is
   begin
      Set_Init_Mode (This, True);
   end Enter_Init_Mode;

   ------------------
   -- Is_Init_Mode --
   ------------------

   function Is_Init_Mode (This : CAN_Controller) return Boolean is
      (This.MSR.INAK);

   --------------------
   -- Exit_Init_Mode --
   --------------------

   procedure Exit_Init_Mode
     (This : in out CAN_Controller)
   is
   begin
      Set_Init_Mode (This, False);
   end Exit_Init_Mode;

   --------------------
   -- Set_Sleep_Mode --
   --------------------

   procedure Set_Sleep_Mode
     (This    : in out CAN_Controller;
      Enabled : in     Boolean)
   is
      Deadline : constant Time := Clock + Default_Timeout;
      Success : Boolean;
   begin
      This.MCR.SLEEP := Enabled;

      while Clock < Deadline loop
         if Enabled then
            Success := Is_Sleep_Mode (This);
         else
            Success := not Is_Sleep_Mode (This);
         end if;
         exit when Success;
      end loop;
   end Set_Sleep_Mode;

   -----------
   -- Sleep --
   -----------

   procedure Sleep
     (This : in out CAN_Controller)
   is
   begin
      Exit_Init_Mode (This);
      Set_Sleep_Mode (This, True);
   end Sleep;

   -------------------
   -- Is_Sleep_Mode --
   -------------------

   function Is_Sleep_Mode (This : CAN_Controller) return Boolean is
      (This.MSR.SLAK);

   ------------
   -- Wakeup --
   ------------

   procedure Wakeup
     (This : in out CAN_Controller)
   is
   begin
      Set_Sleep_Mode (This, False);
   end Wakeup;

   --------------------------
   -- Calculate_Bit_Timing --
   --------------------------

   procedure Calculate_Bit_Timing
     (Speed        : in Bit_Rate_Range;
      Sample_Point : in Sample_Point_Range;
      Tolerance    : in Clock_Tolerance;
      Bit_Timing   : in out Bit_Timing_Config)
   is
      --  The CAN clock frequency comes from APB1 peripheral clock (PCLK1).
      Clock_In : constant Float := Float (STM32.Device.System_Clock_Frequencies.PCLK1);
      --  Time Quanta in one Bit Time
      Time_Quanta : Float;
      --  Found Bit Time Quanta value.
      BTQ : Boolean := False;
   begin
      --  Assure the clock frequency is high enough.
      pragma Assert
        (Integer (Clock_In / (Speed * 1_000.0 *
         Float (Time_Quanta_Prescaler'First))) < Bit_Time_Quanta'First,
         "CAN clock frequency too low for this bit rate.");
      --  Assure the clock frequency is low enough.
      pragma Assert
        (Integer (Clock_In / (Speed * 1_000.0 *
         Float (Time_Quanta_Prescaler'Last))) > Bit_Time_Quanta'Last,
         "CAN clock frequency too high for this bit rate.");

      for I in Time_Quanta_Prescaler'First .. Time_Quanta_Prescaler'Last loop
         --  Choose the minimum divisor for the maximum number of Time Quanta.
         Time_Quanta := Clock_In / (Speed * 1000.0 * Float (I));

         --  Test if Time_Quanta < Bit_Time_Quanta'First
         if Integer (Time_Quanta) < Bit_Time_Quanta'First then
            exit;
         --  Test if Time Quanta <= Bit_Time_Quanta'Last and if
         --  Sample Point <= Segment_Sync_Quanta + Segment_1_Quanta'Last
         elsif Integer (Time_Quanta) <= Bit_Time_Quanta'Last and
           Integer (Time_Quanta * Sample_Point / 100.0) <=
           (Segment_Sync_Quanta + Segment_1_Quanta'Last)
         then
            --  Calculate time segments
            Bit_Timing.Time_Segment_1 :=
              Integer (Time_Quanta * Sample_Point / 100.0) - Segment_Sync_Quanta;
            --  Casting a float to integer rounds it to the near integer.
            Bit_Timing.Time_Segment_2 :=
              Integer (Time_Quanta) - Segment_Sync_Quanta - Bit_Timing.Time_Segment_1;

            if Bit_Timing.Time_Segment_2 < 4 then
               Bit_Timing.Resynch_Jump_Width := Bit_Timing.Time_Segment_2;
            else
               Bit_Timing.Resynch_Jump_Width := 4;
            end if;

            --  We want a division that gives tolerance inside tolerance range.
            if Tolerance >= abs (Clock_In - Float ((Segment_Sync_Quanta +
                 Bit_Timing.Time_Segment_1 + Bit_Timing.Time_Segment_2) * I) *
                 Speed * 1000.0) * 100.0 / Clock_In and
              Tolerance <= Float (Bit_Timing.Time_Segment_2) /
                           Float (2 * (13 * Integer (Time_Quanta))) and
              Tolerance <= Float (Bit_Timing.Resynch_Jump_Width) /
                           Float (20 * Integer (Time_Quanta))
            then
               Bit_Timing.Quanta_Prescaler := I;
               BTQ := True;
               exit;
            end if;
         end if;
      end loop;

      pragma Assert
        (not BTQ, "Can't find a division factor for this bit rate within tolerance.");

   end Calculate_Bit_Timing;

   --------------------------
   -- Configure_Bit_Timing --
   --------------------------

   procedure Configure_Bit_Timing
     (This          : in out CAN_Controller;
      Timing_Config : in     Bit_Timing_Config)
   is
   begin
      This.BTR :=
         (BRP            => UInt10 (Timing_Config.Quanta_Prescaler - 1),
          Reserved_10_15 => 0,
          TS1            => UInt4 (Timing_Config.Time_Segment_1 - 1),
          TS2            => UInt3 (Timing_Config.Time_Segment_2 - 1),
          Reserved_23_23 => 0,
          SJW            => UInt2 (Timing_Config.Resynch_Jump_Width - 1),
          Reserved_26_29 => 0,
          LBKM           => This.BTR.LBKM,
          SILM           => This.BTR.SILM);
   end Configure_Bit_Timing;

   ------------------------
   -- Set_Operating_Mode --
   ------------------------

   procedure Set_Operating_Mode
     (This : in out CAN_Controller;
      Mode : in     Operating_Mode)
   is
   begin
      case Mode is
         when Normal =>
            This.BTR.LBKM := False;
            This.BTR.SILM := False;

         when Loopback =>
            This.BTR.LBKM := True;
            This.BTR.SILM := False;

         when Silent =>
            This.BTR.LBKM := False;
            This.BTR.SILM := True;

         when Silent_Loopback =>
            This.BTR.LBKM := True;
            This.BTR.SILM := True;
      end case;
   end Set_Operating_Mode;

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (This                : in out CAN_Controller;
      Mode                : in     Operating_Mode;
      Time_Triggered      : in     Boolean;
      Auto_Bus_Off        : in     Boolean;
      Auto_Wakeup         : in     Boolean;
      Auto_Retransmission : in     Boolean;
      Rx_FIFO_Locked      : in     Boolean;
      Tx_FIFO_Prio        : in     Boolean;
      Timing_Config       : in     Bit_Timing_Config)
   is
   begin
      Wakeup (This);

      Enter_Init_Mode (This);

      This.MCR.TTCM := Time_Triggered;
      This.MCR.ABOM := Auto_Bus_Off;
      This.MCR.AWUM := Auto_Wakeup;
      This.MCR.NART := not Auto_Retransmission;
      This.MCR.RFLM := Rx_FIFO_Locked;
      This.MCR.TXFP := Tx_FIFO_Prio;

      Configure_Bit_Timing (This, Timing_Config);

      Set_Operating_Mode (This, Mode);

      Exit_Init_Mode (This);
   end Configure;

   --  The following registers are referred from CAN1 only:
   --  FMR, FM1R, FS1R, FFA1R, FA1R
   --  FxR1 (x=0..27)
   --  FxR2 (x=0..27)
   --  (I.e. filter registers)
   CAN1 : CAN_Peripheral renames CAN_Periph;

   ---------------
   -- Write_FxR --
   ---------------

   procedure Write_FxR
     (X    : in Filter_Bank_Nr;
      FxR1 : in UInt32;
      FxR2 : in UInt32)
   is
   begin
      case X is
         when 0  => CAN1.F0R1.Val := FxR1; CAN1.F0R2.Val := FxR2;
         when 1  => CAN1.F1R1.Val := FxR1; CAN1.F1R2.Val := FxR2;
         when 2  => CAN1.F2R1.Val := FxR1; CAN1.F2R2.Val := FxR2;
         when 3  => CAN1.F3R1.Val := FxR1; CAN1.F3R2.Val := FxR2;
         when 4  => CAN1.F4R1.Val := FxR1; CAN1.F4R2.Val := FxR2;
         when 5  => CAN1.F5R1.Val := FxR1; CAN1.F5R2.Val := FxR2;
         when 6  => CAN1.F6R1.Val := FxR1; CAN1.F6R2.Val := FxR2;
         when 7  => CAN1.F7R1.Val := FxR1; CAN1.F7R2.Val := FxR2;
         when 8  => CAN1.F8R1.Val := FxR1; CAN1.F8R2.Val := FxR2;
         when 9  => CAN1.F9R1.Val := FxR1; CAN1.F9R2.Val := FxR2;
         when 10 => CAN1.F10R1.Val := FxR1; CAN1.F10R2.Val := FxR2;
         when 11 => CAN1.F11R1.Val := FxR1; CAN1.F11R2.Val := FxR2;
         when 12 => CAN1.F12R1.Val := FxR1; CAN1.F12R2.Val := FxR2;
         when 13 => CAN1.F13R1.Val := FxR1; CAN1.F13R2.Val := FxR2;
      end case;
   end Write_FxR;

   ----------------------------
   -- Enter_Filter_Init_Mode --
   ----------------------------

   procedure Enter_Filter_Init_Mode
   is
   begin
      CAN1.FMR.FINIT := True;
   end Enter_Filter_Init_Mode;

   -------------------------
   -- Is_Filter_Init_Mode --
   -------------------------

   function Is_Filter_Init_Mode return Boolean is
      (CAN1.FMR.FINIT);

   ---------------------------
   -- Exit_Filter_Init_Mode --
   ---------------------------

   procedure Exit_Filter_Init_Mode
   is
   begin
      CAN1.FMR.FINIT := False;
   end Exit_Filter_Init_Mode;

   ---------------------------
   -- Set_Filter_Activation --
   ---------------------------

   procedure Set_Filter_Activation
     (Bank_Nr : in Filter_Bank_Nr;
      Enabled : in Boolean)
   is
   begin
      CAN1.FA1R.FACT.Arr (Bank_Nr) := Enabled;
   end Set_Filter_Activation;

   ----------------------
   -- Set_Filter_Scale --
   ----------------------

   procedure Set_Filter_Scale
     (Bank_Nr : in Filter_Bank_Nr;
      Mode    : in Mode_Scale)
   is
   begin
      case Mode is
         when List16 | Mask16 =>
            CAN1.FS1R.FSC.Arr (Bank_Nr) := False;
         when List32 | Mask32 =>
            CAN1.FS1R.FSC.Arr (Bank_Nr) := True;
      end case;
   end Set_Filter_Scale;

   ---------------------
   -- Set_Filter_Mode --
   ---------------------

   procedure Set_Filter_Mode
     (Bank_Nr : in Filter_Bank_Nr;
      Mode    : in Mode_Scale)
   is
   begin
      case Mode is
         when List16 | List32 =>
            CAN1.FM1R.FBM.Arr (Bank_Nr) := True;
         when Mask16 | Mask32 =>
            CAN1.FM1R.FBM.Arr (Bank_Nr) := False;
      end case;
   end Set_Filter_Mode;

   -------------------------
   -- Set_Fifo_Assignment --
   -------------------------

   procedure Set_Fifo_Assignment
     (Bank_Nr : in Filter_Bank_Nr;
      Fifo    : in Fifo_Nr)
   is
   begin
      case Fifo is
         when FIFO_0 =>
            CAN1.FFA1R.FFA.Arr (Bank_Nr) := False;
         when FIFO_1 =>
            CAN1.FFA1R.FFA.Arr (Bank_Nr) := True;
      end case;
   end Set_Fifo_Assignment;

   ----------------------
   -- Configure_Filter --
   ----------------------

   procedure Configure_Filter
     (This        : in out CAN_Controller;
      Bank_Config : in     CAN_Filter_Bank)
   is
      pragma Unreferenced (This);
      Nr       : constant Filter_Bank_Nr := Bank_Config.Bank_Nr;
      Reg_Repr : Filter_Reg_Union;
   begin
      Enter_Filter_Init_Mode;
      Set_Filter_Activation (Nr, False);

      case Bank_Config.Filters.Mode is
         when List32 =>
            Reg_Repr := (False, (List32, Bank_Config.Filters.List32));
         when Mask32 =>
            Reg_Repr := (False, (Mask32, Bank_Config.Filters.Mask32));
         when List16 =>
            Reg_Repr := (False, (List16, Bank_Config.Filters.List16));
         when Mask16 =>
            Reg_Repr := (False, (Mask16, Bank_Config.Filters.Mask16));
      end case;

      Set_Filter_Scale (Nr, Bank_Config.Filters.Mode);

      Write_FxR (Nr, Reg_Repr.FxR1, Reg_Repr.FxR2);

      Set_Filter_Mode (Nr, Bank_Config.Filters.Mode);

      Set_Fifo_Assignment (Nr, Bank_Config.Fifo_Assignment);

      Set_Filter_Activation (Nr, True);
      Exit_Filter_Init_Mode;
   end Configure_Filter;

   --------------------------
   -- Set_Slave_Start_Bank --
   --------------------------

   procedure Set_Slave_Start_Bank
     (Bank_Nr : in Filter_Bank_Nr)
   is
   begin
      CAN1.FMR.CAN2SB := UInt6 (Bank_Nr);
   end Set_Slave_Start_Bank;

   --------------------------
   -- Get_Slave_Start_Bank --
   --------------------------

   function Get_Slave_Start_Bank return Filter_Bank_Nr is
     (Filter_Bank_Nr (CAN1.FMR.CAN2SB));

   ------------------
   -- Release_Fifo --
   ------------------

   procedure Release_Fifo
     (This : in out CAN_Controller;
      Fifo : in     Fifo_Nr)
   is
   begin
      case Fifo is
         when FIFO_0 =>
            This.RF0R.RFOM0 := True;
         when FIFO_1 =>
            This.RF1R.RFOM1 := True;
      end case;
   end Release_Fifo;

   ---------------------
   -- Read_Rx_Message --
   ---------------------

   function Read_Rx_Message
     (This : CAN_Controller;
      Fifo : Fifo_Nr)
      return CAN_Message
   is
   begin
      case Fifo is
         when FIFO_0 =>
            return CAN_Message'
               (Std_ID => This.RI0R.STID,
                Ext_ID => This.RI0R.EXID,
                Ide    => This.RI0R.IDE,
                Rtr    => This.RI0R.RTR,
                Dlc    => This.RDT0R.DLC,
                Data   => Message_Data (This.RDL0R.Arr) &
                          Message_Data (This.RDH0R.Arr));
         when FIFO_1 =>
            return CAN_Message'
               (Std_ID => This.RI1R.STID,
                Ext_ID => This.RI1R.EXID,
                Ide    => This.RI1R.IDE,
                Rtr    => This.RI1R.RTR,
                Dlc    => This.RDT1R.DLC,
                Data   => Message_Data (This.RDL1R.Arr) &
                          Message_Data (This.RDH1R.Arr));
      end case;
   end Read_Rx_Message;

   ---------------------
   -- Nof_Msg_In_Fifo --
   ---------------------

   function Nof_Msg_In_Fifo
     (This : CAN_Controller;
      Fifo : Fifo_Nr)
      return UInt2
   is
   begin
      case Fifo is
         when FIFO_0 =>
            return This.RF0R.FMP0;
         when FIFO_1 =>
            return This.RF1R.FMP1;
      end case;
   end Nof_Msg_In_Fifo;

   ---------------------
   -- Receive_Message --
   ---------------------

   procedure Receive_Message
     (This    : in out CAN_Controller;
      Fifo    : in     Fifo_Nr;
      Message :    out CAN_Message;
      Success :    out Boolean;
      Timeout : in     Time_Span := Default_Timeout)
   is
      Deadline : constant Time := Clock + Timeout;
   begin
      loop
         Success := Clock < Deadline;
         exit when not Success or Nof_Msg_In_Fifo (This, Fifo) > 0;
      end loop;

      if Success then
         Message := Read_Rx_Message (This, Fifo);
         Release_Fifo (This, Fifo);
      end if;
   end Receive_Message;

   --------------
   -- Is_Empty --
   --------------

   function Is_Empty
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
   is
   begin
      return This.TSR.TME.Arr (Mailbox_Type'Pos (Mailbox));
   end Is_Empty;

   -----------------------
   -- Get_Empty_Mailbox --
   -----------------------

   procedure Get_Empty_Mailbox
     (This        : in out CAN_Controller;
      Mailbox     :    out Mailbox_Type;
      Empty_Found :    out Boolean)
   is
   begin
      for Mbx in Mailbox_Type'Range loop
         Empty_Found := Is_Empty (This, Mbx);
         Mailbox := Mbx;
         exit when Empty_Found;
      end loop;
   end Get_Empty_Mailbox;

   --------------------------
   -- Transmission_Request --
   --------------------------

   procedure Transmission_Request
     (This    : in out CAN_Controller;
      Mailbox : in     Mailbox_Type)
   is
   begin
      case Mailbox is
         when Mailbox_0 =>
            This.TI0R.TXRQ := True;
         when Mailbox_1 =>
            This.TI1R.TXRQ := True;
         when Mailbox_2 =>
            This.TI2R.TXRQ := True;
      end case;
   end Transmission_Request;

   -----------------------
   -- Request_Completed --
   -----------------------

   function Request_Completed
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
   is
   begin
      case Mailbox is
         when Mailbox_0 =>
            return This.TSR.RQCP0;
         when Mailbox_1 =>
            return This.TSR.RQCP1;
         when Mailbox_2 =>
            return This.TSR.RQCP2;
      end case;
   end Request_Completed;

   ---------------------
   -- Transmission_OK --
   ---------------------

   function Transmission_OK
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
   is
   begin
      case Mailbox is
         when Mailbox_0 =>
            return This.TSR.TXOK0;
         when Mailbox_1 =>
            return This.TSR.TXOK1;
         when Mailbox_2 =>
            return This.TSR.TXOK2;
      end case;
   end Transmission_OK;

   ----------------------------
   -- Transmission_Completed --
   ----------------------------

   function Transmission_Completed
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
   is
   begin
      return Is_Empty (This, Mailbox) and then
             Request_Completed (This, Mailbox);
   end Transmission_Completed;

   -----------------------------
   -- Transmission_Successful --
   -----------------------------

   function Transmission_Successful
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
   is
   begin
      return Transmission_Completed (This, Mailbox) and then
             Transmission_OK (This, Mailbox);
   end Transmission_Successful;

   ----------------------
   -- Write_Tx_Message --
   ----------------------

   procedure Write_Tx_Message
     (This    : in out CAN_Controller;
      Message : in     CAN_Message;
      Mailbox : in     Mailbox_Type)
   is
   begin
      case Mailbox is
         when Mailbox_0 =>
            This.TI0R := (TXRQ => False,
                          RTR  => Message.Rtr,
                          IDE  => Message.Ide,
                          EXID => Message.Ext_ID,
                          STID => Message.Std_ID);
            This.TDT0R.DLC := Message.Dlc;
            This.TDL0R.Arr := TDL0R_DATA_Field_Array (Message.Data (0 .. 3));
            This.TDH0R.Arr := TDH0R_DATA_Field_Array (Message.Data (4 .. 7));

         when Mailbox_1 =>
            This.TI1R := (TXRQ => False,
                          RTR  => Message.Rtr,
                          IDE  => Message.Ide,
                          EXID => Message.Ext_ID,
                          STID => Message.Std_ID);
            This.TDT1R.DLC := Message.Dlc;
            This.TDL1R.Arr := TDL1R_DATA_Field_Array (Message.Data (0 .. 3));
            This.TDH1R.Arr := TDH1R_DATA_Field_Array (Message.Data (4 .. 7));

         when Mailbox_2 =>
            This.TI2R := (TXRQ => False,
                          RTR  => Message.Rtr,
                          IDE  => Message.Ide,
                          EXID => Message.Ext_ID,
                          STID => Message.Std_ID);
            This.TDT2R.DLC := Message.Dlc;
            This.TDL2R.Arr := TDL2R_DATA_Field_Array (Message.Data (0 .. 3));
            This.TDH2R.Arr := TDH2R_DATA_Field_Array (Message.Data (4 .. 7));
      end case;
   end Write_Tx_Message;

   ----------------------
   -- Transmit_Message --
   ----------------------

   procedure Transmit_Message
     (This    : in out CAN_Controller;
      Message : in     CAN_Message;
      Success :    out Boolean;
      Timeout : in     Time_Span := Default_Timeout)
   is
      Mailbox  : Mailbox_Type;
      Deadline : constant Time := Clock + Timeout;
   begin
      Get_Empty_Mailbox (This, Mailbox, Success);

      if Success then
         Write_Tx_Message (This, Message, Mailbox);
         Transmission_Request (This, Mailbox);

         while not Transmission_Successful (This, Mailbox) and Success loop
            Success := Clock < Deadline;
         end loop;
      end if;
   end Transmit_Message;

   ----------------
   -- Is_Overrun --
   ----------------

   function Is_Overrun
     (This : CAN_Controller;
      Fifo : Fifo_Nr)
      return Boolean
   is
   begin
      case Fifo is
         when FIFO_0 =>
            return This.RF0R.FOVR0;
         when FIFO_1 =>
            return This.RF1R.FOVR1;
      end case;
   end Is_Overrun;

   -------------
   -- Is_Full --
   -------------

   function Is_Full
     (This : CAN_Controller;
      Fifo : Fifo_Nr)
      return Boolean
   is
   begin
      case Fifo is
         when FIFO_0 =>
            return This.RF0R.FULL0;
         when FIFO_1 =>
            return This.RF1R.FULL1;
      end case;
   end Is_Full;

   -----------------------
   -- Interrupt_Enabled --
   -----------------------

   function Interrupt_Enabled
     (This   : CAN_Controller;
      Source : CAN_Interrupt)
      return Boolean
   is
   begin
      case Source is
         when Transmit_Mailbox_Empty =>
            return This.IER.TMEIE;
         when FIFO_0_Message_Pending =>
            return This.IER.FMPIE0;
         when FIFO_1_Message_Pending =>
            return This.IER.FMPIE1;
         when FIFO_0_Full =>
            return This.IER.FFIE0;
         when FIFO_1_Full =>
            return This.IER.FFIE1;
         when FIFO_0_Overrun =>
            return This.IER.FOVIE0;
         when FIFO_1_Overrun =>
            return This.IER.FOVIE1;
         when Error =>
            return This.IER.ERRIE;
         when Last_Error_Code =>
            return This.IER.LECIE;
         when Bus_Off =>
            return This.IER.BOFIE;
         when Error_Passive =>
            return This.IER.EPVIE;
         when Error_Warning =>
            return This.IER.EWGIE;
         when Sleep_Acknowledge =>
            return This.IER.SLKIE;
         when Wakeup =>
            return This.IER.WKUIE;
      end case;
   end Interrupt_Enabled;

   -----------------------
   -- Enable_Interrupts --
   -----------------------

   procedure Enable_Interrupts
     (This   : in out CAN_Controller;
      Source : CAN_Interrupt)
   is
   begin
      case Source is
         when Transmit_Mailbox_Empty =>
            This.IER.TMEIE := True;
         when FIFO_0_Message_Pending =>
            This.IER.FMPIE0 := True;
         when FIFO_1_Message_Pending =>
            This.IER.FMPIE1 := True;
         when FIFO_0_Full =>
            This.IER.FFIE0 := True;
         when FIFO_1_Full =>
            This.IER.FFIE1 := True;
         when FIFO_0_Overrun =>
            This.IER.FOVIE0 := True;
         when FIFO_1_Overrun =>
            This.IER.FOVIE1 := True;
         when Error =>
            This.IER.ERRIE := True;
         when Last_Error_Code =>
            This.IER.LECIE := True;
         when Bus_Off =>
            This.IER.BOFIE := True;
         when Error_Passive =>
            This.IER.EPVIE := True;
         when Error_Warning =>
            This.IER.EWGIE := True;
         when Sleep_Acknowledge =>
            This.IER.SLKIE := True;
         when Wakeup =>
            This.IER.WKUIE := True;
      end case;
   end Enable_Interrupts;

   ------------------------
   -- Disable_Interrupts --
   ------------------------

   procedure Disable_Interrupts
     (This   : in out CAN_Controller;
      Source : CAN_Interrupt)
   is
   begin
      case Source is
         when Transmit_Mailbox_Empty =>
            This.IER.TMEIE := False;
         when FIFO_0_Message_Pending =>
            This.IER.FMPIE0 := False;
         when FIFO_1_Message_Pending =>
            This.IER.FMPIE1 := False;
         when FIFO_0_Full =>
            This.IER.FFIE0 := False;
         when FIFO_1_Full =>
            This.IER.FFIE1 := False;
         when FIFO_0_Overrun =>
            This.IER.FOVIE0 := False;
         when FIFO_1_Overrun =>
            This.IER.FOVIE1 := False;
         when Error =>
            This.IER.ERRIE := False;
         when Last_Error_Code =>
            This.IER.LECIE := False;
         when Bus_Off =>
            This.IER.BOFIE := False;
         when Error_Passive =>
            This.IER.EPVIE := False;
         when Error_Warning =>
            This.IER.EWGIE := False;
         when Sleep_Acknowledge =>
            This.IER.SLKIE := False;
         when Wakeup =>
            This.IER.WKUIE := False;
      end case;
   end Disable_Interrupts;

end STM32.CAN;
