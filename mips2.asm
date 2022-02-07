.text
    li $a1, 100  # set $a1 to the max bound.
    add $a0, $a0, 0 # set $a0 to lowesst bound
    li $v0, 42  # generates the random number.
    syscall
    li $v0, 1   # print integer
    syscall
    
    exit:
        li $v0, 10 #Exit syscall
        syscall
