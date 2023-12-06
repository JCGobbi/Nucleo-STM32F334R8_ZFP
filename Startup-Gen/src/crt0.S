/*****************************************************************************
 *                                                                           *
 *                         Copyright (C) 2023 AdaCore                        *
 *                                                                           *
 *  GNAT is free software;  you can  redistribute it  and/or modify it under *
 *  terms of the  GNU General Public License as published  by the Free Soft- *
 *  ware  Foundation;  either version 3,  or (at your option) any later ver- *
 *  sion.  GNAT is distributed in the hope that it will be useful, but WITH- *
 *  OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY *
 *  or FITNESS FOR A PARTICULAR PURPOSE.                                     *
 *                                                                           *
 *  As a special exception under Section 7 of GPL version 3, you are granted *
 *  additional permissions described in the GCC Runtime Library Exception,   *
 *  version 3.1, as published by the Free Software Foundation.               *
 *                                                                           *
 *  You should have received a copy of the GNU General Public License and    *
 *  a copy of the GCC Runtime Library Exception along with this program;     *
 *  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    *
 *  <http://www.gnu.org/licenses/>.                                          *
 *                                                                           *
 *****************************************************************************/

	.syntax unified

#if defined(__SOFTFP__)
	.cpu cortex-m0
#else
        /* FPU support means at least cortex-m4 compatibility */
        .cpu cortex-m4
#endif

        .thumb

	.text
	.globl __vectors
	.p2align 9
	.section .vectors,"a"
__vectors:
	/* Cortex-M core interrupts */
	.word   __stack_end              /* stack top address */
	.word   Reset_Handler            /* 1 Reset */
	.word   NMI_Handler              /* 2 NMI. */
	.word   HardFault_Handler        /* 3 Hard fault. */
	.word   MemoryManagement_Handler /* 4 Mem manage. */
	.word   BusFault_Handler         /* 5 Bus fault. */
	.word   UsageFault_Handler       /* 6 Usage fault. */
	.word   Reserved_Handler         /* 7 reserved. */
	.word   Reserved_Handler         /* 8 reserved. */
	.word   Reserved_Handler         /* 9 reserved. */
	.word   Reserved_Handler         /* 10 reserved. */
	.word   SVC_Handler              /* 11 SVCall. */
	.word   DebugMon_Handler         /* 12 Breakpoint. */
	.word   Reserved_Handler         /* 13 reserved. */
	.word   PendSV_Handler           /* 14 PendSV. */
	.word   SysTick_Handler          /* 15 Systick. */
	/* MCU interrupts */
        .word __WWDG_handler /* 0 */
        .word __PVD_handler /* 1 */
        .word __TAMP_STAMP_handler /* 2 */
        .word __RTC_WKUP_handler /* 3 */
        .word __FLASH_handler /* 4 */
        .word __RCC_handler /* 5 */
        .word __EXTI0_handler /* 6 */
        .word __EXTI1_handler /* 7 */
        .word __EXTI2_handler /* 8 */
        .word __EXTI3_handler /* 9 */
        .word __EXTI4_handler /* 10 */
        .word __DMA1_Channel1_handler /* 11 */
        .word __DMA1_Channel2_handler /* 12 */
        .word __DMA1_Channel3_handler /* 13 */
        .word __DMA1_Channel4_handler /* 14 */
        .word __DMA1_Channel5_handler /* 15 */
        .word __DMA1_Channel6_handler /* 16 */
        .word __DMA1_Channel7_handler /* 17 */
        .word __ADC1_2_handler /* 18 */
        .word __USB_HP_CAN_TX_handler /* 19 */
        .word __USB_LP_CAN_RX0_handler /* 20 */
        .word __CAN_RX1_handler /* 21 */
        .word __CAN_SCE_handler /* 22 */
        .word __EXTI9_5_handler /* 23 */
        .word __TIM1_BRK_TIM15_handler /* 24 */
        .word __TIM1_UP_TIM16_handler /* 25 */
        .word __TIM1_TRG_COM_TIM17_handler /* 26 */
        .word __TIM1_CC_handler /* 27 */
        .word __TIM2_handler /* 28 */
        .word __TIM3_handler /* 29 */
        .word __unknown_interrupt_handler /* 30 */
        .word __I2C1_EV_EXTI23_handler /* 31 */
        .word __I2C1_ER_handler /* 32 */
        .word __unknown_interrupt_handler /* 33 */
        .word __unknown_interrupt_handler /* 34 */
        .word __SPI1_handler /* 35 */
        .word __unknown_interrupt_handler /* 36 */
        .word __USART1_EXTI25_handler /* 37 */
        .word __USART2_EXTI26_handler /* 38 */
        .word __USART3_EXTI28_handler /* 39 */
        .word __EXTI15_10_handler /* 40 */
        .word __RTC_Alarm_handler /* 41 */
        .word __unknown_interrupt_handler /* 42 */
        .word __unknown_interrupt_handler /* 43 */
        .word __unknown_interrupt_handler /* 44 */
        .word __unknown_interrupt_handler /* 45 */
        .word __unknown_interrupt_handler /* 46 */
        .word __unknown_interrupt_handler /* 47 */
        .word __unknown_interrupt_handler /* 48 */
        .word __unknown_interrupt_handler /* 49 */
        .word __unknown_interrupt_handler /* 50 */
        .word __unknown_interrupt_handler /* 51 */
        .word __unknown_interrupt_handler /* 52 */
        .word __unknown_interrupt_handler /* 53 */
        .word __TIM6_DAC1_handler /* 54 */
        .word __TIM7_DAC2_handler /* 55 */
        .word __unknown_interrupt_handler /* 56 */
        .word __unknown_interrupt_handler /* 57 */
        .word __unknown_interrupt_handler /* 58 */
        .word __unknown_interrupt_handler /* 59 */
        .word __unknown_interrupt_handler /* 60 */
        .word __unknown_interrupt_handler /* 61 */
        .word __unknown_interrupt_handler /* 62 */
        .word __unknown_interrupt_handler /* 63 */
        .word __COMP2_handler /* 64 */
        .word __COMP4_6_handler /* 65 */
        .word __unknown_interrupt_handler /* 66 */
        .word __HRTIM_Master_handler /* 67 */
        .word __HRTIM_TIMA_handler /* 68 */
        .word __HRTIM_TIMB_handler /* 69 */
        .word __HRTIM_TIMC_handler /* 70 */
        .word __HRTIM_TIMD_handler /* 71 */
        .word __HRTIM_TIME_handler /* 72 */
        .word __HRTIM_TIM_FLT_handler /* 73 */
        .word __unknown_interrupt_handler /* 74 */
        .word __unknown_interrupt_handler /* 75 */
        .word __unknown_interrupt_handler /* 76 */
        .word __unknown_interrupt_handler /* 77 */
        .word __unknown_interrupt_handler /* 78 */
        .word __unknown_interrupt_handler /* 79 */
        .word __unknown_interrupt_handler /* 80 */
        .word __FPU_handler /* 81 */
        .word __unknown_interrupt_handler /* 82 */
        .word __unknown_interrupt_handler /* 83 */
        .word __unknown_interrupt_handler /* 84 */
        .word __unknown_interrupt_handler /* 85 */
        .word __unknown_interrupt_handler /* 86 */
        .word __unknown_interrupt_handler /* 87 */
        .word __unknown_interrupt_handler /* 88 */
        .word __unknown_interrupt_handler /* 89 */
        .word __unknown_interrupt_handler /* 90 */
        .word __unknown_interrupt_handler /* 91 */
        .word __unknown_interrupt_handler /* 92 */
        .word __unknown_interrupt_handler /* 93 */
        .word __unknown_interrupt_handler /* 94 */
        .word __unknown_interrupt_handler /* 95 */
        .word __unknown_interrupt_handler /* 96 */
        .word __unknown_interrupt_handler /* 97 */
        .word __unknown_interrupt_handler /* 98 */
        .word __unknown_interrupt_handler /* 99 */
        .word __unknown_interrupt_handler /* 100 */
        .word __unknown_interrupt_handler /* 101 */
        .word __unknown_interrupt_handler /* 102 */
        .word __unknown_interrupt_handler /* 103 */
        .word __unknown_interrupt_handler /* 104 */
        .word __unknown_interrupt_handler /* 105 */
        .word __unknown_interrupt_handler /* 106 */
        .word __unknown_interrupt_handler /* 107 */
        .word __unknown_interrupt_handler /* 108 */
        .word __unknown_interrupt_handler /* 109 */
        .word __unknown_interrupt_handler /* 110 */
        .word __unknown_interrupt_handler /* 111 */
        .word __unknown_interrupt_handler /* 112 */
        .word __unknown_interrupt_handler /* 113 */
        .word __unknown_interrupt_handler /* 114 */
        .word __unknown_interrupt_handler /* 115 */
        .word __unknown_interrupt_handler /* 116 */
        .word __unknown_interrupt_handler /* 117 */
        .word __unknown_interrupt_handler /* 118 */
        .word __unknown_interrupt_handler /* 119 */
        .word __unknown_interrupt_handler /* 120 */
        .word __unknown_interrupt_handler /* 121 */
        .word __unknown_interrupt_handler /* 122 */
        .word __unknown_interrupt_handler /* 123 */
        .word __unknown_interrupt_handler /* 124 */

   .weak      __WWDG_handler
   .thumb_set __WWDG_handler,__common_int_handler
   .weak      __PVD_handler
   .thumb_set __PVD_handler,__common_int_handler
   .weak      __TAMP_STAMP_handler
   .thumb_set __TAMP_STAMP_handler,__common_int_handler
   .weak      __RTC_WKUP_handler
   .thumb_set __RTC_WKUP_handler,__common_int_handler
   .weak      __FLASH_handler
   .thumb_set __FLASH_handler,__common_int_handler
   .weak      __RCC_handler
   .thumb_set __RCC_handler,__common_int_handler
   .weak      __EXTI0_handler
   .thumb_set __EXTI0_handler,__common_int_handler
   .weak      __EXTI1_handler
   .thumb_set __EXTI1_handler,__common_int_handler
   .weak      __EXTI2_handler
   .thumb_set __EXTI2_handler,__common_int_handler
   .weak      __EXTI3_handler
   .thumb_set __EXTI3_handler,__common_int_handler
   .weak      __EXTI4_handler
   .thumb_set __EXTI4_handler,__common_int_handler
   .weak      __DMA1_Channel1_handler
   .thumb_set __DMA1_Channel1_handler,__common_int_handler
   .weak      __DMA1_Channel2_handler
   .thumb_set __DMA1_Channel2_handler,__common_int_handler
   .weak      __DMA1_Channel3_handler
   .thumb_set __DMA1_Channel3_handler,__common_int_handler
   .weak      __DMA1_Channel4_handler
   .thumb_set __DMA1_Channel4_handler,__common_int_handler
   .weak      __DMA1_Channel5_handler
   .thumb_set __DMA1_Channel5_handler,__common_int_handler
   .weak      __DMA1_Channel6_handler
   .thumb_set __DMA1_Channel6_handler,__common_int_handler
   .weak      __DMA1_Channel7_handler
   .thumb_set __DMA1_Channel7_handler,__common_int_handler
   .weak      __ADC1_2_handler
   .thumb_set __ADC1_2_handler,__common_int_handler
   .weak      __USB_HP_CAN_TX_handler
   .thumb_set __USB_HP_CAN_TX_handler,__common_int_handler
   .weak      __USB_LP_CAN_RX0_handler
   .thumb_set __USB_LP_CAN_RX0_handler,__common_int_handler
   .weak      __CAN_RX1_handler
   .thumb_set __CAN_RX1_handler,__common_int_handler
   .weak      __CAN_SCE_handler
   .thumb_set __CAN_SCE_handler,__common_int_handler
   .weak      __EXTI9_5_handler
   .thumb_set __EXTI9_5_handler,__common_int_handler
   .weak      __TIM1_BRK_TIM15_handler
   .thumb_set __TIM1_BRK_TIM15_handler,__common_int_handler
   .weak      __TIM1_UP_TIM16_handler
   .thumb_set __TIM1_UP_TIM16_handler,__common_int_handler
   .weak      __TIM1_TRG_COM_TIM17_handler
   .thumb_set __TIM1_TRG_COM_TIM17_handler,__common_int_handler
   .weak      __TIM1_CC_handler
   .thumb_set __TIM1_CC_handler,__common_int_handler
   .weak      __TIM2_handler
   .thumb_set __TIM2_handler,__common_int_handler
   .weak      __TIM3_handler
   .thumb_set __TIM3_handler,__common_int_handler
   .weak      __I2C1_EV_EXTI23_handler
   .thumb_set __I2C1_EV_EXTI23_handler,__common_int_handler
   .weak      __I2C1_ER_handler
   .thumb_set __I2C1_ER_handler,__common_int_handler
   .weak      __SPI1_handler
   .thumb_set __SPI1_handler,__common_int_handler
   .weak      __USART1_EXTI25_handler
   .thumb_set __USART1_EXTI25_handler,__common_int_handler
   .weak      __USART2_EXTI26_handler
   .thumb_set __USART2_EXTI26_handler,__common_int_handler
   .weak      __USART3_EXTI28_handler
   .thumb_set __USART3_EXTI28_handler,__common_int_handler
   .weak      __EXTI15_10_handler
   .thumb_set __EXTI15_10_handler,__common_int_handler
   .weak      __RTC_Alarm_handler
   .thumb_set __RTC_Alarm_handler,__common_int_handler
   .weak      __TIM6_DAC1_handler
   .thumb_set __TIM6_DAC1_handler,__common_int_handler
   .weak      __TIM7_DAC2_handler
   .thumb_set __TIM7_DAC2_handler,__common_int_handler
   .weak      __COMP2_handler
   .thumb_set __COMP2_handler,__common_int_handler
   .weak      __COMP4_6_handler
   .thumb_set __COMP4_6_handler,__common_int_handler
   .weak      __HRTIM_Master_handler
   .thumb_set __HRTIM_Master_handler,__common_int_handler
   .weak      __HRTIM_TIMA_handler
   .thumb_set __HRTIM_TIMA_handler,__common_int_handler
   .weak      __HRTIM_TIMB_handler
   .thumb_set __HRTIM_TIMB_handler,__common_int_handler
   .weak      __HRTIM_TIMC_handler
   .thumb_set __HRTIM_TIMC_handler,__common_int_handler
   .weak      __HRTIM_TIMD_handler
   .thumb_set __HRTIM_TIMD_handler,__common_int_handler
   .weak      __HRTIM_TIME_handler
   .thumb_set __HRTIM_TIME_handler,__common_int_handler
   .weak      __HRTIM_TIM_FLT_handler
   .thumb_set __HRTIM_TIM_FLT_handler,__common_int_handler
   .weak      __FPU_handler
   .thumb_set __FPU_handler,__common_int_handler

	.text

   .weak      __unknown_interrupt_handler
   .thumb_set __unknown_interrupt_handler,__common_int_handler

.macro weak_handler name
	.thumb_func
.weak \name
.type \name, %function
\name:
0:	b 0b
	.size \name, . - \name
.endm

weak_handler NMI_Handler
weak_handler HardFault_Handler
weak_handler MemoryManagement_Handler
weak_handler BusFault_Handler
weak_handler UsageFault_Handler
weak_handler Reserved_Handler
weak_handler SVC_Handler
weak_handler DebugMon_Handler
weak_handler PendSV_Handler
weak_handler SysTick_Handler
weak_handler __common_int_handler

        /*********/
        /* .data */
        /*********/
        .section .data.argv
argv_str:
        .ascii  "main\0"

        .align 4
argv:
        .word argv_str
        .word 0

        /*****************/
        /* Reset_Handler */
        /*****************/

	.text
	.thumb_func
	.globl Reset_Handler

Reset_Handler:

	/* Set the stack pointer */
	ldr	r1,=__stack_end
	mov     sp, r1

	/* Copy .data */
	.thumb_func
_startup_copy_data:
	ldr	r0,=__data_start
	ldr	r1,=__data_words
	ldr	r2,=__data_load
	cmp     r1,#0
	beq     1f
0:	ldr	r4,[r2]
	str	r4,[r0]
        adds    r2,#4
        adds    r0,#4
	subs	r1,r1,#1
	bne	0b
1:
        .size _startup_copy_data, . - _startup_copy_data

	/* Copy .CCM_data */
	.thumb_func
_startup_copy_CCM_data:
	ldr	r0,=__CCM_data_start
	ldr	r1,=__CCM_data_words
	ldr	r2,=__CCM_data_load
	cmp     r1,#0
	beq     1f
0:	ldr	r4,[r2]
	str	r4,[r0]
        adds    r2,#4
        adds    r0,#4
	subs	r1,r1,#1
	bne	0b
1:
        .size _startup_copy_CCM_data, . - _startup_copy_CCM_data

	/* Clear .bss */
	.thumb_func
_startup_clear_bss:
	ldr	r0,=__bss_start
	ldr	r1,=__bss_words
	movs	r2,#0
	cmp     r1,#0
	beq     1f
0:	str	r2,[r0]
        adds    r0,#4
	subs	r1,r1,#1
	bne	0b
1:
        .size _startup_clear_bss, . - _startup_clear_bss

	/* Clear .CCM_bss */
	.thumb_func
_startup_clear_CCM_bss:
	ldr	r0,=__CCM_bss_start
	ldr	r1,=__CCM_bss_words
	movs	r2,#0
	cmp     r1,#0
	beq     1f
0:	str	r2,[r0]
        adds    r0,#4
	subs	r1,r1,#1
	bne	0b
1:
        .size _startup_clear_CCM_bss, . - _startup_clear_CCM_bss


#if !defined(__SOFTFP__)
        /**************/
        /* Enable FPU */
        /**************/

        movw     r0,#0xED88
        movt     r0,#0xE000
        ldr      r1,[r0]
        orr      r1,r1,#(0xF << 20)
        str      r1,[r0]

        dsb
        isb
#endif

        /* Call static constructors */
.weak __libc_init_array
        ldr     r5,=__libc_init_array
        cmp     r5,#0
        beq     .skip_libc_init
        blx     r5
.skip_libc_init:

        /* Call main, with argc, argv */
        movs    r0,#1
        ldr	r1,=argv
        bl	main

        /* Save main's return value */
        mov r4, r0

        /* static destructors */
.weak __libc_fini_array
        ldr     r5,=__libc_fini_array
        cmp     r5,#0
        beq     .skip_libc_fini
        blx     r5
.skip_libc_fini:

        /* Restore main's return value */
        mov r0, r4

        bl	_exit
        bl	Reset_Handler
	.size Reserved_Handler, . - Reset_Handler