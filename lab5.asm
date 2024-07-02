    .ORIG X3000
    LDI R0,N
    LDI R1,M;                      R0 = N ,R1 = M ;-------------------------------------------------------------------------------------
    AND R2,R2,#0
    ADD R3,R1,#0
MULTIPLE    ADD R2,R2,R0
    ADD R3,R3,#-1
    BRP MULTIPLE
    NOT R2,R2
    ADD R2,R2,#1
    ST  R2,SAVER8 
    ST  R2,SAVER9;                      R2 = - N * M  ,LD -N*M INTO SAVER1
    LD  R6,STACKPOINTER;---------------------------------------------------------------------------------------------
    LD   R3,POINTER1 ;      R3 POINT TO THE LOCATION OF THE NUMBER TO BE CALCULATED  
    LD   R4,POINTER2 ;      R4 POINT TO THE LOCATION IN WHICH THE RESULT WILL BE RESTORED  
LOOP1    JSR  FUNCTION
    ADD  R3,R3,#1
    ADD  R4,R4,#1
    LD   R2,SAVER8
    ADD  R2,R2,#1
    ST   R2,SAVER8
    ADD  R2,R2,#0
    BRN  LOOP1;             LOOP M*N TIMES;                      CALCULATE THE LONGEST PATH STARTING FROM EVERY LOCAION-------------------------------
    LD   R4,SAVER9;         R4 = - N * M
    AND  R2,R2,#0
    LD   R3,POINTER2;       R2 POINT TO THE OUTPUT OF THE NUMBER 
LOOP2    LDR   R5,R3,#0
    NOT  R5,R5
    ADD  R5,R5,#1
    ADD  R6,R5,R2
    BRZP  MAXMAINTAIN
MAXCHANGE LDR R2,R3,#0
MAXMAINTAIN    ADD  R3,R3,#1
    ADD  R4,R4,#1
    BRN  LOOP2;                  LOOP M*N TIMES;                            OUTPUT;------------------------------------------------------------------
    HALT
FUNCTION ADD R6,R6,#-1
    STR R7,R6,#0;----------------------------
    JSR CHECK-NORTH
    JSR CHECK-EAST
    JSR CHECK-SOUTH
    JSR CHECK-WEST;-----------------------------
    LDR R0,R6,#0
    ADD R6,R6,#1;--------------------------------
    LDR R1,R6,#0
    ADD R2,R1,#0
    ADD R6,R6,#1
    NOT  R1,R1
    ADD  R1,R1,#1
    ADD  R1,R1,R0
    BRZP NEXT-DIRECTION1
    ADD  R0,R2,#0;---------------------------------------------------------------------------------------------
NEXT-DIRECTION1    LDR R1,R6,#0
    ADD R2,R1,#0
    ADD R6,R6,#1
    NOT  R1,R1
    ADD  R1,R1,#1
    ADD  R1,R1,R0
    BRZP NEXT-DIRECTION2
    ADD  R0,R2,#0;---------------------------------------------------------------------------------------------
NEXT-DIRECTION2    LDR R1,R6,#0
    ADD R2,R1,#0
    ADD R6,R6,#1
    NOT  R1,R1
    ADD  R1,R1,#1
    ADD  R1,R1,R0
    BRZP OVER
    ADD  R0,R2,#0 ;---------------------------------------------------------------------------------------------   
OVER  ADD R0,R0,#1
    STR R0,R4,#0      ;R0 STORES THE SHORTEST LENGTH OF 4 DIRECTIONS,AND STORE THE VALUE IN THE MEMORY;--------------------------------
    LDR R7,R6,#0
    ADD R6,R6,#1
    RET;-----------------------------------------------------------------------------------------------------------------------
CHECK-NORTH  ADD R6,R6,#-1
    STR R7,R6,#0
    ADD R6,R6,#-1
    STR R3,R6,#0
    ADD R6,R6,#-1
    STR R4,R6,#0 ;                   PUSH R7\R3\R4----------------------------------------------------------
    LDI R0,M
    NOT R0,R0
    ADD R0,R0,#1 ;R0=-M
    ADD R0,R3,R0 ;R0=R3-M----------------------------------------------------------
    LD  R1,POINTER1
    NOT R1,R1
    ADD R1,R1,#1 ;R1=-X4002----------------------------------------------------------
    ADD R1,R1,R0
    BRN OVER1    ;IF R3 IS ON THE FIRST ROW , THEN NORTHLENGTH==0----------------------------------------------------------
    LDR R2,R0,#0
    LDR R5,R3,#0
    NOT R2,R2
    ADD R2,R2,#1
    ADD R2,R2,R5
    BRNZ OVER1   ;IF *R0>*R3,THEN NORTHLENGTH==0----------------------------------------------------------
    LDI R0,M
    NOT R0,R0
    ADD R0,R0,#1 ;R0=-M
    ADD R3,R3,R0 ;R3=R3-M
    ADD R4,R4,R0 ;R4=R4-M
    JSR FUNCTION  ;IF *R0<*R3,THEN NORTHLENGTH==FUNCTION(R3)
    LDR R5,R4,#0
    BRNZP ST1;----------------------------------------------------------
OVER1 AND R5,R5,#0
ST1    LDR R4,R6,#0
    ADD R6,R6,#1
    LDR R3,R6,#0
    ADD R6,R6,#1
    LDR R7,R6,#0
    ADD R6,R6,#1
    ADD R6,R6,#-1
    STR R5,R6,#0
    RET;-------------------------------------------------------------------------------------------------------------------
CHECK-EAST    ADD R6,R6,#-1
    STR R7,R6,#0
    ADD R6,R6,#-1
    STR R3,R6,#0
    ADD R6,R6,#-1
    STR R4,R6,#0;----------------------------------------------------------
    LD  R1,POINTER1
    NOT R1,R1
    ADD R1,R1,#1;R1=-X4002;----------------------------------------------------------
    ADD R1,R1,R3;R1=OFFSET
    ADD R1,R1,#1;----------------------------------------------------------
    LDI R0,M
    NOT R0,R0
    ADD R0,R0,#1    ;                      R0=-M;----------------------------------------------------------
JUDGE1    ADD R1,R1,R0
    BRZ OVER2
    ADD R1,R1,#0
    BRP JUDGE1;                  IF THE LOCATION IS ON THE RIGHTEST COLUMN,EAST-LENGTH==0;----------------------------------------------------------
    ADD R0,R3,#1
    LDR R2,R0,#0
    LDR R5,R3,#0
    NOT R2,R2
    ADD R2,R2,#1
    ADD R2,R2,R5
    BRNZ OVER2    ;           IF *R0>*R3,THEN EASTLENGTH==0;----------------------------------------------------------  
    ADD R3,R3,#1 ;          R3=R3+1
    ADD R4,R4,#1 ;          R4=R4+1
    JSR FUNCTION ;          IF *R0<*R3,THEN EASTLENGTH==FUNCTION(R3)
    LDR R5,R4,#0
    BRNZP ST2;----------------------------------------------------------
OVER2 AND R5,R5,#0
ST2    LDR R4,R6,#0
    ADD R6,R6,#1
    LDR R3,R6,#0
    ADD R6,R6,#1
    LDR R7,R6,#0
    ADD R6,R6,#1
    ADD R6,R6,#-1
    STR R5,R6,#0
    RET;------------------------------------------------------------------------------------------------------------------
CHECK-SOUTH    ADD R6,R6,#-1
    STR R7,R6,#0
    ADD R6,R6,#-1
    STR R3,R6,#0
    ADD R6,R6,#-1
    STR R4,R6,#0;----------------------------------------------------------
    LDI R0,M
    ADD R0,R0,R3;          R0=R3+M;----------------------------------------------------------
    LD  R1,POINTER1
    LD  R2,SAVER9
    NOT R2,R2
    ADD R2,R2,#1
    ADD R1,R1,R2
    ADD R1,R1,#-1;          R1=X4002+M*N-1
    NOT R1,R1
    ADD R1,R1,#1;          R1=-(X4002+M*N-1);----------------------------------------------------------
    ADD R1,R1,R0
    BRP OVER3    ;IF R3 IS ON THE LAST ROW , THEN SOUTHLENGTH==0;----------------------------------------------------------
    LDR R2,R0,#0
    LDR R5,R3,#0
    NOT R2,R2
    ADD R2,R2,#1
    ADD R2,R2,R5
    BRNZ OVER3    ;IF *R0>*R3,THEN SOUTHLENGTH==0;----------------------------------------------------------
    LDI R0,M
    ADD R3,R3,R0
    ADD R4,R4,R0
    JSR FUNCTION
    LDR R5,R4,#0;IF *R0<*R3,THEN SOUTHLENGTH==FUNCTION(R3)
    BRNZP ST3;----------------------------------------------------------
OVER3 AND R5,R5,#0   
ST3    LDR R4,R6,#0
    ADD R6,R6,#1
    LDR R3,R6,#0
    ADD R6,R6,#1
    LDR R7,R6,#0
    ADD R6,R6,#1
    ADD R6,R6,#-1
    STR R5,R6,#0
    RET;----------------------------------------------------------------------------------
CHECK-WEST    ADD R6,R6,#-1
    STR R7,R6,#0
    ADD R6,R6,#-1
    STR R3,R6,#0
    ADD R6,R6,#-1
    STR R4,R6,#0;----------------------------------------------------------
    LD  R1,POINTER1
    NOT R1,R1
    ADD R1,R1,#1;R1=-X4002;----------------------------------------------------------
    ADD R1,R1,R3;R1=OFFSET
    BRZ OVER4;----------------------------------------------------------
    LDI R0,M
    NOT R0,R0
    ADD R0,R0,#1;                      R0=-M;----------------------------------------------------------
JUDGE2    ADD R1,R1,R0
    BRZ OVER4
    ADD R1,R1,#0
    BRP JUDGE2;                       IF THE LOCATION IS ON THE LEFTEST COLUMN,WEST-LENGTH==0;----------------------------------------------
    ADD R0,R3,#-1
    LDR R2,R0,#0
    LDR R5,R3,#0
    NOT R2,R2
    ADD R2,R2,#1
    ADD R2,R2,R5
    BRNZ OVER4   ;                       IF *R0>*R3,THEN WESTLENGTH==0  ;----------------------------------------------------------
    ADD R3,R3,#-1 ;          R3=R3-1
    ADD R4,R4,#-1 ;          R4=R4-1
    JSR FUNCTION ;          IF *R0<*R3,THEN WESTLENGTH==FUNCTION(R3)
    LDR R5,R4,#0
    BRNZP ST4;----------------------------------------------------------
OVER4 AND R5,R5,#0
ST4    LDR R4,R6,#0
    ADD R6,R6,#1
    LDR R3,R6,#0
    ADD R6,R6,#1
    LDR R7,R6,#0
    ADD R6,R6,#1
    ADD R6,R6,#-1
    STR R5,R6,#0
    RET;--------------------------------------------------------------------------------------------------------------------
OPNUMBER  .FILL #-4
N   .FILL X4000
M   .FILL X4001
POINTER1 .FILL X4002
POINTER2 .FILL X5000
STACKPOINTER .FILL XFE00
SAVER0   .BLKW #1
SAVER1   .BLKW #1
SAVER2   .BLKW #1
SAVER3   .BLKW #1
SAVER4   .BLKW #1
SAVER5   .BLKW #1
SAVER6   .BLKW #1
SAVER7   .BLKW #1
SAVER8   .BLKW #1;SAVER8 = M * N
SAVER9   .BLKW #1
    .END;MAIN PROGRAM;---------------------------------------------------------------------------------------
.ORIG X5000
.BLKW #50
.END;50 LOCATIONS USED TO RECORD THE VALUE OF EVERY POINT;---------------------------------------------------
.ORIG x4000
.FILL #3 ; N
.FILL #4 ; M
.FILL #89 ; the map
.FILL #88
.FILL #86
.FILL #83
.FILL #79
.FILL #73
.FILL #90
.FILL #80
.FILL #60
.FILL #69
.FILL #73
.FILL #77
.END



