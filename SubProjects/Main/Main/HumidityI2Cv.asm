;
;Main.asm
;
;Created: 16-03-2015 21:03:12
;Author: StjerneIdioten
; 

;Defines
.equ I2C_W = 0b01001110
.equ I2C_R = 0b01001111
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

	USART_Init
	Motor_Init
	I2C_Init 0x00,0x12	;Prescaler 4 and TWBR 12
	DELAY_MS 1			;Give the modules some time to start up

	rjmp	Main

Main:

	call I2C_Start
	ldi R16, I2C_W
	call I2C_Write
	call I2C_Stop

	DELAY_MS 10

	call I2C_Start
	ldi R16, I2C_R
	call I2C_Write
	ldi R16, I2C_ACK
	call I2C_Read
	andi R16, 0x3F
	mov DATA_HIGH, R16
	ldi R16,I2C_NACK
	call I2C_Read
	mov DATA_LOW, R16
	call I2C_Stop

	mov R16, DATA_HIGH
	call USART_Binary
	mov R16, DATA_LOW
	call USART_Binary
	USART_Newline
	
	DELAY_MS 250

rjmp	MAIN

