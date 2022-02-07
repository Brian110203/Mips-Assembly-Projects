.text
main:
        li $v0, 31 #Specifies MIDI out
        la $a0, 60 #Pitch C
        la $a1, 4000 #Duration in millieconds
        la $a2, 65 #Instrument (Soprano Sax)
        la $a3, 127 #Volume (Max)
        syscall
        
    exit:
        li $v0, 10 #Exit syscall
        syscall
