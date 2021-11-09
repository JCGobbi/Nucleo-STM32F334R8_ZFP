------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2015, AdaCore                           --
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

with Ada.Unchecked_Conversion;
with STM32_SVD.RCC; use STM32_SVD.RCC;
with STM32_SVD.PWR;    use STM32_SVD.PWR;
with STM32_SVD.SYSCFG; use STM32_SVD.SYSCFG;
with STM32_SVD.Flash;  use STM32_SVD.Flash;

package body STM32.RCC is

   function To_AHBRSTR_T is new Ada.Unchecked_Conversion
     (UInt32, AHBRSTR_Register);
   function To_APB1RSTR_T is new Ada.Unchecked_Conversion
     (UInt32, APB1RSTR_Register);
   function To_APB2RSTR_T is new Ada.Unchecked_Conversion
     (UInt32, APB2RSTR_Register);

   ---------------------------------------------------------------------------
   -------  Enable/Disable/Reset Routines  -----------------------------------
   ---------------------------------------------------------------------------

   procedure BKPSRAM_Clock_Enable is
   begin
      RCC_Periph.AHBENR.SRAMEN := True;
   end BKPSRAM_Clock_Enable;

   procedure AHB_Force_Reset is
   begin
      RCC_Periph.AHBRSTR := To_AHBRSTR_T (16#FFFF_FFFF#);
   end AHB_Force_Reset;

   procedure AHB_Release_Reset is
   begin
      RCC_Periph.AHBRSTR := To_AHBRSTR_T (0);
   end AHB_Release_Reset;

   procedure APB1_Force_Reset is
   begin
      RCC_Periph.APB1RSTR := To_APB1RSTR_T (16#FFFF_FFFF#);
   end APB1_Force_Reset;

   procedure APB1_Release_Reset is
   begin
      RCC_Periph.APB1RSTR := To_APB1RSTR_T (0);
   end APB1_Release_Reset;

   procedure APB2_Force_Reset is
   begin
      RCC_Periph.APB2RSTR := To_APB2RSTR_T (16#FFFF_FFFF#);
   end APB2_Force_Reset;

   procedure APB2_Release_Reset is
   begin
      RCC_Periph.APB2RSTR := To_APB2RSTR_T (0);
   end APB2_Release_Reset;

   procedure Backup_Domain_Reset is
   begin
      RCC_Periph.BDCR.BDRST := True;
      RCC_Periph.BDCR.BDRST := False;
   end Backup_Domain_Reset;

   ---------------------------------------------------------------------------
   --  Clock Configuration  --------------------------------------------------
   ---------------------------------------------------------------------------

   -------------------
   -- Set_HSE Clock --
   -------------------

   procedure Set_HSE_Clock
     (Enable     : Boolean;
      Bypass     : Boolean := False;
      Enable_CSS : Boolean := False)
   is
   begin
      if Enable and not RCC_Periph.CR.HSEON then
         RCC_Periph.CR.HSEON := True;
         loop
            exit when RCC_Periph.CR.HSERDY;
         end loop;
      end if;
      RCC_Periph.CR.HSEBYP := Bypass;
      RCC_Periph.CR.CSSON := Enable_CSS;
   end Set_HSE_Clock;

   -----------------------
   -- HSE Clock_Enabled --
   -----------------------

   function HSE_Clock_Enabled return Boolean is
   begin
      return RCC_Periph.CR.HSEON;
   end HSE_Clock_Enabled;

   -------------------
   -- Set_LSE Clock --
   -------------------

   procedure Set_LSE_Clock
     (Enable     : Boolean;
      Bypass     : Boolean := False;
      Capability : HSE_Capability)
   is
   begin
      if Enable and not RCC_Periph.BDCR.LSEON then
         RCC_Periph.BDCR.LSEON := True;
         loop
            exit when RCC_Periph.BDCR.LSERDY;
         end loop;
      end if;
      RCC_Periph.BDCR.LSEBYP := Bypass;
      RCC_Periph.BDCR.LSEDRV := Capability'Enum_Rep;
   end Set_LSE_Clock;

   -----------------------
   -- LSE Clock_Enabled --
   -----------------------

   function LSE_Clock_Enabled return Boolean is
   begin
      return RCC_Periph.BDCR.LSEON;
   end LSE_Clock_Enabled;

   -------------------
   -- Set_HSI_Clock --
   -------------------

   procedure Set_HSI_Clock (Enable : Boolean) is
   begin
      if Enable then
         if not RCC_Periph.CR.HSION then
            RCC_Periph.CR.HSION := True;
            loop
               exit when RCC_Periph.CR.HSIRDY;
            end loop;
         end if;
      else
         RCC_Periph.CR.HSION := False;
      end if;
   end Set_HSI_Clock;

   -----------------------
   -- HSI_Clock_Enabled --
   -----------------------

   function HSI_Clock_Enabled return Boolean is
   begin
      return RCC_Periph.CR.HSION;
   end HSI_Clock_Enabled;

   -------------------
   -- Set_LSI Clock --
   -------------------

   procedure Set_LSI_Clock (Enable : Boolean) is
   begin
      if Enable and not RCC_Periph.CSR.LSION then
         RCC_Periph.CSR.LSION := True;
         loop
            exit when RCC_Periph.CSR.LSIRDY;
         end loop;
      end if;
   end Set_LSI_Clock;

   -----------------------
   -- LSI Clock_Enabled --
   -----------------------

   function LSI_Clock_Enabled return Boolean is
   begin
      return RCC_Periph.CSR.LSION;
   end LSI_Clock_Enabled;

   --------------------------------
   -- Configure_System_Clock_Mux --
   --------------------------------

   procedure Configure_System_Clock_Mux (Source : SYSCLK_Clock_Source)
   is
   begin
      RCC_Periph.CFGR.SW := Source'Enum_Rep;
      loop
         exit when RCC_Periph.CFGR.SWS = Source'Enum_Rep;
      end loop;
   end Configure_System_Clock_Mux;

   -----------------------------------
   -- Configure_AHB_Clock_Prescaler --
   -----------------------------------

   procedure Configure_AHB_Clock_Prescaler
     (Value : AHB_Prescaler)
   is
      function To_AHB is new Ada.Unchecked_Conversion
        (AHB_Prescaler, UInt4);
   begin
      RCC_Periph.CFGR.HPRE := To_AHB (Value);
   end Configure_AHB_Clock_Prescaler;

   -----------------------------------
   -- Configure_APB_Clock_Prescaler --
   -----------------------------------

   procedure Configure_APB_Clock_Prescaler
     (Bus   : APB_Clock_Range;
      Value : APB_Prescaler)
   is
      function To_APB is new Ada.Unchecked_Conversion
        (APB_Prescaler, UInt3);
   begin
      case Bus is
         when APB_1 =>
            RCC_Periph.CFGR.PPRE.Arr (1) := To_APB (Value);
         when APB_2 =>
            RCC_Periph.CFGR.PPRE.Arr (2) := To_APB (Value);
      end case;
   end Configure_APB_Clock_Prescaler;

   ------------------------------
   -- Configure_PLL_Source_Mux --
   ------------------------------

   procedure Configure_PLL_Source_Mux (Source : PLL_Clock_Source) is
   begin
         RCC_Periph.CFGR.PLLSRC := Source = PLL_SRC_HSE;
   end Configure_PLL_Source_Mux;

   -------------------
   -- Configure_PLL --
   -------------------

   procedure Configure_PLL
     (Enable : Boolean;
      PREDIV : PREDIV_Range := PREDIV_Range'First;
      PLLMUL : PLLMUL_Range := PLLMUL_Range'First)
   is
   begin
      --  Disable the main PLL before configuring it
      RCC_Periph.CR.PLLON := False;
      loop
         exit when not RCC_Periph.CR.PLLRDY;
      end loop;

      if Enable then
         RCC_Periph.CFGR.PLLMUL := UInt4 (PLLMUL'Enum_Rep - 2);
         RCC_Periph.CFGR2.PREDIV := UInt4 (PREDIV'Enum_Rep - 1);

         --  Setup PLL and wait for stabilization.
         RCC_Periph.CR.PLLON := Enable;
         loop
            exit when RCC_Periph.CR.PLLRDY;
         end loop;
      end if;
   end Configure_PLL;

   --------------------------------
   -- Configure_MCO_Output_Clock --
   --------------------------------

   procedure Configure_MCO_Output_Clock
     (Source : MCO_Clock_Source;
      Value  : MCO_Prescaler;
      Nodiv  : Boolean := False)
   is
   begin
      RCC_Periph.CFGR.MCO := Source'Enum_Rep;
      RCC_Periph.CFGR.MCOPRE := Value'Enum_Rep;
      RCC_Periph.CFGR.PLLNODIV := Nodiv;
   end Configure_MCO_Output_Clock;

   -----------------------
   -- Set_FLASH_Latency --
   -----------------------

   procedure Set_FLASH_Latency (Latency : FLASH_Wait_State)
   is
   begin
      Flash_Periph.ACR.LATENCY := Latency'Enum_Rep;
   end Set_FLASH_Latency;

end STM32.RCC;
