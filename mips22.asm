.data
	.include "utils.asm"
.text
	main:	
		#Open File
		li   $v0, 13          # system call for open file
		la   $a0, myFile      # input file name
		li   $a1, 0           # flag for reading
		li   $a2, 0           # ignore node
		syscall             
		move $s0, $v0         # save the file descriptor  

		# read from file
		li   $v0, 14        # system call for reading from file
		move $a0, $s0       # get the file desciptor
		la   $a1, buffer    # read the buffer
		li   $a2,  33       # length of buffer
		syscall
	
		# Calculate decimal value
		la $s0, buffer				# Store address of the buffer (Data in file)
	    	add $s1, $zero, $zero			# Initialize $s1 to zero so it can store the decimal value

		# Store non number / letter charactors
		lb $s3, space_char
		lb $s4, end_line_char
		lb $s5, new_line_char

		addi $t7, $zero, 0 # Initialize offset to zero
	
		# Loop until non letter / number values are found
		Loop1:
			add $t0, $s0, $t7				# Add 1 to the address each loop
			lb $t6, 0($t0)					# Store the first char of $t0 to $t6
			beq $t6, $s4, EndOfString			# If current char is end_line_char, end string (end program)
 			beq $t6, $s5, EndOfString			# If current char is new_line_char, end string (end program)
			addi $t7, $t7, 1				# Increment the offset
			j Loop1			
	
		EndOfString:
			add $t8, $zero, $t7              		# Set offset limit to $t7
		
		# Check for leading spaces
		addi $t7, $zero, 0                  			# Initialize offset to zero
		
		Loop2: 
			add $t0, $s0, $t7               		# Add 1 to the address each loop
            		lb $t6, 0($t0)                  		# Store the first char of $t0 to $t6
            		beq $t7, $t8, Invalid       			# If offset is the offset limit, tell user, exit
            		bne $t6, $s3, EndIndex     			# If current char is not space call EndIndex
            		addi $t7, $t7, 1                		# Increment the offset
            		j Loop2
            		
		EndIndex:
			addi $t8, $t8, -1				# Inititalize offset to offset limit - 1


		# Check for ending spaces
		Loop3:
            		add $t0, $s0, $t8               		# Increment the address
            		lb $t6, 0($t0)                  		# Store the first char of $t0 to $t6
            		bne $t6, $s3, InitializeIndex     		# If current char is not space call InitializeIndices
            		addi $t8, $t8, -1               		# Decrement the offset
            		j Loop3
		

		InitializeIndex:
			add $a1, $zero, $t7				# set offset to 0
			add $t1, $zero, $t8				# Set offset limit
		

		Loop4:
            		add $t0, $s0, $a1       			# Increment the address
			lb $a2, 0($t0)					# Stores the first char in $t0 to $a2

			# Check if characters in hex number are valid
			lb $t6, char_g					
			slt $t5, $a2, $t6				
			beq $t5, $zero, Invalid			

			lb $t6, char_a					
			slt $t5, $a2, $t6				
			beq $t5, $zero, Between_a_and_f			

			lb $t6, char_G					
			slt $t5, $a2, $t6				
			beq $t5, $zero, Invalid				

			lb $t6, char_A					
			slt $t5, $a2, $t6				
			beq $t5, $zero, Between_A_and_F			

			lb $t6, char_colon				
			slt $t5, $a2, $t6				
			beq $t5, $zero, Invalid				
			
			lb $t6, char_0					
			slt $t5, $a2, $t6				
			bne $t5, $zero, Invalid							

			# Else it is between 0 and 9
			lb $s2, char_0                  		
            		j Continue                      		


			Between_A_and_F:
				lb $s2, char_A          		# Set $s2 to char code of 'A'
                		addi $s2, $s2, -10      		# Subtract 10 from $s2 becas "A" is 10 in hex
                		j Continue              		# Continue
			
			Between_a_and_f:
				lb $s2, char_a				
				addi $s2, $s2, -10			
				j Continue				
			
			Continue:
		 		jal AddDigit				# Call AddDigit
		 		beq $a1, $t1, PrintDec			# Call printdec if $a1 and $t1 are equal
				sll $s1, $s1, 4				# Shift $s1 left by 4 (x16)
				addi $a1, $a1, 1			# Increse the offet
		 		j Loop4
		 		
		 	AddDigit:
				# Adds the digit in $a2 to $s1
				sub $a2, $a2, $s2 
				or $s1, $s1, $a2	
				jr $ra


		# Divide by 10 until quotient is 0, tore char code of remainders, print each char in reverse.
		PrintDec:
			addi $t4, $zero, 10				# Set $t4 to 10
			addi $t6, $zero, 0				# Set counter to 0
			
			Loop5:
				divu $s1, $t4				# Put Remainder in HIGH, Quotient in LOW
				mflo $s1				# Set $s1 to the quotient
				mfhi $t1				# Store the remainder in $t1 (digit)
				addi $t1, $t1, 48			# Add 48 to the remainder (char code of 0 in asciiz)
				
				# Store the address of the stack pointer in $t2 and add the counter to it
				la $t2, ($sp)
				add $t2, $t2, $t6
				
				sb $t1, 0($t2)				# Store the least significant byte of $t1 to the stack
				
				# Quotent = 0, go to loop 6
				beq $s1, $zero, Loop6
				
				addi $t6, $t6, 1			# Add 1 to the counter
			
				j Loop5
			
			Loop6:
				
				# Store address of stack pointer and add counter
				la $t2, ($sp)
				add $t2, $t2, $t6
				
				
				lb, $a0, 0($t2)				# Store first byte of $t2 in $a0
				li $v0, 11				# Print character
				syscall
				
				beq $t6, $zero, Continue2		# If the counter is 0 exit loop to Continue2
				
				addi $t6, $t6, -1			# Subtract 1 from the counter (Print in reverse of stack)
				
				j Loop6
					
			Continue2:
				j Exit


		# Else, print error message
		Invalid:
			li $v0, 4
			la $a0, error_msg
			syscall
			
			j Exit

	
		# Exit the program
		Exit:
			li $v0, 10
			syscall