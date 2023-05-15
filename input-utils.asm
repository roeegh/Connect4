# Check if the target column is full
# Arguments: $a0 = column
# Returns: $v0 = successful?
# Variables: $t0 = row, $t1 = index, $t2 = currently-selected value of grid
validateFull:
	# Loop through rows 5, 4, 3, 2, 1, 0 and see if that spot on the grid is empty. Column is fixed throughout this process.
	li $t0, 5
validateFullLoop:
	# If selected row is less than zero, it means the target column is full
	blt $t0, 0, validateFullFalse
	
	# Calculate index = 7 * row + column
	mul $t1, $t0, 7 # Set $t1 = $t0 * 7
	add $t1, $t1, $a0 # Add $a0 (column) to $t1
	
	# Get value of the grid at index and if it's zero, both validation checks are passed, continue otherwise
	lb $t2, grid($t1)
	beq $t2, 0, validateFullTrue
	
	# Decrement and continue loop
	addi $t0, $t0, -1
	j validateFullLoop
validateFullTrue:
	# Save row and column in memory
	sb $t0, target
	sb $a0, target+1
	
	# Set the value at grid to current player + 1 (remember that grid values 1 and 2 are red and yellow respectively, while current player is 0 and 1 for red and yellow respectively)
	lb $t0, player
	addi $t0, $t0, 1
	sb $t0, grid($t1)
	
	li $v0, 1
	jr $ra
validateFullFalse:
	li $v0, 0
	jr $ra