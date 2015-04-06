;
;Main.asm
;
;Created: 16-03-2015 21:03:12
;Author: StjerneIdioten
; 

;Defines
.equ I2C_W = 0x3C
.equ I2C_R = 0x3D
.def DATA_HIGH = R19
.def DATA_LOW = R20

.org 0x0000
rjmp Init

;Board specific port names
.include "Delay_Macros.asm"
.include "Motor_Control.asm"
.include "USART_Library.asm"
.include "I2C.asm"

Init:
	
	;Initialize the stack
	LDI	R16, low(RAMEND)
    OUT	SPL, R16
	LDI	R16, high(RAMEND)
    OUT	SPH, R16			
	
	;Enable internal weak-pullups on sda and scl
	/*
	ldi R16, (0<<PC0)|(0<<PC1)
	out DDRC, R16
	ldi R16, (1<<PC0)|(1<<PC1)
	out PORTC, R16
	*/

	USART_Init
	Motor_Init
	I2C_Init 0x00,0x12	;Prescaler 4 and TWBR 12
	DELAY_MS 1			;Give the modules some time to start up

	rjmp	Main

Main:
	
rjmp	MAIN

