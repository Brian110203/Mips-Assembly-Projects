.data
  msg1:
    .asciiz "Enter a number in base 2 (-2 to quit): "
  msg2:
    .asciiz "\nResult: "
  allOnes:
    .asciiz "1111111111111111"
  empty:
    .space 16
  newLine:
    .asciiz "\n"
  sum:
    .space 16 
  sumMsg:
    .asciiz "\nSUM: "
  oneFound:
    .asciiz "\nOne found\n"
  zeroFound:
     .asciiz "\nZero found\n"
.text
.globl main
main:

getNum:
li $v0,4        # Print string system call
la $a0,msg1         #"Please insert value (A > 0) : "
syscall

la $a0, empty
li $a1, 16              # load 16 as max length to read into $a1
li $v0,8                # 8 is string system call
syscall

la $a0, empty
li $v0, 4               # print string
syscall

li $t4, 0               # initialize sum to 0

startConvert:
  la $t1, empty
  li $t9, 16             # initialize counter to 16

firstByte:
  lb $a0, ($t1)      # load the first byte
  blt $a0, 48, printSum    # I don't think this line works 
  addi $t1, $t1, 1          # increment offset
  subi $a0, $a0, 48         # subtract 48 to convert to int value
  subi $t9, $t9, 1          # decrement counter
  beq $a0, 0, isZero
  beq $a0, 1, isOne
  j convert     # 

isZero:
   j firstByte

 isOne:                   # do 2^counter 
   li $t8, 1               # load 1
   sllv $t5, $t8, $t9    # shift left by counter = 1 * 2^counter, store in $t5
   add $t4, $t4, $t5         # add sum to previous sum 

   move $a0, $t4        # load sum
   li $v0, 1              # print int
   syscall
   j firstByte

convert:

printSum:
   srlv $t4, $t4, $t9

   la $a0, sumMsg
   li $v0, 4
   syscall

 move $a0, $t4      # load sum
 li $v0, 1      # print int
 syscall

exit:
   li $v0, 10       # exit system call
   syscall