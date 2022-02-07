.data
 	start: 		.asciiz "Quess a number between 0 and 100\n" 
 	input: 		.asciiz "Your guess: " 
 	low: 		.asciiz "Too low\n" 
 	high: 		.asciiz "Too high.\n" 
 	success: 	.asciiz "Correct!\n" 
 	again: 		.asciiz "\nplay again? (0 - no, 1 - yes): "
 	guesses:	.asciiz "Guesses: " 
 
 .text 
 addi $v0, $zero, 30 # low order bits of system time
 syscall # $a0 contains the 32 least significant bits
 
 add $t0, $zero, $a0 # put the $a0 value in $t0
 addi $v0, $zero, 40 # set seed for random number generation 
 add $a0, $zero, $zero # set ID for generator to 0
 add $a1, $zero, $t0 # use random seed in $t0
 syscall 
 
 addi $t5,$0,1 # set the game to play initially, t5 is the choice of whether the user wishes to play again
 
 main: beq $t5,$0,END # if choice is 0, exit
 addi $v0, $zero, 42 #set range of random int
 add $a0, $zero, $zero # set range for generator 0 
 addi $a1, $zero, 101 # set upper bound of the random num
 syscall 
 
 add $s0, $zero, $a0 # put the random number in $s0
 
 la $a0,start # print the start message
 li $v0,4 # print the string
 syscall 
 
 addi $t4,$0,0 # num of guesses = 0
 
 loop: la $a0,input # print input message and guess value
 li $v0,4 # print string
 syscall 
 
 li $v0,5 # get input from user 
 syscall 
 
 move $t3,$v0 # move the guess to register $t3 
 addi $t4,$t4,1 # add 1 to the number of guesses 
 beq $t3,$s0,correct # correct guess 
 bgt $t3,$s0,greater # too high
  # else it's too low
 la $a0,low # print that guess is too low 
 li $v0,4  # print string
 syscall 
 
 j loop # jump to loop again 
 
 greater: la $a0,high # print that guess is high 
 li $v0,4 
 syscall 
 
 j loop # jump to loop again 
 
 correct: la $a0,success # print success message 
 li $v0,4 
 syscall 
 
 la $a0,guesses # print guesses
 li $v0,4 
 syscall 
 
 move $a0,$t4 
 li $v0,1 
 syscall 
 
 la $a0,again # print message to ask user to play again
 li $v0,4 
 syscall 
 
 li $v0,5 # take user input 
 syscall 
 
 move $t5,$v0 # move input to $t5 
 j main # jump to main game with choice in $t5 
 
 END: li $v0,10 # exit the program 
 syscall