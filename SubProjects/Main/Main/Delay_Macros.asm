/*
 * DelayMacros.asm
 *
 *   Author: jonaa14
 *
 */
 
 /*
  *THESE MACROS ARE INTENDED FOR USE WITH A MICRO RUNNING AT 8MHZ!!! TIMINGS WILL BE OFF FOR OTHER VALUES!
  */
  

  ;This macro make use of the registers R16, R17, R18
  ;About 39.2 ms per step in value as of now. Will tweak it to a more logical value in the future. As of right now the timing isn't essential.
.MACRO	DELAY						; Cycles to execute 
	LDI R16, @0 ;					; 1 cycle to execute
	DELAY2: ;------/--------------/
	LDI R17, 250 ;-/              /
	DELAY1:	;------/---------/    /
	LDI R18, 250 ;--/----/    /    /
	DELAY: ;-------/    /    /    /
	NOP ;----------/    /C   /B   /A
	DEC R18 ;------/    /    /    /
	BRNE DELAY ;---/----/    /    /
	DEC R17 ;------/         /    /
	BRNE DELAY1  ;-/---------/    /
	DEC R16 ;------/              /
	BRNE DELAY2 ;--/--------------/
.ENDMACRO
; Block C: 250*(1+1+1+2)-1 = 1249
; Block B: 250*(1+C+1+2)-1 = 313249
; Block A: x*(1+B+1+2)-1 = 78313249 at x=250
; Total # of cycles is: 1 + A = 78313250 at x = 250
; Formula for delay: x*(313253) * (1/8,000,000)
