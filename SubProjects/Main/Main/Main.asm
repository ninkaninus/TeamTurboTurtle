;Main.asm

.org 0x0000
rjmp Init
;Interrupt Vector Table

.org 0x0014
jmp Timer0_Update
	
<<<<<<< 510a55301a7ad711f40475321293df3bc26b0858

;Interrupt vector mapping
=======
>>>>>>> 128042dca70df100ec236374809f969a7faafb81

;Library includes
.include "SRAM-Mapping.asm"
.include "Delay_Macros.asm"
.include "Motor_Control.asm"
.include "USART_Library.asm"
.include "I2C.asm"
.include "MPU-6050.inc"
.include "MPU-6050.asm"

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
	rjmp	Main

Main:

	call MPU6050_Read_Dataset

	lds R17, GYRO_ZOUT_H

	lds R16, GYRO_ZOUT_L

	call USART_Decimal_S16

	USART_Newline

rjmp	MAIN

