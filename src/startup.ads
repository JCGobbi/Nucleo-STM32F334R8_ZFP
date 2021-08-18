
--  Initialization is executed only once at power-on and executes
--  routines that set-up peripherals.
package Startup is

   procedure Initialize
   --  Procedure to initialize the board. This procedure must be called before
   --  any other operation. The operations to perform are:
   --    - Hardware initialization
   --       * Any board-specific initialization
   --       * Interrupts
   --       * Timer
   --    - Initialize the floating point unit
   --    - Signal the flag corresponding to the initialization

     with
       Pre => not Is_Initialized;
       --  Initialization can only happen once

   procedure Initialize_Inverter;
   --  Initializes peripherals and configures them into a known state.

   procedure Start_Inverter;
   --  Start the inverter

   function Is_Initialized return Boolean;

private

   Initialized : Boolean := False;
   --  Boolean that indicates whether the basic executive has finished its
   --  initialization.

end Startup;
