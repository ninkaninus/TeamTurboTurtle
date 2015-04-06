;
;Main.asm
;
;Created: 16-03-2015 21:03:12
;Author: StjerneIdioten
; 

;Defines

.equ I2C_W = 0b11010000
.equ I2C_R = 0b11010001
.def DATA_HIGH = R19
.def DATA_LOW = R20

.org 0x0000
rjmp Init

;Board specific port names
.include "MPU-6050.inc"
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

	DELAY_MS 10			;Give the modules some time to start up

	rjmp	Main

Main:
	
	call I2C_Start

	ldi R16, I2C_W
	call I2C_Write

	ldi R16, MPU6050_RA_WHO_AM_I
	call I2C_Write

	call I2C_Start

	ldi R16, I2C_R
	call I2C_Write

	ldi R16,I2C_NACK
	call I2C_Read

	mov DATA_HIGH, R16

	call I2C_Stop

	mov R16, DATA_HIGH
	
	call USART_Binary

	USART_Newline
	
	DELAY_MS 250

rjmp	MAIN

