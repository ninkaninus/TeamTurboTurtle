;
;Main.asm
;
;Created: 16-03-2015 21:03:12
;Author: StjerneIdioten
; 

;Defines
.equ MPU6050_Address_W = 0b01001110
.equ MPU6050_Address_R = 0b01001111
.equ DATA_ADDRESS = 
.def DATA = R19

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

	USART_Init
	Motor_Init
	I2C_Init 0x00,0x12

	rjmp	Main

Main:

rjmp	MAIN

