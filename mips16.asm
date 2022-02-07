.data
	quarter: .word 25
	dime: .word 10
	nickel: .word 5

	quarterTotal: .asciiz " quarter(s), "
	dimesTotal: .asciiz " dime(s), "
	nickelsTotal: .asciiz " nickel(s), "
	penniesTotal: .asciiz " pennies \n"
	prompt: .asciiz "Enter a number in range 0-100: "
.text

# Print prompt message
li $v0, 4
la $a0, prompt
syscall

# Get user input
li $v0, 5
syscall
move $t0, $v0

lw $t1, quarter
div $t0, $t1
mflo $t2 #num of quaters
mfhi $t0 #remaining total

lw $t1, dime
div $t0, $t1
mflo $t3 #num of dimes
mfhi $t0 #remaining money

lw $t1, nickel
div $t0, $t1
mflo $t4 #num of nickels
mfhi $t0 #remaining money and num of pennies

#print the quarters from t2, dimes from $t3, nickels from $t4 and pennies from $t0

li $v0, 1
move $a0, $t2
syscall
li $v0, 4
la $a0, quarterTotal
syscall


li $v0, 1
move $a0, $t3
syscall
li $v0, 4
la $a0, dimesTotal
syscall

li $v0, 1
move $a0, $t4
syscall
li $v0, 4
la $a0, nickelsTotal
syscall


li $v0, 1
move $a0, $t0
syscall
li $v0, 4
la $a0, penniesTotal
syscall

#exit
li $v0, 10
syscall

