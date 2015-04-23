;Main.asm

;Interrupt vector mapping
.org 0x0000
rjmp Init
;Timer0 CTC interrupt
.org 0x0014
jmp Timer0_Update
;Comparator interrupt
.org 0x24
jmp Lap_Time


;Library includes
.include "SRAM-Mapping.asm"
.include "Delays.asm"
.include "Motor_Control.asm"
.include "USART_Library.asm"
.include "I2C.asm"
.include "MPU-6050.inc"
.include "MPU-6050.asm"
.include "Timers.asm"
.include "Interrupts.asm"

Init:
	
	;Initialize the stack
	LDI	R16, low(RAMEND)
    OUT	SPL, R16
	LDI	R16, high(RAMEND)
    OUT	SPH, R16			

	USART_Init 0b00000000,0b00001000 
	Motor_Init
	I2C_Init 0x00,0x12	;Prescaler 4 and TWBR 12
	Timer0_Init
	;MPU6050_Init
	;MPU6050_Init
	;MPU6050_Init

	ldi R16, (0<<PB3)

	ldi R16, 'D'
	call USART_Transmit
	USART_Newline
	Motor_Set 115
	Interrupts_Init ; Must be the last thing to be enabled!
	rjmp	Main

Main:
	
	ldi R16, 100
	call Delay_MS

	lds R16, Lap_Time_L
	lds R17, Lap_Time_M

	call USART_Decimal_S16
	USART_Newline


rjmp	MAIN

