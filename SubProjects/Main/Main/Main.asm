/*
 * Main.asm
 *
 *  Created: 16-03-2015 21:03:12
 *   Author: StjerneIdioten
 */ 

 //Board specific port names
 .include "Board_Defines.inc"
 .include "Delay_Macros.asm"

 .def COUNT = R20
 .equ segmentCount = 13

 .org	0x0000
	rjmp	Init

 .org	0x60
 string: .db	'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!', '\n', 0x00 

Init:
	.include "Setup_Io.asm"
	ldi COUNT, 0x00

USART_Init:
	;Set Baud Rate to 9600
	ldi R16,	0b01100111	
	ldi R17,	0b00000000

	out	UBRRH,	R17
	out UBRRL,	R16

	;Enable receiver and transmitter
	ldi R16,	(1<<RXEN)|(1<<TXEN)
	out	UCSRB,	R16

	; Set frame format: 8data, 2stop bit
	ldi	R16,	(1<<URSEL)|(3<<UCSZ0)
	out	UCSRC,	R16

	rjmp	Main

Main:

DELAY 3

ldi ZH, high(string<<1) ;load in the high byte of the address of the first value in segments.
ldi ZL, low(string<<1)  ;load in the low byte of the address of the first value in segments.
add ZL, COUNT			  ;Add the offset to get the correct segment
ldi R16, 0				  ;Load 0 into R16
adc ZH, R16				  ;Add the carry to ZH if there is one from the offset of ZL
lpm R16, Z
	
USART_Transmit:
	; Wait for empty transmit buffer
	sbis	UCSRA,	UDRE
	rjmp	USART_Transmit
	out	UDR,	R16

ldi R16, segmentCount	  ;Load in the value of how many segments there are.
cp COUNT, R16			  ;Check if we have reached the limit of how many segments there are.
breq	RESTART			  ;Jump to restart the counter if it's time to loop over.
inc	COUNT				  ;If it was not time to loop over, then increment the counter.
rjmp	MAIN			  ;Jump to main and loop again.
RESTART:					
ldi COUNT, 0x00			  ;Reset the counter
rjmp	MAIN

