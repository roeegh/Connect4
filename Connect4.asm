#-----------------------------------------------------------
# Program File: Connect4.asm
# Written by:   Robin Singh, Ilse Lahnstein, William Imaican, Shaan Nair
# Date Created: 03/17/2022
# Description:  Connect 4 Team Project for CS 2340.004
#-----------------------------------------------------------

#-----------------------
# Declare some constants / variables
#-----------------------

	.data
# Variables
player: .byte 0 # The current player, 0 = red, 1 = yellow, the game starts with player red
target: .space 2 # A pair of bytes (row, column) holding the location of where the last dot was placed
grid: .space 42 # A 1D array representing a 2D grid, reserves memory for the next 42 bytes for a 7x6 grid, 0 = unfilled, 1 = red, 2 = yellow
# Strings
boardEmptyColumn: .asciiz "| _ "
boardRedColumn: .asciiz "| X "
boardYellowColumn: .asciiz "| 0 "
boardEndOfRow: .asciiz "|\n"
input: .asciiz "Red Player (X), pick a column number (1-7): "
autoinput: .asciiz "Yellow Player (0) chose column "
autoinputEnd: .asciiz "!\n"
inputErrorRange: .asciiz "Please pick a column number between 1 to 7: "
inputErrorFull: .asciiz "The column you selected is full, pick another column: "
winnerRed: .asciiz "Red player wins!"
winnerYellow: .asciiz "Yellow player wins!"
stalemate: .asciiz "This match is a stalemate."

#------------------
# Main program body
#------------------

	.text
# The main event loop, calls different parts of the code
main:
	jal displayBoard # Display the initial board only at the beginning
mainLoop:
	# Start by choosing manual/automatic input for the player/computer respectively.
	la $ra, mainLoopContinue # Set the return address for either case
	lb $t0, player
	beq $t0, 0, inputColumn # Red player is controlled by the user
	beq $t0, 1, autoinputColumn # Yellow player is controlled by the computer
mainLoopContinue:
	jal displayBoard # Subsequent board displays will show the updated version after user input for that round
	jal checkWinCondition # If there's a win condition, print that after displaying the board (then exit the program)
	jal fullBoard # If there is no win condition and the board has become full, declare a draw and exit the program
	jal switchPlayer
	j mainLoop
# Graceful exit for the program
exit:
	li $v0, 10 # Syscall #10: Exit Program
	syscall

# Paste different modules under the text (code) directive
.include "input-player.asm"
.include "input-computer.asm"
.include "input-utils.asm"
.include "display.asm"
.include "win-condition.asm"
.include "full.asm"
.include "switch-player.asm"
