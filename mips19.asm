#data section

.data

print: .asciiz "Enter the decimal number to convert: "

output: .asciiz "\nHexadecimal equivalent string: "

s: .space 8

#text secition

.text

.globl main

#main method

main:

#print the input message

la $a0, print

li $v0, 4

syscall

#read the input integer

li $v0, 5

syscall

#move input value in regsiter $t2

move $t2, $v0

la $a0, output

li $v0, 4

syscall

#start the counter

li $t0, 8

la $t3, s

#start the function label   

numberT0string:

#compare $t0 and output come of EXit label

#is equal or not

beqz $t0, exit  

#rotate the bits to left

rol $t2, $t2, 4

# mask with 1111

and $t4, $t2, 0xf

ble $t4, 9, compute

# if less than or equal to nine, branch to sum

# if greater than nine, add 55

addi $t4, $t4, 55

b compare

#declare label sum

compute:

#add the register t0 48

addi $t4, $t4, 48

#implement label compare

compare:

# store hex digit into result

sb $t4, 0($t3)   

# increment address counter   

addi $t3, $t3, 1   

# decrement loop counter

addi $t0, $t0, -1

#call function   

j numberT0string

exit:

#print the otut

la $a0, s

li $v0, 4

syscall

#break from the program

la $v0, 10

syscall