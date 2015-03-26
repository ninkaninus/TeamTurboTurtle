/*
 * USART_library.asm
 *
 *  Created: 26-03-2015 12:27:09
 *   Author: StjerneIdioten
 */ 

 .MACRO  USART_Init
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
 .ENDMACRO

 .MACRO USART_Transmit 
	ldi R16, @0
	; Wait for empty transmit buffer
	sbis	UCSRA,	UDRE
	rjmp	USART_Transmit
	out	UDR,	R16
.ENDMACRO

.MACRO USART_Receive
USART_Receive_Start:
	; Wait for data to be received
	sbis UCSRA, RXC
	rjmp USART_Receive_Start
	; Get and return received data from buffer
	in r16, UDR
.ENDMACRO
