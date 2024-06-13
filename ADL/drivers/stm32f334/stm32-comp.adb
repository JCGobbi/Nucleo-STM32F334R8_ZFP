with STM32.SYSCFG;
with Sys.Real_Time;

package body STM32.COMP is

   ------------
   -- Enable --
   ------------

   procedure Enable (This : in out Comparator) is
      use Sys.Real_Time;
   begin
      --  Enable clock for the SYSCFG_COMP_OPAMP peripheral
      STM32.SYSCFG.Enable_SYSCFG_Clock;

      This.CSR.EN := True;
      --  Delay required to reach propagation delay specification.
      Delay_Until (Clock + Microseconds (10));
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable (This : in out Comparator) is
   begin
      This.CSR.EN := False;
   end Disable;

   -------------
   -- Enabled --
   -------------

   function Enabled (This : Comparator) return Boolean is
   begin
      return This.CSR.EN;
   end Enabled;

   ------------------------------
   -- Set_Inverting_Input_Port --
   ------------------------------

   procedure Set_Inverting_Input_Port
     (This  : in out Comparator;
      Input : Inverting_Input_Port) is
   begin
      This.CSR.INMSEL_3 := Input'Enum_Rep > 7;
      This.CSR.INMSEL := UInt3 (Input'Enum_Rep);
   end Set_Inverting_Input_Port;

   ------------------------------
   -- Get_Inverting_Input_Port --
   ------------------------------

   function Get_Inverting_Input_Port
     (This : Comparator) return Inverting_Input_Port
   is
      Value : UInt4;
   begin
      if This.CSR.INMSEL_3 then
         Value := UInt4 (This.CSR.INMSEL) + 8;
      else
         Value := UInt4 (This.CSR.INMSEL);
      end if;
      return Inverting_Input_Port'Enum_Val (Value);
   end Get_Inverting_Input_Port;

   -------------------
   -- Select_Output --
   -------------------

   procedure Select_Output (This   : in out Comparator;
                            Output : Output_Selection) is
   begin
      This.CSR.OUTSEL := Output'Enum_Rep;
   end Select_Output;

   --------------------------
   -- Get_Output_Selection --
   --------------------------

   function Get_Output_Selection (This : Comparator) return Output_Selection is
   begin
      return Output_Selection'Enum_Val (This.CSR.OUTSEL);
   end Get_Output_Selection;

   -------------------------
   -- Set_Output_Polarity --
   -------------------------

   procedure Set_Output_Polarity (This   : in out Comparator;
                                  Output : Output_Polarity) is
   begin
      This.CSR.POL := Output = Inverted;
   end Set_Output_Polarity;

   -------------------------
   -- Get_Output_Polarity --
   -------------------------

   function Get_Output_Polarity (This : Comparator) return Output_Polarity is
   begin
      return Output_Polarity'Enum_Val (Boolean'Pos (This.CSR.POL));
   end Get_Output_Polarity;

   -------------------------
   -- Set_Output_Blanking --
   -------------------------

   procedure Set_Output_Blanking (This   : in out Comparator;
                                  Output : Output_Blanking) is
   begin
      This.CSR.BLANKING := Output'Enum_Rep;
   end Set_Output_Blanking;

   -------------------------
   -- Get_Output_Blanking --
   -------------------------

   function Get_Output_Blanking (This : Comparator) return Output_Blanking is
   begin
      return Output_Blanking'Enum_Val (This.CSR.BLANKING);
   end Get_Output_Blanking;

   --------------------------
   -- Configure_Comparator --
   --------------------------

   procedure Configure_Comparator
     (This  : in out Comparator;
      Param : Init_Parameters)
   is
   begin
      Set_Inverting_Input_Port (This, Param.Input_Minus);
      Select_Output (This, Param.Output_Sel);
      Set_Output_Polarity (This, Param.Output_Pol);
      Set_Output_Blanking (This, Param.Blanking_Source);
   end Configure_Comparator;

   ---------------------------
   -- Get_Comparator_Output --
   ---------------------------

   function Get_Comparator_Output
     (This : Comparator) return Comparator_Output is
   begin
         return Comparator_Output'Enum_Val (Boolean'Pos (This.CSR.OUT_k));
   end Get_Comparator_Output;

   -------------------------
   -- Set_Lock_Comparator --
   -------------------------

   procedure Set_Lock_Comparator (This : in out Comparator) is
   begin
      This.CSR.LOCK := True;
   end Set_Lock_Comparator;

   -------------------------
   -- Get_Lock_Comparator --
   -------------------------

   function Get_Lock_Comparator (This : Comparator) return Boolean is
   begin
      return This.CSR.LOCK;
   end Get_Lock_Comparator;

end STM32.COMP;
