AI_Hall:


	lds		R17,	AI_Check_Lap
	
	cpi		R17,	1
	breq	Mapping_Speed
	
	cpi		R17,	2
	brsh	Run_Speed
	
;Ellers preround

		ldi		R16, LOW(Periode_Mapping)	;Reference periode.
		ldi		R17, HIGH(Periode_Mapping)	;Reference periode.
		sts		Speed_L,	R16
		sts		Speed_H,	R17

ret

Mapping_Speed:

call	SKIFT_TEST
		
ldi		R16, LOW(Periode_Mapping)	;Reference periode.
ldi		R17, HIGH(Periode_Mapping)	;Reference periode.
sts		Speed_L,	R16
sts		Speed_H,	R17

ret

Run_Speed:

call	Read_Map

ret










