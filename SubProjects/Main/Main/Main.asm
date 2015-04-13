;Main.asm

.org 0x0000
rjmp Init

;Interrupt vector mapping

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
	MPU6050_Init
	ldi R16, 'D'
	call USART_Transmit
	USART_Newline
	Motor_Set 170

	rjmp	Main

Main:

	call MPU6050_Read_Dataset

	lds R17, ACCEL_YOUT_H

	lds R16, ACCEL_YOUT_L

	call USART_Decimal_S16

	USART_Newline

	lds R17, ACCEL_YOUT_H

	lds R16, ACCEL_YOUT_L

	cpi R17, HIGH(8191)
	
	/*brge Main_Higher
	cpi R17, LOW(8191)
	brge Main_Higher
	Motor_Set 170
	rjmp Main_End

Main_Higher:
	Motor_Set 0
	DELAY_MS 250
	DELAY_MS 250
	Motor_Set 100

	*/
Main_End:

rjmp	MAIN

