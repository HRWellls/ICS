#NOTE : the value of imm5 can only be -16~15
opcodedict={'ADD':'0001','AND':'0101','NOT':'1001','LD':'0010','LDR':'0110','LDI':'1010',\
            'LEA':'1110','ST':'0011','STR':'0111','STI':'1011','TRAP':'1111','BR':'0000111',\
            'BRn':'0000100','BRz':'0000010','BRp':'0000001','BRnz':'0000110','BRzp':'0000011',\
                'BRnzp':'0000111',\
            'BRnp':'0000101','JMP':'1100','JSR':'0100','JSRR':'0100','RTI':'1000000000000000',\
                '.ORIG':'0000','.FILL':'0000',\
            '.BLKW':'0111','.STRINGZ':'0000','.END':'0000','TRAP':'1111',\
            'RET':'1100000111000000','GETC':'1111000000100000','OUT':'1111000000100001',\
                'PUTS':'1111000000100010','IN':'1111000000100011',\
            'PUTSP':'1111000000100100','HALT':'1111000000100101'}
register={'R0':0,'R1':1,'R2':2,'R3':3,'R4':4,'R5':5,'R6':6,'R7':7}
def juhex(s):
    if(len(s)!=1):#长度只有一位，不是
        if(s[0]=='x'):#开头不是x，不是
            if(s[1]=='-'):
                return True#开头负号，是            
            else:
                for i in range(1,len(s)):
                    if(s[i]>='0' and s[i]<='9')or(s[i]>='a' and s[i]<='f'):
                        continue
                    else:
                        return False
                return True
        else:
            return False
    else:
        return False
class code:
    def __init__(self,lable,inst,PC:int,PCm):
        self.lable=lable#指令前标签
        self.inst=inst#指令主体
        #当前指令的位置
        self.PC=PC
        self.PCm=PCm
    def printdata(self):
        print("%s:%s=%s"%(self.PCm,self.lable,self.inst))
def output(m):
    # m.printdata()
    read=m.inst
    # print(read)
    opcode=read[0]
    # print('pc is %s pcm is %s'%(m.PC,m.PCm))
    # print(read)
    match opcode:
        case '.END':
            exit(0)
        case 'ADD'|'AND':
            print (opcodedict["%s"%opcode],end='')
            second=read[1][1]
            third=read[2][1]
            fourth=read[3]
            print('%s'%bin(int(second))[2:].zfill(3),end='')
            print('%s'%(bin(int(third))[2:].zfill(3)),end='')
            if(fourth in register):
                value=fourth[1]
                print('0%s'%binn(int(value),5))
            else:
                sign=fourth[0]
                if(sign=='#'):
                    print("1%s"%binn(fourth[1:],5))
                elif(sign=='x'):#不会有x开头的标签吧？？
                    # exit(1)
                    print("1%s"%hexx(fourth[1:],5))
                else:
                    exit(1)
                 

        case 'NOT':
            print (opcodedict["%s"%opcode],end='')
            second=read[1][1]
            third=read[2][1]
            print(('%s'%(bin(int(second)))[2:].zfill(3)),end='')
            print(('%s111111'%(bin(int(third)))[2:].zfill(3)))
        case 'LDR'|'STR':
            print (opcodedict["%s"%opcode],end='')
            second=read[1][1]
            print(('%s'%(binn(int(second),3))),end='')
            third=read[2][1]
            print(('%s'%(binn(int(third),3))),end='')
            fourth=read[3]
            sign=fourth[0]            
            if (sign=='#'):
                imm=fourth[1:]
                print(('%s'%(binn(int(imm),6))))
            elif(sign=='x'):
                imm=fourth[1:]
                print("%s"%hexx(imm,6))   
            else:
                print('Error')
        case 'LD'|'LDI'|'LEA'|'ST'|'STI':
            print (opcodedict["%s"%opcode],end='')
            second=read[1][1]
            print(('%s'%(binn(int(second),3))),end='')
            third=read[2]
            sign=third[0]
            
            if (sign=='#'): 
                imm=third[1:]
                print(('%s'%(binn(int(imm),9))))   
            else:
                place=search(third)
                offset=int(place)-int(m.PCm)-1
                print(('%s'%(binn(int(offset),9))))  
        case 'BR'|'BRn'| 'BRz'| 'BRp'| 'BRnz'| 'BRzp'| 'BRnp'| 'BRnzp':
            print (opcodedict["%s"%opcode],end='')
            second=read[1]
            sign=second[0]
            if (sign=='#'): 
                imm=second[1:]
                print(('%s'%(binn(int(imm),9))))   
            else:
                place=search(second)
                # print('target place %s'%place)###ffff
                offset=place-m.PCm-1
                print(('%s'%(binn(int(offset),9))))  
        case 'TRAP':
            print (opcodedict["%s"%opcode],end='')
            second=read[1]
            vecter=second[1:]         
            print("0000%s"%hexx(vecter,8))
        case 'GETC'|'OUT'|'PUTS'|'IN'|'PUTSP'|'HALT'|'RET'|'RTI':
             print (opcodedict["%s"%opcode])
        case 'JMP':
            print (opcodedict["%s"%opcode],end='')
            second=read[1][1]
            print(('000%s000000'%(binn(int(second),3))))
        case 'JSR':
            print (opcodedict["%s"%opcode],end='')
            second=read[1] 
            sign=second[0]
            if (sign=='#'):
                imm=second[1:]
                print(('1%s'%(binn(int(imm),11)))) 
            else:                       
                place=search(second)
                offset=place-m.PCm-1
                print("1%s"%binn(offset,11))
        case 'JSRR':
            print (opcodedict["%s"%opcode],end='')
            second=read[1]
            value=second[1]
            print("000%s000000"%binn(value,3))
        case '.BLKW':
            second=int(read[1][1:])
            for i in range(second):
                print('0111011101110111')
        case '.STRINGZ':
            # print(read.split[1])
            string=read[1]
            for c in string:
                print('%s'%binn(ord(c),16))
            print('%s'%binn(0,16))
        case '.ORIG':
            second=read[1][1:]
            # print(second)
            print('%s'%hexx(second,16))
        case '.FILL':
            sign=read[1][0]
            value=read[1][1:]
            if(sign=='x' or sign=="X"):
                print('%s'%hexx(value,16))
            else:
                print('%s'%binn(value,16))
        case _: 
            print ('error')

def hexx(m,n):#输入16进制字符串m和要求二进制长度n,给出对应二进制字符串
    m=int(m,16)
    # print('<%d>'%m)break
    return binn(m,n)

def binn(m,n):#m是输入十进制数字，n是要求输出二进制字符串位数，使用补码规则计算
    # print(type(m))
    m=int(m)
    if(m>=0):
        # print('p')
        tem=bin(m)[2:].zfill(n)
        # print(tem)
    else:
        # print('n')
        m=m+2**n
        tem=bin(m)[2:]
        # tem=list(tem)
        # print(tem)
    return tem
def search(m):
    for k in instruction:
        if(k.lable==m):
            # print()
            # print(k.PCm)
            return k.PCm#不可以在这里返回，我也不知道为什么.现在知道了
        else:
            continue
    exit(1)
    # return False
  #函数主体：
    # return k.PCm
instruction=[]#创建用于存放指令的列表
pc=0
PCM=1
while  (1):
    
    read = input()#第一次遍历，将指令存起来
    # if (read==''):
    #     continue
    nocommand=read   
    # print(nocommand)     
    if(read.isspace() or read==''):#先判断是否为整行空
        continue
    opcode=nocommand.split()[0]#取最开始的字符串
    head=opcode
    # print(opcode)
    if(opcode in opcodedict):
        if(opcode =='.STRINGZ'):  
            value=read.split('"',2)[1]          
            # strbody=(nocommand.split(' ',1)[1])
            PCM=pc
            pc=pc+1+len(value)
            instbody=[opcode,value]
            a=code('',instbody,pc,PCM)            
            # print(len(value))
            instruction.append(a)
            # a.printdata()
        elif(opcode=='.END'):
            PCM=pc
            pc=pc+1
            a=code('',[opcode],pc,PCM) 
            instruction.append(a)           
            break
        elif(opcode=='.BLKW'):
            value=nocommand.split()[1][1:]
            # print(value)
            PCM=pc
            pc=pc+int(value)
            so=[nocommand.split()[0],nocommand.split()[1]]
            a=code('',so,pc,PCM)
            instruction.append(a)
        else:
            PCM=pc
            pc=pc+1
            a=code('',nocommand.split(),pc,PCM)    
            instruction.append(a)
            # print (nocommand)
            # a.printdata()
    else:
        opcode=read.split()[1]
        if(opcode=='.END'):
            PCM=pc
            pc=pc+1
            a=code(head,[opcode],pc,PCM) 
            instruction.append(a)
            break
        elif(opcode =='.STRINGZ'):
            head=read.split()[0]
            value=read.split('"',2)[1]
            # strbody=(nocommand.split(' ',2)[2])           
            PCM=pc
            pc=pc+1+len(value)
            instbody=[opcode,value]
            a=code(head,instbody,pc,PCM)           
            instruction.append(a)
            # a.printdata()
        elif(opcode=='.BLKW'):
            value=nocommand.split()[2][1:]
            # print('!!!')
            PCM=pc
            pc=pc+int(value)
            # print(value)
            instbody=[nocommand.split()[1],nocommand.split()[2]]
            # print(instbody)
            a=code(head,instbody,pc,PCM)
            instruction.append(a)
        else:
            PCM=pc
            pc=pc+1
            a=code(nocommand.split()[0],nocommand.split()[1:],pc,PCM)
            instruction.append(a)
            # a.printdata()   
# for i in instruction:
#     print("<%s>"%i.lable) 
for i in instruction:#开始转码
    
    output(i)
exit(0)
