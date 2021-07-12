
with STM32.SYSCFG;

package body STM32.COMP is

   ------------
   -- Enable --
   ------------

   procedure Enable (This : in out Comparator) is
      use STM32.SYSCFG;
   begin
      --  Enable clock for the SYSCFG_COMP_OPAMP peripheral
      Enable_SYSCFG_Clock;
      
      This.CSR.COMPxEN := True;
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable (This : in out Comparator) is
   begin
      This.CSR.COMPxEN := False;
   end Disable;

   -------------
   -- Enabled --
   -------------

   function Enabled (This : Comparator) return Boolean is
   begin
      return This.CSR.COMPxEN;
   end Enabled;

   ------------------------------
   -- Set_Inverting_Input_Port --
   ------------------------------

   procedure Set_Inverting_Input_Port
     (This  : in out Comparator;
      Input : Inverting_Input_Port) is
   begin
      if Input'Enum_Rep > 7 then
         This.CSR.COMPxINMSEL_3 := True;
      else
         This.CSR.COMPxINMSEL_3 := False;
      end if;
      This.CSR.COMPxINMSEL := UInt3 (Input'Enum_Rep);
   end Set_Inverting_Input_Port;

   -------------------------------
   -- Read_Inverting_Input_Port --
   -------------------------------

   function Read_Inverting_Input_Port
     (This : Comparator) return Inverting_Input_Port
   is      
      Value : UInt4;
   begin
      if This.CSR.COMPxINMSEL_3 = True then
         Value := UInt4 (This.CSR.COMPxINMSEL) + 8;
      else
         Value := UInt4 (This.CSR.COMPxINMSEL);
      end if;
      return Inverting_Input_Port'Val (Value);         
   end Read_Inverting_Input_Port;

   ----------------------
   -- Set_Output_Timer --
   ----------------------

   procedure Set_Output_Timer (This   : in out Comparator;
                               Output : Output_Selection) is
   begin
      This.CSR.COMPxOUTSEL := Output'Enum_Rep;
   end Set_Output_Timer;

   -----------------------
   -- Read_Output_Timer --
   -----------------------

   function Read_Output_Timer (This : Comparator) return Output_Selection is
   begin
      return Output_Selection'Val (This.CSR.COMPxOUTSEL);
   end Read_Output_Timer;

   -------------------------
   -- Set_Output_Polarity --
   -------------------------

   procedure Set_Output_Polarity (This   : in out Comparator;
                                  Output : Output_Polarity) is
   begin
      This.CSR.COMPxPOL := Output = Inverted;
   end Set_Output_Polarity;

   --------------------------
   -- Read_Output_Polarity --
   --------------------------

   function Read_Output_Polarity (This : Comparator) return Output_Polarity is
   begin
      if This.CSR.COMPxPOL = True then
         return Inverted;
      else
         return Not_Inverted;
      end if;
   end Read_Output_Polarity;

   -------------------------
   -- Set_Output_Blanking --
   -------------------------

   procedure Set_Output_Blanking (This   : in out Comparator;
                                  Output : Output_Blanking) is
   begin
      This.CSR.COMPx_BLANKING := Output'Enum_Rep;
   end Set_Output_Blanking;

   --------------------------
   -- Read_Output_Blanking --
   --------------------------

   function Read_Output_Blanking (This : Comparator) return Output_Blanking is
   begin
      Return Output_Blanking'Val (This.CSR.COMPx_BLANKING);
   end Read_Output_Blanking;

   ----------------------------
   -- Read_Comparator_Output --
   ----------------------------

   function Read_Comparator_Output
     (This : Comparator) return Comparator_Output is
   begin
      if This.CSR.COMPxOUT = True then
         return High;
      else
         return Low;
      end if;
   end Read_Comparator_Output;      

   -------------------------
   -- Set_Lock_Comparator --
   -------------------------

   procedure Set_Lock_Comparator (This : in out Comparator) is
   begin
      This.CSR.COMPxLOCK := True;
   end Set_Lock_Comparator;

   --------------------------
   -- Read_Lock_Comparator --
   --------------------------

   function Read_Lock_Comparator (This : Comparator) return Boolean is
   begin
      return This.CSR.COMPxLOCK;
   end Read_Lock_Comparator;

end STM32.COMP;
