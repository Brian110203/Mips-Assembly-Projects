.text
main:
la $a0, prompt # Specify prompt
la $a1, input # Specify input
li $a2, 200 # Amount of bytes

li $v0, 54 # Open input box
syscall
 
 li $v0, 55 # Print String for input
 la $a0, input # Specify Input
 syscall

 # Exit the program
 li $v0, 10 # Exit Syscall
 syscall
 
.data
input: .space 200 # Specify amount of bytes for use
inputSize: .word 80 # Specify word size
prompt: .asciiz "Please enter an string: "
output: .asciiz "\nYou typed the string: "
