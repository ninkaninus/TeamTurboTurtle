.include "m32def.inc"

;Mapping of all the interrupts, must be the first include!
.include "Interrupt_Mapping.asm"

;Library includes
.include "Math.asm"
.include "SRAM-Mapping.asm"
.include "USART_Library.asm"
.include "Delays.asm"
.include "Motor_Control.asm"
.include "I2C.asm"
.include "MPU-6050.inc"
.include "MPU-6050.asm"
.include "Time.asm"
.include "WheelSpeed.asm"
.include "LapCounter.asm"
.include "Communication_Protocol.asm"
.include "Setup.asm"

Init:
	Setup	

	sei					;Enable global interrupt	
	rjmp Main

Main:
	;Check if the program should be running
	sei
	nop
	cli	
	lds R16, Program_Running			
	cpi R16, 0x01
	brne Main
	
	lds R16, Timer_1ms_L	
	lds R17, Timer_1ms_M	

	call USART_Decimal_16
	USART_Newline
	
	;ldi R16, 'U'
	;call USART_Transmit
	
	;Insert program code here
	sei

rjmp Main
