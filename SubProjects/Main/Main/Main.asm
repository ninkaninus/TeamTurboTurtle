;Main.asm

;Interrupt vector mapping
.org 0x00
rjmp Init
;Timer1 Input Capture interrupt
.org	0x0C
jmp	Input_Capture
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

	USART_Init 0b00000000,0b01100111  ;9600 baud, 16MHz clock
	Comm_Init
	Motor_Init
	I2C_Init 0x00,0x12	;Prescaler 4 and TWBR 12
	Timer0_Init
	MPU6050_Init
	MPU6050_Init
	MPU6050_Init

	ldi R16, (0<<PB3)
	out	DDRB, R16

	ldi R16, 0x01
	sts Program_Running, R16

	Interrupts_Init ; Must be the last thing to be enabled!
	rjmp	Main

Main:
	;Check if the program should be running
	sei
	cli
	lds R16, Program_Running			
	cpi R16, 0x01
	brne MAIN

	ldi R16, 200
	call Delay_MS

	cli
	
	call MPU6050_Read_Dataset

	lds R16, ACCEL_ZOUT_L
	lds R17, ACCEL_ZOUT_H
	call USART_Decimal_S16
	USART_Newline

	sei


	;Insert program code here

rjmp Main
