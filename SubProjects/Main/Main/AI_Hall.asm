AI_Hall:


	lds		R17,	AI_Check_Lap
	
	cpi		R17,	1
	breq	Mapping_Speed
	
	cpi		R17,	2
	brsh	Run_Speed
	
;Ellers preround
		ldi		R16,	Motor_Mapping
;		out		OCR2,	R16				;Slå til for reference motor output
		ldi	R16, HIGH(Periode_Mapping)	;Reference periode.
		ldi	R18,	Motor_Mapping_Min
		ldi	R19,	Motor_Mapping_Max
;call	Hastigheds_kontrol

ret

Mapping_Speed:

call	SKIFT_TEST



		mov		R16,	Type
;call	LED
;		ldi		R16,	Motor_Mapping
		out		OCR2,	R16				;Slå til for reference motor output
		
		ldi	R16, HIGH(Periode_Mapping)	;Reference periode.
		ldi	R18,	Motor_Mapping_Min
		ldi	R19,	Motor_Mapping_Max
call	Hastigheds_kontrol

ret

Run_Speed:

		ldi		R16,		0b00000000
		out		PORTA,	R16

call	Read_Map

ret










