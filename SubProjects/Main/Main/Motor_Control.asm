 ;Motor_Control.asm
 ;Author: StjerneIdioten

 .EQU	MOTOR_PIN = PD7

 .MACRO Motor_Init
	sbi DDRD, PD7
	ldi R16, 0b01101001
	out TCCR2, R16 
 .ENDMACRO

 .MACRO Motor_Set 
	ldi R16, @0
	out OCR2, R16
 .ENDMACRO