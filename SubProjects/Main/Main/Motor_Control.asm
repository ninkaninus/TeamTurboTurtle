/*
 * Motor_Control.asm
 *
 *  Created: 26-03-2015 12:49:38
 *   Author: StjerneIdioten
 */ 

 .EQU	MOTOR_PIN = PD7

 .MACRO Motor_Init
	ldi R16, (1<<PD7)
	out DDRD, R16
	ldi R16, 0b01101001
	out TCCR2, R16 
 .ENDMACRO

 .MACRO Motor_Set 
	ldi R16, @0
	out OCR2, R16
 .ENDMACRO