;Main.asm

;Interrupt vector mapping
.org 0x0000
rjmp Init

.org 0x0014
jmp Timer0_Update

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
	MPU6050_Init
	MPU6050_Init
	MPU6050_Init
	ldi R16, 'D'
	call USART_Transmit
	USART_Newline
	;Motor_Set 120
	Interrupts_Init ; Must be the last thing to be enabled!
	rjmp	Main

Main:
	
	cli
	ldi R16, 10
	call Delay_MS

	cli
	Motor_Set 0
	sei

	ldi R16, 250
	call Delay_MS

	cli
	Motor_Set 255
	sei

	lds R16, Timer_1ms_L
	lds R17, Timer_1ms_M

	call USART_Decimal_S16
	USART_Newline

rjmp	MAIN

