# Connect4
CS 2340.004 Connect 4 Team Project

## Members
- Ilse [Redacted]
- Robin [Redacted]
- William [Redacted]
- Shaan [Redacted]

# Details

## Components of Connect 4
- 7x6 board
- Board fills bottom-to-top
- Red goes first
- Win Condition: 4 blocks horizontally, vertically, or diagonally

## Implementation

### Data
- `grid`: A 1D array that mimics a 2D array for the board
	- 42 blocks, 1 byte each
	- `0` for unfilled
    - `1` for red
    - `2` for yellow
- `player`: The current player
	- Byte
	- `0` for red
	- `1` for yellow
- `target`: A pair of bytes (row, column) holding the location of where the last dot was placed

### Functions
- `void main()`: Handles input/output stuff then calls the core logic modules, I/O should be separated for maintainability
	- `displayBoard()` (initial display only at beginning)
	- Event Loop
		1. `inputColumn()` (switch to dynamic keyboard input if needed) or `autoinputColumn()`
		2. `displayBoard()` (switch to bitmap display if needed)
		3. `checkWinCondition()`
		4. `switchPlayer()`
- `void displayBoard()`: Display the current ASCII board
- `void inputColumn()`: Get the column number (1-7) from the user, continue asking for input until valid input is entered. Then attempt to add the player's input to the grid, validate that the target column isn't full.
- `void autoinputColumn()`: Player yellow will be controlled by the computer, which is just a random number generator in its basic form (use syscall 42).
- `void checkWinCondition()`: If true, say who won then jump to exit subroutine
	- Check if the overall distance in any of the 4 directions is 4 or greater.
	- For example, if there's one X to the left and two X's to the right, the horizontal distance is 4, which is a win condition. If there were three X's to the right, the search would automatically stop after reading two X's to the right for efficiency (since a win condition already exists).
	- Repeat this for horizontal, vertical, forward slash, and backslash directions.
- `void switchPlayer()`
- `void exit()`: Jump/branch to here to exit the program

## Grid Details
- Top-to-bottom grid where every 7 entries is a row, therefore you use a mix of integer division and modulo to determine the row and column
- `displayBoard()`: Iterates through the grid from 0 to 41 and displays the grid.
- `inputColumn()`: Has a fixed column (the number the user entered) and the row goes 5, 4, 3, 2, 1, 0. Basically checks if the column is full, and if not, places a dot in that column.
- `checkWinCondition()`: Target index is given, check neighboring positions:
	- Row = index / 7
	- Column = index % 7
	- Validate Row => row is between 0 and 5 (inclusive)
	- Validate Column => column is between 0 and 6 (inclusive)
	- Index = 7 * row + column

## Example Output
*Note: The grid isn't as specified in the project description but the concept remains.*

```
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Red Player (X), pick a column number (1-7): 0
Please pick a column number between 1 to 7: 3

|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   | X |   |   |   |   |
|---+---+---+---+---+---+---|
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Yellow Player picked the column number: 3

|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   |   |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   | O |   |   |   |   |
|---+---+---+---+---+---+---|
|   |   | X |   |   |   |   |
|---+---+---+---+---+---+---|
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Red Player (X), pick a column number (1-7): ___
```
