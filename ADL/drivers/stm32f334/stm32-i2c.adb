------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2015-2016, AdaCore                     --
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
--     3. Neither the name of the copyright holder nor the names of its     --
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

with STM32.Device;
with Sys.Real_Time; use Sys.Real_Time;

with STM32_SVD.I2C; use STM32_SVD.I2C;

with HAL.I2C; use HAL.I2C;

package body STM32.I2C is

   type I2C_Transfer_Mode is
     (Reload_Mode,   --  Enable reload mode
      Autoend_Mode,  -- Enable automatic end mode
      Softend_Mode); --  Enable software end mode

   type I2C_Request is
     (No_Start_Stop,         --  Don't generate start or stop
      Generate_Stop,         --  Generate a stop condition
      Generate_Start_Read,   --  Generate a start read request
      Generate_Start_Write); --  Generate a start write request

   procedure Config_Transfer
     (Port    : in out I2C_Port;
      Addr    : I2C_Address;
      Size    : UInt8;
      Mode    : I2C_Transfer_Mode;
      Request : I2C_Request);

   procedure Reset_Config (Port : in out I2C_Port);

   procedure Check_Nack
     (Port    : in out I2C_Port;
      Timeout : Natural;
      Status  : out HAL.I2C.I2C_Status);

   procedure Wait_Tx_Interrupt_Status
     (Port    : in out I2C_Port;
      Timeout : Natural;
      Status  : out I2C_Status);

   procedure Wait_Transfer_Complete_Reset_Flag
     (Port    : in out I2C_Port;
      Timeout : Natural;
      Status  : out I2C_Status);

   procedure Wait_Stop_Flag
     (Port    : in out I2C_Port;
      Timeout : Natural;
      Status  : out I2C_Status);

   ---------------------
   -- Config_Transfer --
   ---------------------

   procedure Config_Transfer
     (Port    : in out I2C_Port;
      Addr    : I2C_Address;
      Size    : UInt8;
      Mode    : I2C_Transfer_Mode;
      Request : I2C_Request)
   is
      CR2 : CR2_Register := Port.Periph.CR2;
   begin
      CR2.SADD := Addr;
      CR2.NBYTES   := Size;
      CR2.RELOAD   := Mode = Reload_Mode;
      CR2.AUTOEND  := Mode = Autoend_Mode;

      CR2.RD_WRN := False;
      CR2.START  := False;
      CR2.STOP   := False;

      case Request is
         when No_Start_Stop =>
            null;

         when Generate_Stop =>
            CR2.STOP := True;

         when Generate_Start_Read =>
            CR2.RD_WRN := True;
            CR2.START  := True;

         when Generate_Start_Write =>
            CR2.START := True;
      end case;

      Port.Periph.CR2 := CR2;
   end Config_Transfer;

   ------------------
   -- Reset_Config --
   ------------------

   procedure Reset_Config (Port  : in out I2C_Port)
   is
      CR2 : CR2_Register := Port.Periph.CR2;
   begin
      CR2.SADD := 0;
      CR2.HEAD10R  := False;
      CR2.NBYTES   := 0;
      CR2.RELOAD   := False;
      CR2.RD_WRN   := False;
      Port.Periph.CR2 := CR2;
   end Reset_Config;

   ----------------
   -- Check_Nack --
   ----------------

   procedure Check_Nack
     (Port    : in out I2C_Port;
      Timeout : Natural;
      Status  : out I2C_Status)
   is
      Start : constant Time := Clock;
   begin
      if Interrupt_Status (Port, Ack_Failure) then
         if Port.State = Master_Busy_Tx
           or else Port.State = Mem_Busy_Tx
           or else Port.State = Mem_Busy_Rx
         then
            --  We generate a STOP condition if SOFTEND mode is enabled
            if not Port.Periph.CR2.AUTOEND then
               Port.Periph.CR2.STOP := True;
            end if;
         end if;

         while not Interrupt_Status (Port, Stop_Detection) loop
            if Timeout > 0
              and then Start + Milliseconds (Timeout) < Clock
            then
               Port.State := Ready;
               Status := Err_Timeout;
               return;
            end if;
         end loop;

         --  Clear the NACK amd STOP flags
         Clear_Interrupt_Status (Port, Ack_Failure);
         Clear_Interrupt_Status (Port, Stop_Detection);

         --  Clear CR2
         Reset_Config (Port);

         Port.State := Ready;
         Status := Err_Error;

      else
         Status := Ok;
      end if;
   end Check_Nack;

   ------------------------------
   -- Wait_Tx_Interrupt_Status --
   ------------------------------

   procedure Wait_Tx_Interrupt_Status
     (Port    : in out I2C_Port;
      Timeout : Natural;
      Status  : out I2C_Status)
   is
      Start : constant Time := Clock;
   begin
      while not Interrupt_Status (Port, Tx_Data_Register_Empty_Interrupt) loop
         Check_Nack (Port, Timeout, Status);

         if Status /= Ok then
            Port.State := Ready;
            Status := Err_Error;

            return;
         end if;

         if Timeout > 0
           and then Start + Milliseconds (Timeout) < Clock
         then
            Reset_Config (Port);
            Port.State := Ready;
            Status := Err_Timeout;

            return;
         end if;
      end loop;

      Status := Ok;
   end Wait_Tx_Interrupt_Status;

   ---------------------------------------
   -- Wait_Transfer_Complete_Reset_Flag --
   ---------------------------------------

   procedure Wait_Transfer_Complete_Reset_Flag
     (Port    : in out I2C_Port;
      Timeout : Natural;
      Status  : out I2C_Status)
   is
      Start : constant Time := Clock;
   begin
      while not Interrupt_Status (Port, Transfer_Complete_Reload) loop
         if Timeout > 0
           and then Start + Milliseconds (Timeout) < Clock
         then
            Reset_Config (Port);
            Status := Err_Timeout;
            Port.State := Ready;

            return;
         end if;
      end loop;

      Status := Ok;
   end Wait_Transfer_Complete_Reset_Flag;

   --------------------
   -- Wait_Stop_Flag --
   --------------------

   procedure Wait_Stop_Flag
     (Port    : in out I2C_Port;
      Timeout : Natural;
      Status  : out I2C_Status)
   is
      Start : constant Time := Clock;
   begin
      while not Interrupt_Status (Port, Stop_Detection) loop
         Check_Nack (Port, Timeout, Status);

         if Status /= Ok then
            Port.State := Ready;
            Status := Err_Error;

            return;
         end if;

         if Timeout > 0
           and then Start + Milliseconds (Timeout) < Clock
         then
            Reset_Config (Port);
            Status := Err_Timeout;
            Port.State := Ready;

            return;
         end if;
      end loop;

      --  Clear the stop flag
      Port.Periph.ICR.STOPCF := True;

      Status := Ok;
   end Wait_Stop_Flag;

   -------------------------
   -- Tx_Data_Register_Flush --
   -------------------------

   procedure Tx_Data_Register_Flush (This : in out I2C_Port) is
   begin
      This.Periph.ISR.TXE := True;
   end Tx_Data_Register_Flush;

   --------------------------------
   -- Tx_Data_Register_Gen_Event --
   --------------------------------

   procedure Tx_Data_Register_Gen_Event (This : in out I2C_Port) is
   begin
      if This.Periph.CR1.NOSTRETCH = True then
         This.Periph.ISR.TXIS := True;
      end if;
   end Tx_Data_Register_Gen_Event;

   ---------------------
   -- Wait_While_Flag --
   ---------------------

   procedure Wait_While_Flag
     (This    : in out I2C_Port;
      Flag    :        Interrupt_Status_Flag;
      F_State :        Boolean;
      Timeout :        Natural;
      Status  :    out HAL.I2C.I2C_Status)
   is
      Deadline : constant Time := Clock + Milliseconds (Timeout);
   begin
      while Interrupt_Status (This, Flag) = F_State loop
         if Clock > Deadline then
            This.State := Ready;
            Status := HAL.I2C.Err_Timeout;
            return;
         end if;
      end loop;

      Status := HAL.I2C.Ok;
   end Wait_While_Flag;

   ------------------------------
   -- Tx_Data_Register_Address --
   ------------------------------

   function Tx_Data_Register_Address
     (This : I2C_Port)
      return System.Address
   is (This.Periph.TXDR'Address);

   ------------------------------
   -- Rx_Data_Register_Address --
   ------------------------------

   function Rx_Data_Register_Address
     (This : I2C_Port)
      return System.Address
   is (This.Periph.RXDR'Address);

   ------------------
   -- Set_I2C_Port --
   ------------------

   procedure Set_I2C_Port
     (This    : I2C_Port;
      Enabled : Boolean)
   is
   begin
      This.Periph.CR1.PE := Enabled;
   end Set_I2C_Port;

   ------------------
   -- Port_Enabled --
   ------------------

   function Port_Enabled (This : I2C_Port) return Boolean
   is
   begin
      return This.Periph.CR1.PE;
   end Port_Enabled;

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (This          : in out I2C_Port;
      Configuration : I2C_Configuration)
   is
   begin
      if This.State /= Reset then
         return;
      end if;

      This.Config := Configuration;

      --  Disable the I2C port
      Set_I2C_Port (This, False);

      --  Reset the timing register to Standard mode 100_000 Hz.
      --  The STM32CubeMX tool calculates and provides the I2C_TIMINGR content
      --  in the I2C configuration window.
      --  For the STM32F334R8 nucleo board, the I2C Clock Mux has two options:
      --                    PRESC   SCLDEL   SDADEL   SCLH       SCLL
      --  HSI (8 MHz)       2       0        0        9 (09)     14 (0E)
      --  SYSCLK (72 MHz)   1       8        0        141 (8D)   211 (D3)
      This.Periph.TIMINGR :=
        (SCLL   => 211,
         SCLH   => 141,
         SDADEL => 0,
         SCLDEL => 8,
         PRESC  => 1,
         others => <>);

      --  I2C Own Address Register configuration
      This.Periph.OAR1.OA1EN := False;

      if Configuration.Own_Address /= 0 then
         This.Periph.OAR1 :=
           (OA1     => Configuration.Own_Address,
            OA1EN   => True,
            OA1MODE => Configuration.Addressing_Mode = Addressing_Mode_10bit,
            others  => <>);
      end if;

      --  CR2 configuration
      --  Enable AUTOEND by default, set NACK (should be disabled only in
      --  slave mode
      This.Periph.CR2.ADD10 :=
        Configuration.Addressing_Mode = Addressing_Mode_10bit;
      This.Periph.CR2.AUTOEND := True;
      This.Periph.CR2.NACK := True;

      --  OAR2 configuration
      --  ??? Add support for dual addressing
      This.Periph.OAR2 := (others => <>);

      --  CR1 configuration
      This.Periph.CR1 :=
        (GCEN      => Configuration.General_Call_Enabled,
         NOSTRETCH => False,
         others    => <>);

      if Configuration.Enable_DMA then
         This.Periph.CR1.TXDMAEN := True;
         This.Periph.CR1.RXDMAEN := True;
      end if;

      This.State := Ready;
      --  Enable the port
      Set_I2C_Port (This, True);
   end Configure;

   -------------------
   -- Is_Configured --
   -------------------

   function Is_Configured (Port : I2C_Port) return Boolean
   is
   begin
      return Port.State /= Reset;
   end Is_Configured;

   ----------------------
   -- Setup_I2C_Master --
   ----------------------

   procedure Setup_I2C_Master (Port           : in out I2C_Port'Class;
                               SDA, SCL       : GPIO_Point;
                               SDA_AF, SCL_AF : GPIO_Alternate_Function;
                               Clock_Speed    : UInt32)
   is
      use STM32.Device;
      I2C_Conf : I2C_Configuration;
   begin
      if Port_Enabled (Port) then
         return;
      end if;

      --  GPIO --
      Enable_Clock (SDA & SCL);

      Configure_IO (SDA,
                    (Mode           => Mode_AF,
                     AF             => SDA_AF,
                     AF_Speed       => Speed_High,
                     AF_Output_Type => Open_Drain,
                     Resistors      => Floating));
      Configure_IO (SCL,
                    (Mode           => Mode_AF,
                     AF             => SCL_AF,
                     AF_Speed       => Speed_High,
                     AF_Output_Type => Open_Drain,
                     Resistors      => Floating));
      Lock (SDA & SCL);

      -- I2C --

      Enable_Clock (Port);
      Delay_Until (Clock + Milliseconds (200));
      Reset (Port);

      I2C_Conf.Own_Address := 16#00#;
      I2C_Conf.Addressing_Mode := Addressing_Mode_7bit;
      I2C_Conf.General_Call_Enabled := False;
      I2C_Conf.Clock_Stretching_Enabled := True;

      I2C_Conf.Clock_Speed := Clock_Speed;
      I2C_Conf.Enable_DMA  := True;

      Port.Configure (I2C_Conf);
   end Setup_I2C_Master;

   ---------------------
   -- Master_Transmit --
   ---------------------

   overriding
   procedure Master_Transmit
     (This    : in out I2C_Port;
      Addr    : I2C_Address;
      Data    : I2C_Data;
      Status  : out I2C_Status;
      Timeout : Natural := 1000)
   is
      Size_Temp   : Natural := 0;
      Transmitted : Natural := 0;

   begin
      if This.Periph.ISR.BUSY then
         Status := Busy;
         return;
      end if;

      if Data'Length = 0 then
         Status := Err_Error;
         return;
      end if;

      if This.State /= Ready then
         Status := Busy;
         return;
      end if;

      This.State := Master_Busy_Tx;

      --  Initiate the transfer
      if Data'Length > 255 then
         Config_Transfer
           (This, Addr, 255, Reload_Mode, Generate_Start_Write);
         Size_Temp := 255;
      else
         Config_Transfer
           (This, Addr, Data'Length, Autoend_Mode, Generate_Start_Write);
         Size_Temp := Data'Length;
      end if;

      --  Transfer the data
      while Transmitted < Data'Length loop
         Wait_Tx_Interrupt_Status (This, Timeout, Status);

         if Status /= Ok then
            return;
         end if;

         This.Periph.TXDR.TXDATA := Data (Data'First + Transmitted);
         Transmitted := Transmitted + 1;

         if Transmitted = Size_Temp
           and then Transmitted < Data'Length
         then
            --  Wait for the Transfer complete reload flag
            Wait_Transfer_Complete_Reset_Flag (This, Timeout, Status);
            if Status /= Ok then
               return;
            end if;

            if Data'Length - Transmitted > 255 then
               Config_Transfer
                 (This, Addr, 255, Reload_Mode, No_Start_Stop);
               Size_Temp := 255;
            else
               Config_Transfer
                 (This, Addr, UInt8 (Data'Length - Transmitted), Autoend_Mode,
                  No_Start_Stop);
               Size_Temp := Data'Length - Transmitted;
            end if;
         end if;
      end loop;

      Wait_Stop_Flag (This, Timeout, Status);
      if Status /= Ok then
         return;
      end if;

      --  Reset CR2
      Reset_Config (This);
      This.State := Ready;
      Status       := Ok;
   end Master_Transmit;

   --------------------
   -- Master_Receive --
   --------------------

   overriding
   procedure Master_Receive
     (This    : in out I2C_Port;
      Addr    : I2C_Address;
      Data    : out I2C_Data;
      Status  : out I2C_Status;
      Timeout : Natural := 1000)
   is
      Size_Temp   : Natural := 0;
      Transmitted : Natural := 0;
   begin
      if This.Periph.ISR.BUSY then
         Status := Busy;
         return;
      end if;

      if This.State /= Ready then
         Status := Busy;
         return;
      end if;

      This.State := Master_Busy_Rx;

      if Data'Length = 0 then
         Status := Err_Error;
         return;
      end if;

      --  Initiate the transfer
      if Data'Length > 255 then
         Config_Transfer
           (This, Addr, 255, Reload_Mode, Generate_Start_Read);
         Size_Temp := 255;
      else
         Config_Transfer
           (This, Addr, Data'Length, Autoend_Mode, Generate_Start_Read);
         Size_Temp := Data'Length;
      end if;

      --  Transfer the data
      while Transmitted < Data'Length loop
         while not This.Periph.ISR.RXNE loop
            null;
         end loop;

         Data (Data'First + Transmitted) := This.Periph.RXDR.RXDATA;
         Transmitted := Transmitted + 1;
         Size_Temp   := Size_Temp - 1;

         if Size_Temp = 0
           and then Transmitted < Data'Length
         then
            --  Wait for the Transfer complete reload flag
            while This.Periph.ISR.TCR loop
               null;
            end loop;

            if Data'Length - Transmitted > 255 then
               Config_Transfer
                 (This, Addr, 255, Reload_Mode, No_Start_Stop);
               Size_Temp := 255;
            else
               Config_Transfer
                 (This, Addr, UInt8 (Data'Length - Transmitted), Autoend_Mode,
                  No_Start_Stop);
               Size_Temp := Data'Length - Transmitted;
            end if;
         end if;
      end loop;

      Wait_Stop_Flag (This, Timeout, Status);
      if Status /= Ok then
         return;
      end if;

      --  Reset CR2
      Reset_Config (This);
      This.State := Ready;
      Status       := Ok;
   end Master_Receive;

   ---------------
   -- Mem_Write --
   ---------------

   overriding
   procedure Mem_Write
     (This          : in out I2C_Port;
      Addr          : I2C_Address;
      Mem_Addr      : UInt16;
      Mem_Addr_Size : I2C_Memory_Address_Size;
      Data          : I2C_Data;
      Status        : out I2C_Status;
      Timeout       : Natural := 1000)
   is
      Size_Temp   : Natural := 0;
      Transmitted : Natural := 0;
      Start       : Time;

   begin
      Start := Clock;
      while This.Periph.ISR.BUSY loop
         if Clock > Start + Milliseconds (Timeout) then
            Status := Busy;
            return;
         end if;
      end loop;

      if Data'Length = 0 then
         Status := Err_Error;
         return;
      end if;

      if This.State /= Ready then
         Status := Busy;
         return;
      end if;

      This.State := Mem_Busy_Tx;

      --  Configure the memory transfer
      Config_Transfer
        (This,
         Addr,
         (case Mem_Addr_Size is
             when Memory_Size_8b  => 1,
             when Memory_Size_16b => 2),
         Reload_Mode,
         Generate_Start_Write);

      Wait_Tx_Interrupt_Status (This, Timeout, Status);

      if Status /= Ok then
         This.State := Ready;

         return;
      end if;

      case Mem_Addr_Size is
         when Memory_Size_8b =>
            This.Periph.TXDR.TXDATA := UInt8 (Mem_Addr);

         when Memory_Size_16b =>
            declare
               MSB : constant UInt8 := UInt8 (Shift_Right (Mem_Addr, 8));
               LSB : constant UInt8 := UInt8 (Mem_Addr and 16#FF#);
            begin
               This.Periph.TXDR.TXDATA := MSB;

               Wait_Tx_Interrupt_Status (This, Timeout, Status);
               if Status /= Ok then
                  return;
               end if;

               This.Periph.TXDR.TXDATA := LSB;
            end;
      end case;

      Wait_Transfer_Complete_Reset_Flag (This, Timeout, Status);

      if Status /= Ok then
         return;
      end if;

      --  Initiate the transfer
      if Data'Length > 255 then
         Config_Transfer
           (This, Addr, 255, Reload_Mode, No_Start_Stop);
         Size_Temp := 255;
      else
         Config_Transfer
           (This, Addr, Data'Length, Autoend_Mode, No_Start_Stop);
         Size_Temp := Data'Length;
      end if;

      --  Transfer the data
      while Transmitted < Data'Length loop
         Wait_Tx_Interrupt_Status (This, Timeout, Status);

         if Status /= Ok then
            return;
         end if;

         This.Periph.TXDR.TXDATA := Data (Data'First + Transmitted);
         Transmitted := Transmitted + 1;

         if Transmitted = Size_Temp
           and then Transmitted < Data'Length
         then
            --  Wait for the Transfer complete reload flag
            Wait_Transfer_Complete_Reset_Flag (This, Timeout, Status);

            if Status /= Ok then
               return;
            end if;

            if Data'Length - Transmitted > 255 then
               Config_Transfer
                 (This, Addr, 255, Reload_Mode, No_Start_Stop);
               Size_Temp := 255;
            else
               Config_Transfer
                 (This, Addr,
                  UInt8 (Data'Length - Transmitted),
                  Autoend_Mode,
                  No_Start_Stop);
               Size_Temp := Data'Length - Transmitted;
            end if;
         end if;
      end loop;

      Wait_Stop_Flag (This, Timeout, Status);
      if Status /= Ok then
         return;
      end if;

      --  Reset CR2
      Reset_Config (This);
      This.State := Ready;
      Status       := Ok;
   end Mem_Write;

   --------------
   -- Mem_Read --
   --------------

   overriding
   procedure Mem_Read
     (This          : in out I2C_Port;
      Addr          : I2C_Address;
      Mem_Addr      : UInt16;
      Mem_Addr_Size : I2C_Memory_Address_Size;
      Data          : out I2C_Data;
      Status        : out I2C_Status;
      Timeout       : Natural := 1000)
   is
      Size_Temp   : Natural := 0;
      Transmitted : Natural := 0;
      Start       : Time;

   begin
      Start := Clock;

      while This.Periph.ISR.BUSY loop
         if Clock > Start + Milliseconds (Timeout) then
            Status := Busy;
            return;
         end if;
      end loop;

      if Data'Length = 0 then
         Status := Err_Error;
         return;
      end if;

      if This.State /= Ready then
         Status := Busy;
         return;
      end if;

      This.State := Mem_Busy_Rx;

      --  Configure the memory transfer
      Config_Transfer
        (This,
         Addr,
         (case Mem_Addr_Size is
             when Memory_Size_8b  => 1,
             when Memory_Size_16b => 2),
         Softend_Mode,
         Generate_Start_Write);

      Wait_Tx_Interrupt_Status (This, Timeout, Status);

      if Status /= Ok then
         return;
      end if;

      case Mem_Addr_Size is
         when Memory_Size_8b =>
            This.Periph.TXDR.TXDATA := UInt8 (Mem_Addr);

         when Memory_Size_16b =>
            declare
               MSB : constant UInt8 := UInt8 (Shift_Right (Mem_Addr, 8));
               LSB : constant UInt8 := UInt8 (Mem_Addr and 16#FF#);
            begin
               This.Periph.TXDR.TXDATA := MSB;

               Wait_Tx_Interrupt_Status (This, Timeout, Status);

               if Status /= Ok then
                  return;
               end if;

               This.Periph.TXDR.TXDATA := LSB;
            end;
      end case;

      --  Wait for transfer complete
      while not This.Periph.ISR.TC loop
         null;
      end loop;

      --  Initiate the transfer
      if Data'Length > 255 then
         Config_Transfer
           (This, Addr, 255, Reload_Mode, Generate_Start_Read);
         Size_Temp := 255;
      else
         Config_Transfer
           (This, Addr, Data'Length, Autoend_Mode, Generate_Start_Read);
         Size_Temp := Data'Length;
      end if;

      --  Transfer the data
      while Transmitted < Data'Length loop
         while not This.Periph.ISR.RXNE loop
            null;
         end loop;

         Data (Data'First + Transmitted) := This.Periph.RXDR.RXDATA;
         Transmitted := Transmitted + 1;
         Size_Temp   := Size_Temp - 1;

         if Size_Temp = 0
           and then Transmitted < Data'Length
         then
            --  Wait for the Transfer complete reload flag
            while not This.Periph.ISR.TCR loop
               null;
            end loop;

            if Data'Length - Transmitted > 255 then
               Config_Transfer
                 (This, Addr, 255, Reload_Mode, No_Start_Stop);
               Size_Temp := 255;
            else
               Config_Transfer
                 (This, Addr,
                  UInt8 (Data'Length - Transmitted),
                  Autoend_Mode,
                  No_Start_Stop);
               Size_Temp := Data'Length - Transmitted;
            end if;
         end if;
      end loop;

      Wait_Stop_Flag (This, Timeout, Status);
      if Status /= Ok then
         return;
      end if;

      --  Reset CR2
      Reset_Config (This);
      This.State := Ready;
      Status       := Ok;
   end Mem_Read;

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_Interrupt
     (This   : in out I2C_Port;
      Source : I2C_Interrupt)
   is
   begin
      case Source is
         when Tx_Interrupt =>
            This.Periph.CR1.TXIE := True;
         when Rx_Interrupt =>
            This.Periph.CR1.RXIE := True;
         when Addr_Match_Interrupt =>
            This.Periph.CR1.ADDRIE := True;
         when Not_Ack_Received_Interrupt =>
            This.Periph.CR1.NACKIE := True;
         when Stop_Detection_Interrupt =>
            This.Periph.CR1.STOPIE := True;
         when Transfer_Complete_Interrupt =>
            This.Periph.CR1.TCIE := True;
         when Errors_Detected_Interrupt =>
            This.Periph.CR1.ERRIE := True;
      end case;
   end Enable_Interrupt;

   -----------------------
   -- Disable_Interrupt --
   -----------------------

   procedure Disable_Interrupt
     (This   : in out I2C_Port;
      Source : I2C_Interrupt)
   is
   begin
      case Source is
         when Tx_Interrupt =>
            This.Periph.CR1.TXIE := False;
         when Rx_Interrupt =>
            This.Periph.CR1.RXIE := False;
         when Addr_Match_Interrupt =>
            This.Periph.CR1.ADDRIE := False;
         when Not_Ack_Received_Interrupt =>
            This.Periph.CR1.NACKIE := False;
         when Stop_Detection_Interrupt =>
            This.Periph.CR1.STOPIE := False;
         when Transfer_Complete_Interrupt =>
            This.Periph.CR1.TCIE := False;
         when Errors_Detected_Interrupt =>
            This.Periph.CR1.ERRIE := False;
      end case;
   end Disable_Interrupt;

   -----------------------
   -- Interrupt_Enabled --
   -----------------------

   function Interrupt_Enabled
     (This   : I2C_Port;
      Source : I2C_Interrupt)
      return Boolean
   is
   begin
      case Source is
         when Tx_Interrupt =>
            return This.Periph.CR1.TXIE;
         when Rx_Interrupt =>
            return This.Periph.CR1.RXIE;
         when Addr_Match_Interrupt =>
            return This.Periph.CR1.ADDRIE;
         when Not_Ack_Received_Interrupt =>
            return This.Periph.CR1.NACKIE;
         when Stop_Detection_Interrupt =>
            return This.Periph.CR1.STOPIE;
         when Transfer_Complete_Interrupt =>
            return This.Periph.CR1.TCIE;
         when Errors_Detected_Interrupt =>
            return This.Periph.CR1.ERRIE;
      end case;
   end Interrupt_Enabled;

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_DMA
     (This   : in out I2C_Port;
      Source : I2C_DMA)
   is
   begin
      case Source is
         when Tx_DMA =>
            This.Periph.CR1.TXDMAEN := True;
         when Rx_DMA =>
            This.Periph.CR1.RXDMAEN := True;
      end case;
   end Enable_DMA;

   -----------------
   -- Disable_DMA --
   -----------------

   procedure Disable_DMA
     (This   : in out I2C_Port;
      Source : I2C_DMA)
   is
   begin
      case Source is
         when Tx_DMA =>
            This.Periph.CR1.TXDMAEN := False;
         when Rx_DMA =>
            This.Periph.CR1.RXDMAEN := False;
      end case;
   end Disable_DMA;

   -----------------
   -- DMA_Enabled --
   -----------------

   function DMA_Enabled
     (This   : I2C_Port;
      Source : I2C_DMA)
      return Boolean
   is
   begin
      case Source is
         when Tx_DMA =>
            return This.Periph.CR1.TXDMAEN;
         when Rx_DMA =>
            return This.Periph.CR1.RXDMAEN;
      end case;
   end DMA_Enabled;

   ----------------------
   -- Interrupt_Status --
   ----------------------

   function Interrupt_Status
     (This : I2C_Port; Flag : Interrupt_Status_Flag) return Boolean
   is
   begin
      case Flag is
         when Tx_Data_Register_Empty =>
            return This.Periph.ISR.TXE;
         when Tx_Data_Register_Empty_Interrupt =>
            return This.Periph.ISR.TXIS;
         when Rx_Data_Register_Not_Empty =>
            return This.Periph.ISR.RXNE;
         when Address_Matched =>
            return This.Periph.ISR.ADDR;
         when Ack_Failure =>
            return This.Periph.ISR.NACKF;
         when Stop_Detection =>
            return This.Periph.ISR.STOPF;
         when Transfer_Complete =>
            return This.Periph.ISR.TC;
         when Transfer_Complete_Reload =>
            return This.Periph.ISR.TCR;
         when Bus_Error =>
            return This.Periph.ISR.BERR;
         when Arbitration_Lost =>
            return This.Periph.ISR.ARLO;
         when UnderOverrun =>
            return This.Periph.ISR.OVR;
         when Packet_Error =>
            return This.Periph.ISR.PECERR;
         when Timeout =>
            return This.Periph.ISR.TIMEOUT;
         when SMB_Alert =>
            return This.Periph.ISR.ALERT;
         when Bus_Busy =>
            return This.Periph.ISR.BUSY;
         when Transmitter_Receiver_Mode =>
            return This.Periph.ISR.DIR;
      end case;
   end Interrupt_Status;

   ----------------------------
   -- Clear_Interrupt_Status --
   ----------------------------

   procedure Clear_Interrupt_Status
     (This   : in out I2C_Port;
      Target : Clearable_Interrupt_Status)
   is
   begin
      case Target is
         when Address_Matched =>
            This.Periph.ICR.ADDRCF := True;
         when Ack_Failure =>
            This.Periph.ICR.NACKCF := True;
         when Stop_Detection =>
            This.Periph.ICR.STOPCF := True;
         when Bus_Error =>
            This.Periph.ICR.BERRCF := True;
         when Arbitration_Lost =>
            This.Periph.ICR.ARLOCF := True;
         when UnderOverrun =>
            This.Periph.ICR.OVRCF := True;
         when Packet_Error =>
            This.Periph.ICR.PECCF := True;
         when Timeout =>
            This.Periph.ICR.TIMOUTCF := True;
         when SMB_Alert =>
            This.Periph.ICR.ALERTCF := True;
      end case;
   end Clear_Interrupt_Status;

end STM32.I2C;
