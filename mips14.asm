main:
 la $a0, prompt
 jal PromptString
 
 la $a0, input
 lw $a1, inputSize
 jal PrintString
 
 la $a0, prompt2
 jal PromptInt
 
 la $a0, output2
 jal PrintInt

 jal Exit
 
.data
inputSize: .word 80
prompt: .asciiz "Please enter your name: "
prompt2: .asciiz "\nPlease enter your age: "
output2: .asciiz "\nYour age is "
.include "utils.asm"