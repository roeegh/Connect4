# This is the computer's input, which is just a random number generator that validates if there's space in its most basic form
autoinputColumn:
	li $v0, 42 # Syscall #42: RNG from zero to $a1 (not including $a1)
	li $a1, 7
	syscall # Returns in $a0, conveniently ties into the subroutine below
	add $s1, $a0, $zero # Just store the column in $s1 beforehand
	
	# Validate: Is the target column full?
	add $s0, $ra, $zero # Store the return address to main in $s0
	jal validateFull
	add $ra, $s0, $zero # Restore return address
	
	# Evaluate $v0
	beq $v0, 0, autoinputColumn # Continue looping if selected column is full
	
	li $v0, 4 # Syscall #4: Print String
	la $a0, autoinput
	syscall
	
	li $v0, 1 # Syscall #1: Print Int
	addi $a0, $s1, 1 # Display the stored column starting from 1 (hence adding 1 to $s1)
	syscall
	
	li $v0, 4 # Syscall #4: Print String
	la $a0, autoinputEnd
	syscall
	
	jr $ra