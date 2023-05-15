# Iterates through the grid and checks if the board is full:
# - Immediately returns if there's still a spot
# - Declares a draw and exits the program if the board is full
fullBoard:
	li $t0, 0
fullBoardLoop:
	# Exit loop if index >= 42
	bge $t0, 42, fullBoardEnd
	
	# Load value of board (grid[$t0]) into $t1 and check if it's empty
	lb $t1, grid($t0)
	beq $t1, 0, fullBoardReturn
	
	# Increment and loop
	addi $t0, $t0, 1
	j fullBoardLoop
fullBoardReturn:
	jr $ra
fullBoardEnd:
	li $v0, 4 # Syscall #4: Print String
	la $a0, stalemate
	syscall
	j exit
