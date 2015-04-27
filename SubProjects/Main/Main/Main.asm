;Main.asm

;Interrupt vector mapping
.org 0x00
rjmp Init
;Timer0 CTC interrupt
.org 0x14
jmp Timer0_Update
;USART received interrupt
.org 0x1A
jmp Comm_Received
;Comparator interrupt
.org 0x24
jmp Lap_Time


;Library includes
.include "SRAM-Mapping.asm"
.include "Delays.asm"
.include "Motor_Control.asm"
.include "USART_Library.asm"
.include "I2C.asm"
.include "MPU-6050.inc"
.include "MPU-6050.asm"
.include "Timers.asm"
.include "Communication_Protocol.asm"
.include "Interrupts.asm"

Init:
	
	;Initialize the stack
	LDI	R16, low(RAMEND)
    OUT	SPL, R16
	LDI	R16, high(RAMEND)
    OUT	SPH, R16			

	USART_Init 0b00000000,0b01100111 ;9600 baud, 16MHz clock
	;Comm_Init
	;Motor_Init
	;I2C_Init 0x00,0x12	;Prescaler 4 and TWBR 12
	;Timer0_Init
	;MPU6050_Init
	;MPU6050_Init
	;MPU6050_Init

	;ldi R16, (0<<PB3)

	;Motor_Set 115

	;ldi R16, 0x01
	;sts Program_Running, R16

	;Interrupts_Init ; Must be the last thing to be enabled!
	rjmp	Main

Main:

	/*
	;Check if the program should be running
	lds R16, Program_Running			
	cpi R16, 0x01
	brne MAIN
	*/

	ldi R16, 'D'
	call USART_Transmit

	;DELAY_MS_M 50

	;Insert program kode here

rjmp Main

