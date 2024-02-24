extends Node2D


var rows = 5 
var cols = 3

var gameOver = false
var gameWindow = [] # To control the blocks logic 
var line = 0 # number of lines stacked successfully in current run, reset every few times for ram/screen efficency
var score = 0 # it's the number of lines completed
var blocks = 1 # number of currently moving blocks
var nClean = 8 # max number of lines in screen, avoid getting out of display boundaries
var refreshTime = 4000000 # Time for the shift time (hacky method I had to come up with)

var  emptySquares = preload("res://EmptySpace.tscn") # Image to display in screen
var  ocupiedSquares = preload("res://OcupiedSpace.tscn") # Image to display in screen
var bCoordinates = Vector2(64,64) # Base coordinates (plus size) in screen for easily displaying blocks

 
# Called when the node enters the scene tree for the first time.
func _ready():
	# Create and Initialize first row (uses an array to manage)
	# if the position has a 0, there's no block in it
	# if the position has a 1, there's a block in it
	newRow(blocks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !gameOver:
		if Input.is_action_just_pressed("Red_Button"):
			if line != 0: # The first line always stacks
				# Compare previous and current row to see what blocks that stack and update accordingly
				var lineStart = line * cols
				var prevLineStart = (line - 1) * cols
				for i in (cols): # Compare the elements of both rows one by one
					var elem1 = gameWindow.pop_at(prevLineStart + i) # grab and save the elem to compare
					gameWindow.insert(prevLineStart + i, elem1) # but don't modify the array
					var elem2 = gameWindow.pop_at(lineStart + i) # grab and save the elem to compare
					# COMPARE FIRST ELEMENT OF THE PAIR, THE 2 ONE ARE ALWAYS DIFFERENT IMAGE INSTANCES
					if elem1[0] != elem2[0]: # always empty if they are different
						if elem1[0] == 1: # If it was a block falling,
							blocks = blocks - 1 # update the counter
						# Insert the empty block in the row
						gameWindow.insert(lineStart + i, elem1)
					if elem1[0] == elem2[0]: # elem was either empty or stack, so reinsert in same place
						gameWindow.insert(lineStart + i, elem2)
				# Check Game Over case
				if blocks == 0: # There are no ocupied blocks in the row
					gameOver = true
			
			# Create the new line so the game can continue
			line = line + 1
			newRow(blocks)
			# Avoid overflowing the screen and save resources
			# Delete first row of the array when there are too many lines on screen
			if line > nClean:
				line = line - 1 
				for i in range(cols):
					gameWindow.pop_front() 
			
			# Update current Score
			score = score + 1
			if gameOver:
				get_node("Score").text = "SCORE:\n" + str(score) + "\nFAME OVER" 
			else:
				get_node("Score").text = "SCORE:\n" + str(score)
			
		# Shift current line of blocks moving
		shiftRow(line)


# To insert the new line of blocks
func newRow(size):
	var numNewBlocks = size
	# Create and Initialize new row
	for i in (cols):
		if numNewBlocks > 0: # Add an Draw blocks to the row 
			numNewBlocks = numNewBlocks - 1 # Update the num of blocks left to add
			# Draw block on screen, according to raw an column
			var newOcupy = ocupiedSquares.instance()
			add_child(newOcupy)
			newOcupy.position = Vector2(line * bCoordinates.x, i * bCoordinates.y)
			newOcupy.set_visible(true)
			gameWindow.push_back([1,newOcupy.get_instance_id()])
		else: # fill the rest of the row with empty spaces
			var newEmpty = emptySquares.instance()
			add_child(newEmpty)
			newEmpty.position = Vector2(line * bCoordinates.x, i * bCoordinates.y)
			newEmpty.set_visible(true)
			gameWindow.push_back([0,newEmpty.get_instance_id()])


# To Shift the current row (replicates game's movement)
func shiftRow(row):
	for i in refreshTime: pass # This is a hacky way to control the refreshing times, so it can be played by a human
	var rowStart = row * cols
	var elem1 = gameWindow.pop_at(rowStart) # current elem in check
	gameWindow.insert(rowStart, elem1)
	var elem2 = 0 # To avoid error (wrong element checked) with insertions
	for i in (cols):
		# Uptdate the array
		if (rowStart + i) < (rowStart + cols -1): # If we haven't reached the end of the row
			elem2 = gameWindow.pop_at(rowStart + i + 1) # after the first pop the same "i" is the next elem
			instance_from_id(elem1[1]).position = Vector2(line * bCoordinates.x, (i + 1) * bCoordinates.y)
			gameWindow.insert(rowStart + i + 1, elem1)
			elem1 = elem2
		else: # if this was the last element of the row
			elem2 = gameWindow.pop_at(rowStart) # first element of the row is the next elem
			instance_from_id(elem1[1]).position = Vector2(line * bCoordinates.x, 0 * bCoordinates.y)
			gameWindow.insert(rowStart, elem1)
			elem1 = elem2


# To restart the game
func _on_NewGame_pressed():
	Autoload.goto_scene("res://Game.tscn")
