    AND     R2,R2,#0
    ORR     R3,R2,#0
    ORR     R4,R3,#5
T1: ADD     R2,R2,R4
    SUBS    R4,R4,#1
    BNE     T1
    STR     R2,[R3]
    LDR     R5,[R3]
T2: BAL     T2
