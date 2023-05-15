# Iterates through the grid and displays the board
displayBoard:
	li $t0, 0
displayBoardLoop:
	# Exit loop if index >= 42
	bge $t0, 42, displayBoardEnd
	
	# Load value of board (grid[$t0]) into $t1 and print the right piece of the board based on that value
	li $v0, 4 # Syscall #4: Print String
	lb $t1, grid($t0)
	beq $t1, 0, displayBoardEmpty
	beq $t1, 1, displayBoardRed
	beq $t1, 2, displayBoardYellow
	
	# To reduce redundancy, load syscall value $v0 before branching then call "syscall" after branching.
displayBoardEmpty:
	la $a0, boardEmptyColumn
	j displayBoardContinue
displayBoardRed:
	la $a0, boardRedColumn
	j displayBoardContinue
displayBoardYellow:
	la $a0, boardYellowColumn
	j displayBoardContinue
displayBoardContinue:
	syscall
	
	# If the index ($t0) is the last column of that row (where $t0 % 7 == 6), print the finishing pipe and the newline
	li $t1, 7 # $t1 is now the divisor
	div $t0, $t1 # HI register contains remainder (modulo)
	mfhi $t1 # $t1 is now the remainder
	bne $t1, 6, displayBoardContinue2 # Skip the following section if $t0 % 7 != 6
	
	li $v0, 4 # Syscall #4: Print String
	la $a0, boardEndOfRow
	syscall
	
displayBoardContinue2:
	# Increment and loop
	addi $t0, $t0, 1
	j displayBoardLoop
displayBoardEnd:
	jr $ra