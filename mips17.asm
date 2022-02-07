.data 
x: .word 0x3D
 
.text 
lw $s0,x                    #s0 = x 
addiu $t0,$zero,31          #(t0) i == 31 (the counter) 
li $t1,1                    #(t1) mask 
sll $t1,$t1,31            
li $v0,1                    #prepare system call for printing values 
 
loop: beq $t0,-1,end_loop   #if t0 == -1 exit loop 
  and $t3,$s0,$t1           #isolate the bit 
  beq $t0,$0,after_shift    #shift is needed only if t0 > 0 
  srlv $t3,$t3,$t0          #right shift before display 
  after_shift: 
  move $a0,$t3              #prepare bit for print 
  syscall                   #print bit 
 
  subi $t0, $t0, 1          #decrease the counter 
  srl $t1,$t1, 1            #right shift the mask 
  j loop 
  
end_loop: 