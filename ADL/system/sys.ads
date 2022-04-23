--  Root package fot the system drivers of the STM32F334 MCU

package Sys is
   pragma Pure;
   --  Note that we take advantage of the implementation permission to make
   --  this unit Pure instead of Preelaborable; see RM 13.7.1(15). In Ada
   --  2005, this is Pure in any case (AI-362).
   pragma No_Elaboration_Code_All;
   --  Allow the use of that restriction in units that WITH this unit.
end Sys;
