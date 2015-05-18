AI_Lap_Interrupt:						;Lap interrupt skifter fra initial runden til den første runde til alle resterende.

		lds		R20, AI_Check_Lap		

		;Were we running a speed lap when we hit the line. Then go to speed lap handling.
		cpi		R20, AI_Lap_Speed
		brsh	AI_Test_Speed_Lap
		
		;Were we running a mapping lap when we hit the line. Then go to the first speed lap handling.
		cpi		R20, AI_Lap_Mapping
		brsh	AI_Test_Speed_Lap_First

		;We were in preround when we hit the line. So initialize the mapping round.
		ldi		R20, AI_Lap_Mapping
		sts		AI_Check_Lap, R20



		ret			

AI_Test_Speed_Lap_First:
		;Sørger for at gemme det sidste banestykke. Da stykkerne bliver gemt ved skift til næste stykke.

;		ldi R20, 5
;		add		laengde, R20			;Forøg antal med fem - Bruges til at sikre at den ikke løber tør i slutningen. Antal kan ændres.
;		st		Y+,			Laengde		;Sæt Laengden ind først-
;		st		Y+,			Type		;og derefter vejtypen.


;Vi har ikke afprøvet dette, så det kigger vi på senere.


AI_Test_Speed_Lap:
		
		ldi		R20, 2
		sts     AI_Check_Lap, R20

;		lds		R20,		AI_Hastighed_D
;		inc		R20
;		sts		AI_Hastighed_D,R20

;		clr		R27						;Nulstiller X
;		ldi		R26,		Map_start
;		ldi		R16, 2
;		sts		AI_Check_Lap, R16
;		ld		Laengde,	Y+			;Indlæser den første del af af det gemte map.
;		ld		Type,		Y+

;Vi har ikke afprøvet dette, så det kigger vi på senere.
		ret















