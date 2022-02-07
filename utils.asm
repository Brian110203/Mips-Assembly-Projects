.data
	myFile: .asciiz "C:\\mips input\\input.txt"      # filename for input
	buffer: .space 1024
	error_msg:		.asciiz 	"Invalid hexadecimal number." 
	char_a: 		.byte 		'a'
	char_g: 		.byte 		'g'	
	char_A: 		.byte 		'A'
	char_G:			.byte 		'G'
	char_0: 		.byte 		'0'
	char_colon: 		.byte 		':'
	decimal_result: 	.word 		0
	new_line_char: 		.byte 		10
	end_line_char: 		.byte 		0
	space_char: 		.byte 		32
	



