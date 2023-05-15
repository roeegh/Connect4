# Asks the current user for input, then adds it to the board
inputColumn:
	li $v0, 4 # Syscall #4: Print String
	la $a0, input
	syscall
	
inputLoop:
	# Wait for input, validate, then loop if invalid input
	li $v0, 5 # Syscall #5: Read Int
	syscall # $v0 contains the result
	
	# Validate: Is the input between 1 and 7 inclusive?
	# Jump to inputLoopInvalidRange if $v0 < 1 or $v0 > 7, otherwise, jump to validateFull after setup
	blt $v0, 1, inputLoopInvalidRange
	bgt $v0, 7, inputLoopInvalidRange
	
	# Validate: Is the target column full?
	add $s0, $ra, $zero # Store the return address to main in $s0
	addi $a0, $v0, -1 # Make sure to subtract 1 from $v0 because the user inputs 1-7 but columns work from 0-6.
	jal validateFull
	add $ra, $s0, $zero # Restore return address
	
	# Evaluate $v0
	beq $v0, 0, inputLoopInvalidSpace
	jr $ra # Exit the input loop since validation is successful
	
inputLoopInvalidRange:
	li $v0, 4 # Syscall #4: Print String
	la $a0, inputErrorRange
	syscall
	j inputLoop
inputLoopInvalidSpace:
	li $v0, 4 # Syscall #4: Print String
	la $a0, inputErrorFull
	syscall
	j inputLoop