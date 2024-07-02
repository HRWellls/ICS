    .ORIG x3000
    LD R0,NUMBER5       ;把x4000放入R0
    LDR R1,R0,0         ;把str1的首地址放入R1
    ADD R1,R1,#-1       ;R1=R1-1

    LD  R0,NUMBER2      ;令R0=-65
    
    LD  R6,NUMBER3      ;令R6=-25
    
    LD  R7,NUMBER4      ;令R7=-32

S1  ADD R1,R1,#1        ;得到str1的首个字符的地址
    LDR R2,R1,0         ;得到str1的首个字符 放入R2
    BRz S12              ;如果是最后一个字符0，则开始读入str2
    ADD R3,R2,R7
    BRz S1              ;若字符为空格，取str1的下一个字符
    ADD R3,R2,R0        ;计算该字符与‘A’的差距
    ADD R4,R3,R6       
    BRnz CONTINUE1
    ADD R3,R3,R7        ;若差距大于25，则说明是小写字符，需要减去32
CONTINUE1 LD R4,NUMBER6     ;把T1空间的首地址放入R4
    ADD R4,R4,R3        ;找到该字符对应的储存地址
    LDR R5,R4,0
    ADD R5,R5,#1
    STR R5,R4,0         ;对应的字符出现次数加1
    BRnzp S1

S12    LD R0,NUMBER8       ;把x4001放入R0
    LDR R1,R0,0         ;把str2的首地址放入R1
    AND R5,R5,0
    ADD R5,R5,#-1
    ADD R1,R1,R5        ;R1=R1-1

    LD  R0,NUMBER2      ;令R0=-65
    
S2  ADD R1,R1,#1        ;得到str2的首个字符的地址
    LDR R2,R1,0         ;得到str2的首个字符 放入R2
    BRz BREAK           ;如果是最后一个字符0，则开始读入读去完成，开始最后一步比较
    ADD R3,R2,R7        
    BRz S2              ;若字符为空格，取str2的下一个字符
    ADD R3,R2,R0        ;计算该字符与‘A’的差距
    ADD R4,R3,R6
    BRnz CONTINUE2
    ADD R3,R3,R7        ;若差距大于25，则说明是小写字符，需要减去32
CONTINUE2 LD R4,NUMBER7     ;把S2空间的首地址放入R4     
    ADD R4,R4,R3        ;找到该字符对应的储存地址
    LDR R5,R4,0
    ADD R5,R5,#1
    STR R5,R4,0         ;对应的字符出现次数加1
    BRnzp S2
    
BREAK AND R0,R0,#0      ;R0=0
    LD R1,NUMBER6       ;取T1的首地址放入R1
    LD R2,NUMBER7       ;取T2的首地址放入R2

    ADD R0,R0,#-1       ;R0=R0-1
    
LOOPTEST    ADD R0,R0,#1
    ADD R7,R0,R6
    BRp YES             ;循环26后说明符合题意
    LDR R3,R1,0         ;把R1的字符出现次数放入R3
    LDR R4,R2,0         ;把R2的字符出现次数放入R4
    NOT R4,R4
    ADD R4,R4,#1        ;R4=-R4
    ADD R5,R4,R3
    BRnp NO             ;如果R3、R4不相等，则不符题意
    ADD R1,R1,#1     
    ADD R2,R2,#1        ;R1、R2两个指针都后移1位
    BRnzp LOOPTEST
 
YES LEA R0,STRING1
    TRAP x22
    TRAP x25
NO  LEA R0,STRING2  
    TRAP x22
    TRAP x25    

STRING1  .STRINGZ "YES"
STRING2  .STRINGZ "NO"


NUMBER2 .FILL #-65
NUMBER3 .FILL #-25
NUMBER4 .FILL #-32
NUMBER5 .FILL x4000   
NUMBER6 .FILL x5000
NUMBER7 .FILL x6000
NUMBER8 .FILL x4001

    .END
    
.ORIG x4000
.FILL str1
.FILL str2
str1 .STRINGZ "A"
str2 .STRINGZ "a"
.END

    .ORIG x5000
    .BLKW 26        ;开辟第1片区域用来哈希str1
    .END
    
    .ORIG x6000
    .BLKW 26        ;开辟第2片区域用来哈希str2
    .END
