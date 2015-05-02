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
	rjmp Main

Main:
	;Check if the program should be running
	sei
	nop
	cli
	lds R16, Program_Running			
	cpi R16, 0x01
	brne Main

	;Insert program code here
	sei

rjmp Main
