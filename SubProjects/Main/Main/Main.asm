;Mapping of all the interrupts, must be the first include!
.include "Interrupt_Mapping.asm"

;Library includes
.include "Setup.asm"
.include "SRAM-Mapping.asm"
.include "Delays.asm"
.include "Motor_Control.asm"
.include "USART_Library.asm"
.include "I2C.asm"
.include "MPU-6050.inc"
.include "MPU-6050.asm"
.include "Time.asm"
.include "WheelSpeed.asm"
.include "LapCounter.asm"
.include "Communication_Protocol.asm"

Init:
	Setup			
	rjmp Main

Main:
	;Check if the program should be running
	sei
	cli
	lds R16, Program_Running			
	cpi R16, 0x01
	brne Main

	;Insert program code here
	sei

rjmp Main
