# Switch the current player
switchPlayer:
	lb $t0, player
	beq $t0, 0, switchPlayerToYellow # If current player is red, switch to yellow
	beq $t0, 1, switchPlayerToRed # If current player is yellow, switch to red
switchPlayerToYellow:
	li $t0, 1
	sb $t0, player
	jr $ra
switchPlayerToRed:
	li $t0, 0
	sb $t0, player
	jr $ra