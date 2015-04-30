 ;Motor_Control.asm
 ;Author: StjerneIdioten

 .EQU	MOTOR_PIN = PD7						;The pin that the motor is connected to

 .MACRO Motor_Init
	in R16, DDRD							;Load in the current setup of the portb
	ori R16, (1<<PD7)						;OR in the setup that we wish to have
	ldi R16, 0b01101001						;Fast-pwm, non-inverting mode, no prescaling
	out TCCR2, R16							;
 .ENDMACRO

 .MACRO Motor_Set 
	ldi R16, @0								;Load in the 1 argument
	out OCR2, R16							;Set the duty cycle of the motor
 .ENDMACRO

 Motor_Set_Percentage:
	
 ret