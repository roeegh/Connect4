# Checks if the grid has a win condition, returns to main if no win condition
# 1. Initialize distance
# 2. Go in first direction and count how many spaces you can go (branch either when you go out of bounds or value at grid doesn't match)
# 3. Go in opposite direction and repeat, maintaining distance from before (same line, different direction, i.e. left and right)
# 4. Branch to next step
checkWinCondition:
	lb $s0, player # $s0 = player
	addi $s0, $s0, 1 # Add 1 to make it easier for grid value comparisons
	lb $s1, target # $s1 = row (0-5), $t1 is active version
	lb $s2, target+1 # $s2 = column (0-6), $t2 is active version
	add $s7, $ra, $zero # $s7 = original return address
	# $t3 = distance of current direction (horizontal/vertical/slash/backslash), starts at 1 to include current dot
	# $t0 = used for both temporary index into grid and the value from grid
	# $a0 = row increment (first)
	# $a1 = column increment (first)
	# $a2 = row increment (second)
	# $a3 = column increment (second)
	
	# Horizontal
	li $a0, 0
	li $a1, -1
	li $a2, 0
	li $a3, 1
	jal wcInitFirst
	
	# Vertical
	# Note: Since you're always adding from the top, you don't need to check upwards (since it'll always be either unfilled or out of bounds), so only one check is needed.
	li $t3, 1 # reset distance
	add $t1, $s1, $zero # reset row tracker
wcLoopDown:
	addi $t1, $t1, 1 # increment row
	bgt $t1, 5, wcEndDown # check out of bounds (down)
	#---------------
	mul $t0, $t1, 7 # index = row * 7
	add $t0, $t0, $s2 # index += column
	lb $t0, grid($t0)
	bne $t0, $s0, wcEndDown # check if streak ends
	#---------------
	addi $t3, $t3, 1 # add 1 to distance if both checks pass
	beq $t3, 4, winConditionTrue # then if the total distance for this direction is 4, exit early since you know it's a win condition
	j wcLoopDown
wcEndDown:
	
	# Forward Slash (SW --> NE)
	li $a0, 1
	li $a1, -1
	li $a2, -1
	li $a3, 1
	jal wcInitFirst
	
	# Backslash (NW --> SE)
	li $a0, -1
	li $a1, -1
	li $a2, 1
	li $a3, 1
	add $ra, $s7, $zero # Restore original return address before final call to wcInitFirst
	
# This code is mostly identical for each direction, only the numbers added to row/column differ.
# This generalized version is slightly less efficient than a copy-pasted version because certain instructions could be omitted when copy-pasted.
wcInitFirst:
	li $t3, 1 # reset distance
	add $t1, $s1, $zero # reset row tracker
	add $t2, $s2, $zero # reset column tracker
wcLoopFirst:
	add $t1, $t1, $a0 # increment row
	add $t2, $t2, $a1 # increment column
	blt $t1, 0, wcInitSecond # check out of bounds (up)
	bgt $t1, 5, wcInitSecond # check out of bounds (down)
	blt $t2, 0, wcInitSecond # check out of bounds (left)
	bgt $t2, 6, wcInitSecond # check out of bounds (right)
	#---------------
	mul $t0, $t1, 7 # index = row * 7
	add $t0, $t0, $t2 # index += column
	lb $t0, grid($t0)
	bne $t0, $s0, wcInitSecond # check if streak ends
	#---------------
	addi $t3, $t3, 1 # add 1 to distance if both checks pass
	beq $t3, 4, winConditionTrue # then if the total distance for this direction is 4, exit early since you know it's a win condition
	j wcLoopFirst
wcInitSecond:
	add $t1, $s1, $zero # reset row tracker
	add $t2, $s2, $zero # reset column tracker
wcLoopSecond:
	add $t1, $t1, $a2 # increment row
	add $t2, $t2, $a3 # increment column
	blt $t1, 0, wcEnd # check out of bounds (up)
	bgt $t1, 5, wcEnd # check out of bounds (down)
	blt $t2, 0, wcEnd # check out of bounds (left)
	bgt $t2, 6, wcEnd # check out of bounds (right)
	#---------------
	mul $t0, $t1, 7 # index = row * 7
	add $t0, $t0, $t2 # index += column
	lb $t0, grid($t0)
	bne $t0, $s0, wcEnd # check if streak ends
	#---------------
	addi $t3, $t3, 1 # add 1 to distance if both checks pass
	beq $t3, 4, winConditionTrue # then if the total distance for this direction is 4, exit early since you know it's a win condition
	j wcLoopSecond
wcEnd:
	jr $ra
	
# If there's a win condition, print who won (current player after playing their move), then branch to exit, otherwise return to event loop
winConditionTrue:
	li $v0, 4 # Syscall #4: Print String
	beq $t0, 1, winConditionTrueForRed
	beq $t0, 2, winConditionTrueForYellow
winConditionTrueForRed:
	la $a0, winnerRed
	j winConditionTrueContinue
winConditionTrueForYellow:
	la $a0, winnerYellow
	j winConditionTrueContinue
winConditionTrueContinue:
	syscall
	j exit