;
;Main.asm
;
;Created: 16-03-2015 21:03:12
;Author: StjerneIdioten
; 

;Defines
.equ MPU6050_Address_W = 0b11010001
.equ MPU6050_Address_R = 0b11010000
.equ DATA_ADDRESS = 0x3C
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
	I2C_Init

	rjmp	Main

Main:

	Call I2C_Start

	ldi R16, MPU6050_Address_W
	Call I2C_Write
	/*Call I2C_Status
	cpi R16, 0x18
	brne I2C_Error*/

	ldi R16, 0x3C
	Call I2C_Write
	/*Call I2C_Status
	cpi R16, 0x28
	brne I2C_Error*/

	Call I2C_Start

	ldi R16, MPU6050_Address_R
	Call I2C_Write
	/*Call I2C_Status
	cpi R16, 0x40
	brne I2C_Error*/

	call I2C_Read
	mov DATA, R16
	/*call I2C_Status
	cpi R16, 0x58
	brne I2C_Error*/
	call I2C_Stop
	mov R16, DATA
	USART_Transmit_Var
rjmp	MAIN

