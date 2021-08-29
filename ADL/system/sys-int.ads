--  This package contains the primitives which are dependent on the
--  underlying processor.

pragma Restrictions (No_Elaboration_Code);
--  The kernel initialization routine needs to execute before elaboration.
--  Consequently, packages used by this code cannot require elaboration.

with System; use System;

package SYS.Int is
   --  This file has definitions and routines from the following files:
   --  s-bbcppr, s-bbinte, s-bbbosu, s-multip

   type Word is mod 2**System.Word_Size;

   ----------------
   -- Interrupts --
   ----------------

   Number_Of_Interrupts : constant := 125;

   subtype Interrupt_Range is Integer
     range -1 .. Number_Of_Interrupts;
   --  Number of interrupts for the interrupt controller

   subtype Interrupt_ID is Interrupt_Range;
   --  Interrupt identifiers.

   subtype Any_Interrupt_ID is Integer
     range Interrupt_ID'First .. Interrupt_ID'Last + 1;

   No_Interrupt : constant Any_Interrupt_ID := Any_Interrupt_ID'Last;
   --  Special value indicating no interrupt

   Alarm_Interrupt_ID : constant Interrupt_ID := -1;
   --  Return the interrupt level to use for the alarm clock handler. Note
   --  that we use a "fake" Interrupt_ID for the alarm interrupt, as it is
   --  handled specially (not through the NVIC).

   -------------------
   -- Trap handling --
   -------------------

   --  While on this target there is little difference between interrupts
   --  and traps, we consider the following traps, known as Cortex-M core
   --  interrupts:
   --
   --    Name                        Nr
   --
   --    __stack_end              /* stack top address */
   --    Reset_Handler            /* 1 Reset */
   --    NMI_Handler              /* 2 NMI. */
   --    HardFault_Handler        /* 3 Hard fault. */
   --    MemoryManagement_Handler /* 4 Mem manage. */
   --    BusFault_Handler         /* 5 Bus fault. */
   --    UsageFault_Handler       /* 6 Usage fault. */
   --    SVC_Handler              /* 11 SVCall. */
   --    DebugMon_Handler         /* 12 Breakpoint. */
   --    PendSV_Handler           /* 14 PendSV. */
   --    SysTick_Handler          /* 15 Systick. */
   --
   --  These trap vectors correspond to different low-level trap handlers in
   --  the ZFP run time. They are listed inside the file crt0.S, generated
   --  with the Startut-Gen application. They will be the entry vector where
   --  the handler subroutine will be written.

   Trap_Vectors : constant := 16;
   type Vector_Id is range 0 .. Trap_Vectors - 1;

   ----------------------------
   -- MCU Interrupt handling --
   ----------------------------

   --  The STM32F334 CPU has 125 interrupts, but not all of them will serve
   --  external peripheral interrupts. If we declare the vectors inside the
   --  project file and run the Startup-Gen application, the listed vectors
   --  will be put inside the crt0.S file in the correct vector addresses:
   --
   --    Name                        Nr
   --
   --    __WWDG_handler           /* 0 */
   --    __PVD_handler            /* 1 */
   --    __TAMP_STAMP_handler     /* 2 */
   --    __RTC_WKUP_handler       /* 3 */
   --    __FLASH_handler          /* 4 */
   --    __RCC_handler            /* 5 */
   --    __EXTI0_handler          /* 6 */
   --    __EXTI1_handler          /* 7 */
   --    __EXTI2_handler          /* 8 */
   --    __EXTI3_handler          /* 9 */
   --    __EXTI4_handler          /* 10 */
   --    __DMA1_Channel1_handler  /* 11 */
   --    __DMA1_Channel2_handler  /* 12 */
   --    __DMA1_Channel3_handler  /* 13 */
   --    __DMA1_Channel4_handler  /* 14 */
   --    __DMA1_Channel5_handler  /* 15 */
   --    __DMA1_Channel6_handler  /* 16 */
   --    __DMA1_Channel7_handler  /* 17 */
   --    __ADC1_2_handler         /* 18 */
   --    __USB_HP_CAN_TX_handler  /* 19 */
   --    __USB_LP_CAN_RX0_handler /* 20 */
   --    __CAN_RX1_handler        /* 21 */
   --    __CAN_SCE_handler        /* 22 */
   --    __EXTI9_5_handler        /* 23 */
   --    __TIM1_BRK_TIM15_handler /* 24 */
   --    __TIM1_UP_TIM16_handler  /* 25 */
   --    __TIM1_TRG_COM_TIM17_handler /* 26 */
   --    __TIM1_CC_handler        /* 27 */
   --    __TIM2_handler           /* 28 */
   --    __TIM3_handler           /* 29 */
   --    __unknown_interrupt_handler /* 30 */
   --    __I2C1_EV_EXTI23_handler /* 31 */
   --    __I2C1_ER_handler        /* 32 */
   --    __unknown_interrupt_handler /* 33 */
   --    __unknown_interrupt_handler /* 34 */
   --    __SPI1_handler           /* 35 */
   --    __unknown_interrupt_handler /* 36 */
   --    __USART1_EXTI25_handler  /* 37 */
   --    __USART2_EXTI26_handler  /* 38 */
   --    __USART3_EXTI28_handler  /* 39 */
   --    __EXTI15_10_handler      /* 40 */
   --    __RTC_Alarm_handler      /* 41 */
   --    __unknown_interrupt_handler /* 42 */
   --    ...
   --    __unknown_interrupt_handler /* 53 */
   --    __TIM6_DAC1_handler      /* 54 */
   --    __TIM7_DAC2_handler      /* 55 */
   --    __unknown_interrupt_handler /* 56 */
   --    ...
   --    __unknown_interrupt_handler /* 63 */
   --    __COMP2_handler          /* 64 */
   --    __COMP4_6_handler        /* 65 */
   --    __unknown_interrupt_handler /* 66 */
   --    __HRTIM_Master_handler   /* 67 */
   --    __HRTIM_TIMA_handler     /* 68 */
   --    __HRTIM_TIMB_handler     /* 69 */
   --    __HRTIM_TIMC_handler     /* 70 */
   --    __HRTIM_TIMD_handler     /* 71 */
   --    __HRTIM_TIME_handler     /* 72 */
   --    __HRTIM_TIM_FLT_handler  /* 73 */
   --    __unknown_interrupt_handler /* 74 */
   --    ...
   --    __unknown_interrupt_handler /* 80 */
   --    __FPU_handler            /* 81 */
   --    __unknown_interrupt_handler /* 82 */
   --    ...
   --    __unknown_interrupt_handler /* 124 */

   procedure Initialize_CPU;
   pragma Inline (Initialize_CPU);
   --  Set the CPU up to use the proper stack for interrupts, initialize and
   --  enable system trap handlers.

   procedure Enable_Interrupt_Request
     (Interrupt : Interrupt_ID);
   --  Enable interrupt requests for the given interrupt.

   procedure Disable_Interrupt_Request
     (Interrupt : Interrupt_ID);
   --  Disable interrupt requests for the given interrupt.

   procedure Enable_Interrupts;
   pragma Inline (Enable_Interrupts);
   --  Interrupts are enabled if they are above the value given by Level.

   procedure Disable_Interrupts;
   pragma Inline (Disable_Interrupts);
   --  All external interrupts (asynchronous traps) are disabled. Note
   --  that this will take care of the CPU specific part of enabling and
   --  disabling the interrupts. For systems were this is not sufficient, the
   --  Board_Support.Set_Current_Priority routine must also be implemented in
   --  order to do the board-specific enable/disable operations.

   procedure Wait_For_Interrupt;
   pragma Inline (Wait_For_Interrupt);
   --  Power-down the current CPU and wait for interrupts. This procedure is
   --  called only by the idle task, with interrupt enabled.

private

   procedure GNAT_Error_Handler (Trap : Vector_Id);
   pragma No_Return (GNAT_Error_Handler);

   --  Reset_Handler is already defined at crt0.S, so it is not needed here.
   --  procedure Reset_Handler;
   --  pragma Export (Asm, Reset_Handler, "Reset_Handler");

   procedure NMI_Handler;
   pragma Export (Asm, NMI_Handler, "NMI_Handler");

   procedure Hard_Fault_Handler;
   pragma Export (Asm, Hard_Fault_Handler, "HardFault_Handler");

   procedure Bus_Fault_Handler;
   pragma Export (Asm, Bus_Fault_Handler, "BusFault_Handler");

   procedure Usage_Fault_Handler;
   pragma Export (Asm, Usage_Fault_Handler, "UsageFault_Handler");

   procedure SV_Call_Handler;
   pragma Export (Asm, SV_Call_Handler, "SVC_Handler");

   procedure Pend_SV_Handler;
   pragma Export (Asm, Pend_SV_Handler, "PendSV_Handler");

end SYS.Int;
