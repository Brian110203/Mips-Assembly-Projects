.data
strNum: .asciiz "00000000"
num: .word 0
prompt1: .asciiz "Enter a number between -128 and 127 :"
msg0: .asciiz "\n binary value= "
msg1: .asciiz "\nabsolute value = "
msg2: .asciiz "\n1's complement = "
msg3: .asciiz "\n2's complement = "
newline: .asciiz "\n"
errMsg: .asciiz "Error: Out of range"
#main
.text
   # prompt for an integer
   la $a0,prompt1
   li $v0,4
   syscall
   # read an integer
   li $v0,5
   syscall
   # check whether the value is within the range or not
   blt $v0,-128,outofrange
   bgt $v0,127,outofrange
   # save the integer into num
   sw $v0,num
   # check whehter the user entered number is positive or negative
   bltz $v0,call2scomplement
   # pass address(pointer) of num and address of strNum
   # to function
   la $a0,num
   la $a1,strNum
   jal toBinary       # if user enters a +ve number, call toBinary
   la $a0,msg0
   li $v0,4
   syscall  
   la $a0,strNum
   li $v0,4
   syscall
   la $a0,newline
   li $v0,4
   syscall
   j exit
call2scomplement:
   # pass address(pointer) of num and address of strNum
   # to function
   la $a0,num
   la $a1,strNum
   jal twoComplement   # if user enters a -ve number, call twoComplement
   j exit
   # if user enters an out of range number, print error message
outofrange:          
   la $a0,errMsg
   li $v0,4
   syscall
   # exit the program
exit:
   li $v0,10
   syscall
################################# toBinary ###################################
toBinary:  
   lw $t0,0($a0)       # load the integer
   li $t1,7       # loop counter
loop1:  
   add $t2,$a1,$t1       # $t2=address of character at index $t1
   div $t0,$t0,2       # $t0=$t0/2
   mfhi $t3       # $t3=$t0%2(remainder)
   beqz $t3,store0       # if remainder is 0, store '0' into location $t2
   li $t4,'1'       # $t4='1'
   sb $t4,0($t2)       # otherwise, store '1' into location $t2
   j next           # jump to label next
store0:              
   li $t4,'0'       # $t4='0'
   sb $t4,0($t2)       # store '0' into location $t2
next:              
   beqz $t0,exitloop1   # if $t0 is zero, exit the loop
   sub $t1,$t1,1       # otherwise decrement the loop counter by 1
   j loop1           # go to loop1
exitloop1:
   jr $ra           # return
############################# twosComplement ######################################
twoComplement:
   addi $sp,$sp,-4       # make a room in stack to store return address
   sw $ra,0($sp)       # save return address
      
   lw $t0,0($a0)       # load the negative integer
   not $t0,$t0      
   add $t0,$t0,1       # $t0=absolute value of the integer
   sw $t0,0($a0)       # save back value into num
   jal toBinary       # call toBinary
   # print the returned bainry string of the absolute value
   la $a0,msg1
   li $v0,4
   syscall  
   la $a0,strNum
   li $v0,4
   syscall
   la $a0,newline
   li $v0,4
   syscall
   # do 1's complement(flip the binary bits)
   li $t1,7       # loop counter
loop2:
   add $t2,$a1,$t1       # $t2=address of the character at index $t1
   lb $t3,0($t2)       # load the binary bit(character) from location $t2
   beq $t3,'0',flipto1   # if the binary bit is 0, flip it to 1  
   li $t4,'0'
   sb $t4,0($t2)       # save 0
   j next1
flipto1:           # if the binary bit is 1, flip to 0 and store back
   li $t4,'1'      
   sb,$t4,0($t2)       # save 1
next1:
   beqz $t1,exitloop2   # if $t1 is 0, exit the loop
   sub $t1,$t1,1       # otherwise, decrement the loop counter by 1
   j loop2           # jump to loop2
exitloop2:          
   # display the 1's complement
   la $a0,msg2
   li $v0,4
   syscall  
   la $a0,strNum
   li $v0,4
   syscall
   la $a0,newline
   li $v0,4
   syscall
   # add 1 to result of 1's complement
   li $t0,7       # loop counter
   li $t7,1       # $t7=carry=1
loop3:
   add $t1,$t0,$a1       # $t1= address of character at index $t0
   lb $t2,0($t1)       # load binary bit
   sub $t2,$t2,48       # $t2=$t2-48. 48 is the ASCII for '0'
   add $t2,$t2,$t7       # $t2=$t2+carry
   and $t3,$t2,0x01   # $t3=sum & 0x01
   add $t3,$t3,'0'       # $t3=$t3+'0'
   sb $t3,0($t1)       # save back the result of the addition
   srl $t2,$t2,1       # shift right the sum($t2)
   and $t7,$t2,0x01   # carry($t7)= $t2 & 0x01
   beqz $t0,exitloop3   # if $t0 is 0, exit the loop
   sub $t0,$t0,1       # otherwise, decrement the loop counter by 1
   j loop3           # jump to loop3
exitloop3:
   # display the 2's complement
   la $a0,msg3
   li $v0,4
   syscall  
   la $a0,strNum
   li $v0,4
   syscall
   la $a0,newline
   li $v0,4
   syscall
      
   lw $ra,0($sp)       # restore the return address
   addi $sp,$sp,4       # re set the stack pointer
   jr $ra           # return