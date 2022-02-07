.data
prompt: .asciiz "\nEnter an integer: "
result: .asciiz "\nResult (x10): "

.text
li $v0,4 #print string
la $a0,prompt #specify prompt
syscall

li $v0,5 #read user integer
syscall
move $t1,$v0 #move value

#Use shift left to get the value multiplied by 8 and 2
sll $s0,$t1,3 #x8
sll $s2,$t1,1 #x2

add $s3,$s2,$s0 #add the results rom the shift left operators together

li $v0,4
la $a0,result #it will print prompt
syscall

#print integer
move $a0,$s3
li $v0,1
syscall
