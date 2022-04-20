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

--  This file provides interfaces for the CAN modules on the
--  STM32F4 (ARM Cortex M4F) microcontrollers from ST Microelectronics.

with System;

private with STM32_SVD.CAN;
with SYS.Real_Time;

package STM32.CAN is
   pragma Elaborate_Body;

   type CAN_Controller is limited private;

   procedure Reset_CAN
     (This : in out CAN_Controller);

   procedure Enter_Init_Mode
     (This : in out CAN_Controller)
    with Post => Is_Init_Mode (This);

   function Is_Init_Mode (This : CAN_Controller) return Boolean;

   procedure Exit_Init_Mode
     (This : in out CAN_Controller)
    with Post => not Is_Init_Mode (This);

   procedure Sleep
     (This : in out CAN_Controller)
    with Post => Is_Sleep_Mode (This);

   function Is_Sleep_Mode (This : CAN_Controller) return Boolean;

   procedure Wakeup
     (This : in out CAN_Controller)
    with Post => not Is_Sleep_Mode (This);

   subtype Resynch_Quanta is Positive range 1 .. 4;
   --  These bits define the maximum number of time quanta the CAN hardware is
   --  allowed to lengthen or shorten a bit to perform the resynchronization.
   --  This is the SJW. The preferred value used for CANopen and DeviceNet is 1.
   subtype Segment_1_Quanta is Positive range 1 .. 16;
   --  Defines the location of the sample point (number of time quanta).
   --  It includes the PROP_SEG and PHASE_SEG1 of the CAN standard.
   subtype Segment_2_Quanta is Positive range 1 .. 8;
   --  Defines the location of the sample point (number of time quanta).
   --  It represents the PHASE_SEG2 of the CAN standard.
   subtype Time_Quanta_Prescaler is Positive range 1 .. 1024;
   --  These bits define the length of a time quanta.

   Segment_Sync_Quanta : constant Positive := 1;
   --  This is the SYNC_SEG segment, the time quanta for syncronism.

   subtype Sample_Point_Range is Float range 50.0 .. 90.0;
   --  The sample point of the start frame (at the end of PHASE_SEG1) is taken
   --  between 50 to 90% of the Bit Time. The preferred value used by CANopen
   --  and DeviceNet is 87.5% and 75% for ARINC 825.
   --  See http://www.bittiming.can-wiki.info/#bxCAN for this calculation.

   type CAN_Protocol is (CANopen, DeviceNet, Arinc_825);

   type Sample_Point_Array is array (CAN_Protocol) of Sample_Point_Range;

   Sample_Point : Sample_Point_Array := (87.5, 87.5, 75.0);
   --  Preferred percentage values for CANopen, DeviceNet and ARINC 825.

   subtype Bit_Time_Quanta is Positive range 8 .. 19;
   --  This is the number of time quanta in one Bit Time. So for a 1 MHz bit
   --  rate and the minimum Bit_Time_Quanta = 8, the minimum prescaler input
   --  frequency is 8 MHz.
   --  1 Bit time (= 1/bit rate) is defined by four time segments:
   --  SYNC_SEG - 1 time quantum long;
   --  PROP_SEG - 1 to 8 time quanta long;
   --  PHASE_SEG1 - 1 to 8 time quanta long;
   --  PHASE_SEG2 - maximum of PHASE_SEG1 and the Information processing time,
   --  that is less then or equal to 2 Time Quanta long.
   --
   --  The sample point of start frame is taken at 87.5% maximum of
   --  Bit_Time_Quanta'Last, and must not be grater then SYNC_SEG + PROP_SEG +
   --  PHASE_SEG (Segment_Sync_Quanta + Segment_1_Quanta) = 17. So the maximum
   --  value for Bit_Time_Quanta is 17 / 0.875 = 19.4 ~ 19.

   subtype Bit_Rate_Range is Positive range 10 .. 1_000;
   --  This is the actual bit rate frequency of the CAN bus in kHz.
   --  The standard frequencies are 10, 20, 50, 83.333, 100, 125, 250, 500, 800
   --  and 1000 kHz.

   type Bit_Rate_Select is
     (Rate_1000, --  1 MHz
      Rate_800,
      Rate_500,
      Rate_250, --  250 kHz
      Rate_125,
      Rate_100,
      Rate_83, --  83.333 kHz
      Rate_50,
      Rate_20,
      Rate_10);

   type Bit_Rate_Array is array (Bit_Rate_Select) of Bit_Rate_Range;
   Bit_Rate : Bit_Rate_Array := (1_000, 800, 500, 250, 125, 100, 83, 50, 20, 10);

   type Bit_Timing_Config is record
      Resynch_Jump_Width : Resynch_Quanta := 1;
      Time_Segment_1     : Segment_1_Quanta;
      Time_Segment_2     : Segment_2_Quanta;
      Quanta_Prescaler   : Time_Quanta_Prescaler;
   end record;

   procedure Calculate_Bit_Timing
     (Speed      : in Bit_Rate_Select;
      Protocol   : in CAN_Protocol;
      Bit_Timing : in out Bit_Timing_Config);
   --  Automatically calculate bit timings based on requested bit rate and
   --  sample ratio.
   --  1 nominal Bit Time is defined by the time length in quanta of four time
   --  segments, each one composed of 1 or more quanta: SINC_SEG, PROP_SEG,
   --  PHASE_SEG1 and PHASE_SEG2.
   --  The Baud Rate (the Bit frequency) is the inverse of 1 nominal Bit Time.
   --  The prescaler is calculated to get the time of one quanta, so we divide
   --  the bus frequency of the CAN peripheral by the baud rate and divide this
   --  value by the number of quanta in one nominal Bit time.
   --  See RM0364 rev. 4 chapter 30.7.7 Bit timing.

   procedure Configure_Bit_Timing
     (This          : in out CAN_Controller;
      Timing_Config : in     Bit_Timing_Config)
     with Pre => Is_Init_Mode (This);

   type Operating_Mode is
     (Normal,
      Loopback,
      Silent,
      Silent_Loopback);

   procedure Set_Operating_Mode
     (This : in out CAN_Controller;
      Mode : in     Operating_Mode)
     with Pre => Is_Init_Mode (This);

   procedure Configure
     (This                : in out CAN_Controller;
      Mode                : in     Operating_Mode;
      Time_Triggered      : in     Boolean;
      Auto_Bus_Off        : in     Boolean;
      Auto_Wakeup         : in     Boolean;
      Auto_Retransmission : in     Boolean;
      Rx_FIFO_Locked      : in     Boolean;
      Tx_FIFO_Prio        : in     Boolean;
      Timing_Config       : in     Bit_Timing_Config);

   procedure Enter_Filter_Init_Mode;

   function Is_Filter_Init_Mode return Boolean;

   procedure Exit_Filter_Init_Mode;

   subtype Standard_Id is UInt11;
   subtype Extended_Id is UInt18;

   type Filter_32 is record
      Std_ID : Standard_Id;
      Ext_ID : Extended_Id;
      Ide    : Boolean;
      Rtr    : Boolean;
   end record
     with Size => 32, Bit_Order => System.Low_Order_First;

   for Filter_32 use record
      Std_ID at 0 range 21 .. 31;
      Ext_ID at 0 range 3 .. 20;
      Ide    at 0 range 2 .. 2;
      Rtr    at 0 range 1 .. 1;
      --  Zero bit 0
   end record;

   type Filter_16 is record
      Std_ID     : Standard_Id;
      Rtr        : Boolean;
      Ide        : Boolean;
      Ext_ID_Msb : UInt3; --  Upper three bits [17:15]
   end record
      with Size => 16, Bit_Order => System.Low_Order_First;

   for Filter_16 use record
      Std_ID     at 0 range 5 .. 15;
      Rtr        at 0 range 4 .. 4;
      Ide        at 0 range 3 .. 3;
      Ext_ID_Msb at 0 range 0 .. 2;
   end record;

   subtype Filter_Bank_Nr is Natural range 0 .. 13;

   type Fifo_Nr is (FIFO_0, FIFO_1);

   type Mode_Scale is (Mask32, List32, Mask16, List16);

   type Mask32_Filter is record
      Id   : Filter_32;
      Mask : Filter_32;
   end record
     with Size => 64, Bit_Order => System.Low_Order_First;

   for Mask32_Filter use record
      Id   at 0 range 0 .. 31;
      Mask at 0 range 32 .. 63;
   end record;

   type Mask16_Filter is record
      Id_1   : Filter_16;
      Mask_1 : Filter_16;
      Id_2   : Filter_16;
      Mask_2 : Filter_16;
   end record
     with Size => 64, Bit_Order => System.Low_Order_First;

   for Mask16_Filter use record
      Id_1   at 0 range 0 .. 15;
      Mask_1 at 0 range 16 .. 31;
      Id_2   at 0 range 32 .. 47;
      Mask_2 at 0 range 48 .. 63;
   end record;

   type Id32_Filter is record
      Id_1 : Filter_32;
      Id_2 : Filter_32;
   end record
     with Size => 64, Bit_Order => System.Low_Order_First;

   for Id32_Filter use record
      Id_1 at 0 range 0 .. 31;
      Id_2 at 0 range 32 .. 63;
   end record;

   type Id16_Filter is record
      Id_1 : Filter_16;
      Id_2 : Filter_16;
      Id_3 : Filter_16;
      Id_4 : Filter_16;
   end record
     with Size => 64, Bit_Order => System.Low_Order_First;

   for Id16_Filter use record
      Id_1 at 0 range 0 .. 15;
      Id_2 at 0 range 16 .. 31;
      Id_3 at 0 range 32 .. 47;
      Id_4 at 0 range 48 .. 63;
   end record;

   type CAN_Filter (Mode : Mode_Scale := Mask32) is record
      case Mode is
         when List32 =>
            --  Match two different 32bit IDs exactly
            List32 : Id32_Filter;
         when Mask32 =>
            --  Match a single 32bit ID as given by a mask
            Mask32 : Mask32_Filter;
         when List16 =>
            --  Match four different 16bit IDs exactly
            List16 : Id16_Filter;
         when Mask16 =>
            --  Match two single 16bit ID as given by their masks
            Mask16 : Mask16_Filter;
      end case;
   end record;

   type CAN_Filter_Bank is record
      Bank_Nr         : Filter_Bank_Nr;
      Activated       : Boolean;
      Fifo_Assignment : Fifo_Nr;
      Filters         : CAN_Filter;
   end record;

   procedure Configure_Filter
     (This        : in out CAN_Controller;
      Bank_Config : in     CAN_Filter_Bank);

   procedure Set_Filter_Activation
     (Bank_Nr : in Filter_Bank_Nr;
      Enabled : in Boolean);

   function Get_Slave_Start_Bank return Filter_Bank_Nr;

   procedure Set_Slave_Start_Bank
     (Bank_Nr : in Filter_Bank_Nr)
     with Post => Bank_Nr = Get_Slave_Start_Bank;

   subtype Data_Length_Type is UInt4 range 0 .. 8;

   type Message_Data is array (Natural range <>) of UInt8;

   type CAN_Message is record
      Std_ID : Standard_Id;
      Ext_ID : Extended_Id;
      Ide    : Boolean;
      Rtr    : Boolean;
      Dlc    : Data_Length_Type;
      Data   : Message_Data (0 .. 7);
   end record;

   procedure Release_Fifo
     (This : in out CAN_Controller;
      Fifo : in     Fifo_Nr);

   function Nof_Msg_In_Fifo
     (This : CAN_Controller;
      Fifo : Fifo_Nr)
      return UInt2;

   Default_Timeout : constant SYS.Real_Time.Time_Span :=
      SYS.Real_Time.Milliseconds (100);

   procedure Receive_Message
     (This    : in out CAN_Controller;
      Fifo    : in     Fifo_Nr;
      Message :    out CAN_Message;
      Success :    out Boolean;
      Timeout : in     SYS.Real_Time.Time_Span := Default_Timeout);

   type Mailbox_Type is (Mailbox_0, Mailbox_1, Mailbox_2);

   procedure Transmit_Message
     (This    : in out CAN_Controller;
      Message : in     CAN_Message;
      Success :    out Boolean;
      Timeout : in     SYS.Real_Time.Time_Span := Default_Timeout);

   procedure Get_Empty_Mailbox
     (This        : in out CAN_Controller;
      Mailbox     :    out Mailbox_Type;
      Empty_Found :    out Boolean);

   function Transmission_Successful
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean;

   procedure Transmission_Request
     (This    : in out CAN_Controller;
      Mailbox : in     Mailbox_Type)
    with Inline;

   function Transmission_OK
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
    with Inline;

   function Transmission_Completed
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
    with Inline;

   function Request_Completed
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
    with Inline;

--  #define CAN_IT_TME  ((uint32_t)CAN_IER_TMEIE)   /*!< Transmit mailbox empty interrupt */
--
--  /* Receive Interrupts */
--  #define CAN_IT_FMP0 ((uint32_t)CAN_IER_FMPIE0)  /*!< FIFO 0 message pending interrupt */
--  #define CAN_IT_FF0  ((uint32_t)CAN_IER_FFIE0)   /*!< FIFO 0 full interrupt            */
--  #define CAN_IT_FOV0 ((uint32_t)CAN_IER_FOVIE0)  /*!< FIFO 0 overrun interrupt         */
--  #define CAN_IT_FMP1 ((uint32_t)CAN_IER_FMPIE1)  /*!< FIFO 1 message pending interrupt */
--  #define CAN_IT_FF1  ((uint32_t)CAN_IER_FFIE1)   /*!< FIFO 1 full interrupt            */
--  #define CAN_IT_FOV1 ((uint32_t)CAN_IER_FOVIE1)  /*!< FIFO 1 overrun interrupt         */
--
--  /* Operating Mode Interrupts */
--  #define CAN_IT_WKU  ((uint32_t)CAN_IER_WKUIE)  /*!< Wake-up interrupt           */
--  #define CAN_IT_SLK  ((uint32_t)CAN_IER_SLKIE)  /*!< Sleep acknowledge interrupt */
--
--  /* Error Interrupts */
--  #define CAN_IT_EWG  ((uint32_t)CAN_IER_EWGIE) /*!< Error warning interrupt   */
--  #define CAN_IT_EPV  ((uint32_t)CAN_IER_EPVIE) /*!< Error passive interrupt   */
--  #define CAN_IT_BOF  ((uint32_t)CAN_IER_BOFIE) /*!< Bus-off interrupt         */
--  #define CAN_IT_LEC  ((uint32_t)CAN_IER_LECIE) /*!< Last error code interrupt */
--  #define CAN_IT_ERR  ((uint32_t)CAN_IER_ERRIE) /*!< Error Interrupt           */

   type CAN_Interrupt is
      (Sleep_Acknowledge,
       Wakeup,
       Error,
       Last_Error_Code,
       Bus_Off,
       Error_Passive,
       Error_Warning,
       FIFO_0_Overrun,
       FIFO_0_Full,
       FIFO_0_Message_Pending,
       FIFO_1_Overrun,
       FIFO_1_Full,
       FIFO_1_Message_Pending,
       Transmit_Mailbox_Empty);

--  /** @brief  Check whether the specified CAN flag is set or not.
--    * @param  __HANDLE__: CAN Handle
--    * @param  __FLAG__: specifies the flag to check.
--    *         This parameter can be one of the following values:
--    *            @arg CAN_TSR_RQCP0: Request MailBox0 Flag
--    *            @arg CAN_TSR_RQCP1: Request MailBox1 Flag
--    *            @arg CAN_TSR_RQCP2: Request MailBox2 Flag
--    *            @arg CAN_FLAG_TXOK0: Transmission OK MailBox0 Flag
--    *            @arg CAN_FLAG_TXOK1: Transmission OK MailBox1 Flag
--    *            @arg CAN_FLAG_TXOK2: Transmission OK MailBox2 Flag
--    *            @arg CAN_FLAG_TME0: Transmit mailbox 0 empty Flag
--    *            @arg CAN_FLAG_TME1: Transmit mailbox 1 empty Flag
--    *            @arg CAN_FLAG_TME2: Transmit mailbox 2 empty Flag
--    *            @arg CAN_FLAG_FMP0: FIFO 0 Message Pending Flag
--    *            @arg CAN_FLAG_FF0: FIFO 0 Full Flag
--    *            @arg CAN_FLAG_FOV0: FIFO 0 Overrun Flag
--    *            @arg CAN_FLAG_FMP1: FIFO 1 Message Pending Flag
--    *            @arg CAN_FLAG_FF1: FIFO 1 Full Flag
--    *            @arg CAN_FLAG_FOV1: FIFO 1 Overrun Flag
--    *            @arg CAN_FLAG_WKU: Wake up Flag
--    *            @arg CAN_FLAG_SLAK: Sleep acknowledge Flag
--    *            @arg CAN_FLAG_SLAKI: Sleep acknowledge Flag
--    *            @arg CAN_FLAG_EWG: Error Warning Flag
--    *            @arg CAN_FLAG_EPV: Error Passive Flag
--    *            @arg CAN_FLAG_BOF: Bus-Off Flag
--    * @retval The new state of __FLAG__ (TRUE or FALSE).

   function Is_Empty
     (This    : CAN_Controller;
      Mailbox : Mailbox_Type)
      return Boolean
    with Inline;

   function Is_Overrun
     (This : CAN_Controller;
      Fifo : Fifo_Nr)
      return Boolean
    with Inline;

   function Is_Full
     (This : CAN_Controller;
      Fifo : Fifo_Nr)
      return Boolean
    with Inline;

   function Interrupt_Enabled
     (This   : CAN_Controller;
      Source : CAN_Interrupt)
      return Boolean
     with Inline;

   procedure Enable_Interrupts
     (This   : in out CAN_Controller;
      Source : CAN_Interrupt)
     with Post => Interrupt_Enabled (This, Source),
          Inline;

   procedure Disable_Interrupts
     (This   : in out CAN_Controller;
      Source : CAN_Interrupt)
     with Post => not Interrupt_Enabled (This, Source),
          Inline;

   function Read_Rx_Message
     (This : CAN_Controller;
      Fifo : Fifo_Nr)
      return CAN_Message;

   procedure Write_Tx_Message
     (This    : in out CAN_Controller;
      Message : in     CAN_Message;
      Mailbox : in     Mailbox_Type)
     with Pre => Is_Empty (This, Mailbox);

private

   type CAN_Controller is new STM32_SVD.CAN.CAN_Peripheral;

   procedure Set_Init_Mode
     (This    : in out CAN_Controller;
      Enabled : in     Boolean);

   procedure Set_Sleep_Mode
     (This    : in out CAN_Controller;
      Enabled : in     Boolean);

   type Filter_Union (Mode : Mode_Scale := Mask32) is record
      case Mode is
         when List32 =>
            List32 : Id32_Filter;
         when Mask32 =>
            Mask32 : Mask32_Filter;
         when List16 =>
            List16 : Id16_Filter;
         when Mask16 =>
            Mask16 : Mask16_Filter;
      end case;
   end record
     with Unchecked_Union, Size => 64;

   type Filter_Reg_Union (As_Registers : Boolean := False) is record
      case As_Registers is
         when True =>
            FxR1 : UInt32;
            FxR2 : UInt32;
         when False =>
            Filter : Filter_Union;
      end case;
   end record
     with Unchecked_Union, Size => 64, Bit_Order => System.Low_Order_First;

   for Filter_Reg_Union use record
      FxR1   at 0 range 0 .. 31;
      FxR2   at 0 range 32 .. 63;
      Filter at 0 range 0 .. 63;
   end record;

   procedure Write_FxR
     (X    : in Filter_Bank_Nr;
      FxR1 : in UInt32;
      FxR2 : in UInt32)
     with Pre => Is_Filter_Init_Mode;

   procedure Set_Filter_Scale
     (Bank_Nr : in Filter_Bank_Nr;
      Mode    : in Mode_Scale)
     with Pre => Is_Filter_Init_Mode;

   procedure Set_Filter_Mode
     (Bank_Nr : in Filter_Bank_Nr;
      Mode    : in Mode_Scale)
     with Pre => Is_Filter_Init_Mode;

   procedure Set_Fifo_Assignment
     (Bank_Nr : in Filter_Bank_Nr;
      Fifo    : in Fifo_Nr)
     with Pre => Is_Filter_Init_Mode;

end STM32.CAN;
