li $v0, 32 # sleep call
li $a0, 4000 # duration to sleep
syscall
exit:
     li $v0, 10 #Exit syscall
     syscall