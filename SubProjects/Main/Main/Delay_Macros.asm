;Author: Jonas A. L. Andersen

;These macros are intended for a micro running 16MHZ

;This macro can generate from 1 to 255 ms of delay.  
;Uses R16, R17 and R18
.MACRO	DELAY_MS					; Cycles to execute 
	LDI R16, @0 ;					; 1 cycle to execute
	DELAY_MS_2: ;-----------------/
	LDI R17, 15 ;	              /
	DELAY_MS_1:	;------------/    /
	LDI R18, 177;		     /    /
	DELAY_MS_0: ;-------/    /    /
	NOP ;			    /C   /B   /A
	NOP ;				/	 /	  /
	NOP ;				/	 /	  /
	DEC R18 ;		    /    /    /
	BRNE DELAY_MS_0 ;---/    /    /
	DEC R17 ;		         /    /
	NOP ;					 /	  /
	BRNE DELAY_MS_1 ;--------/    /
	DEC R16 ;		              /
	NOP ;						  /
	NOP ;						  /
	NOP ;						  /
	NOP ;						  /
	NOP ;						  /
	NOP ;						  /
	BRNE DELAY_MS_2 ;-------------/
.ENDMACRO
; Block C: 177*(1+1+1+1+2)-1 = 1061
; Block B: 15*(1+C+1+1+2)-1 = 15990 
; Block A: x*(1+B+1+1+1+1+1+1+1+2)-1 = x*16000-1
; Total # of cycles is: 1 + A = x*16000 
; Formula for delay: x*1ms
