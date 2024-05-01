	AND  R2,R2,#0
	ORR  R3,R2,#0
	ORR  R4,R3,#5
	mov  R5, #0x62
	mov  R9, #0x65
T1:	sub  R9, R9, #1
	cmp  R5, R9
	BNE  T1
	STR  R2,[R3,#0]
	LDR  R5,[R3,#0]
	EORS R6, R5, R3
	CMP  R4, #0
	ADDEQ R7,R6,R5
T2: 	BAL  T2
T3:  	BAL  T3
