;
;Main.asm
;
;Created: 16-03-2015 21:03:12
;Author: StjerneIdioten
; 

;Board specific port names
.include "Delay_Macros.asm"
.include "Motor_Control.asm"
.include "USART_Library.asm"

.org 0x0000
rjmp Init

Init:
	
	USART_Init
	Motor_Init

	rjmp	Main

Main:
	
rjmp	MAIN

