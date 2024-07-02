      .ORIG X3000
      LD R1,POSITION1;R1=LEFT POINTER;START AT X4000
      LD R2,POSITION2;R2=RIGHT POINTER;START AT X3FFF
      AND R3,R3,#0;R3=NUMBER OF DATA IN STACK
      LD R7,POP

NEW   GETC;            GRAB A NEW CHARACTOR
      LD R6,ENTERKEY;JUDGE ENTERKEY TO JUDGE WETHER IT IS OVER
      OUT;             DISPLAY
      ADD,R6,R6,R0;    JUDGE : R0==ENTERKEY ?
      BRZ PRINT;        START TO PRINT

      LD R4,LADDING;
      ADD R5,R4,R0;
      BRZ LADD; 
      
      LD R4,RADDING;
      ADD R5,R4,R0;
      BRZ RADD;
      
      LD R4,LMINING;
      ADD R5,R4,R0;
      BRZ LMIN;
      
      LD R4,RMINING;
      ADD R5,R4,R0;
      BRZ RMIN;                            JUDGE THE CHARACTOR : + - [ ]
    

LADD  GETC
      OUT
      ADD R1,R1,#-1
      STR R0,R1,0;
      ADD R3,R3,#1
      BRNZP NEW
    
LMIN  ADD R3,R3,#0
      BRZ EMPTY
      LDR R0,R1,0
      STR R0,R7,0
      ADD R7,R7,#1
      ADD R1,R1,#1
      ADD R3,R3,#-1
      BRNZP NEW

RADD  GETC
      OUT
      ADD R2,R2,#1
      STR R0,R2,0;
      ADD R3,R3,#1
      BRNZP NEW      
    
RMIN  ADD R3,R3,#0
      BRZ EMPTY    
      LDR R0,R2,0
      STR R0,R7,0
      ADD R7,R7,#1
      ADD R2,R2,#-1
      ADD R3,R3,#-1
      BRNZP NEW
    
    
EMPTY LD R6,UNDERLINE
      STR R6,R7,#0
      ADD R7,R7,#1 
      BRNZP NEW

PRINT AND R6,R6,#0
      STR  R6,R7,#0
      LD  R0,POP
      PUTS
      
      
OVER  HALT

POP .FILL X5000
ENTERKEY .FILL XFFF6 ;
UNDERLINE .FILL X5F;
    
LADDING .FILL XFFD5  ;-43
LMINING .FILL XFFD3  ;-45 
RADDING .FILL XFFA5  ;-91
RMINING .FILL XFFA3  ;-93
    
POSITION1 .FILL X4000    
POSITION2 .FILL X3FFF 

 

      

      .END
    
    
    

