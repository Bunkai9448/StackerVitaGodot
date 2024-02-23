extends Node2D


var rows = 5 
var cols = 2

var gameWindow = [] # To control the blocks logic 
var line = 0 # number of lines stacked successfully in current run
var blocks = 1 # number of currently moving blocks
var nClean = 3 # max number of lines in screen, avoid getting out of display boundaries
var refreshTime = 6000000 # Time for the refresh (hacky method I had to come up with)

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
	for i in refreshTime: pass # This is a hacky way to control the refreshing times, so it can be played by a human
	
	if Input.is_action_just_pressed("Red_Button"):
		if line != 0: # The first line always stacks
			# Compare previous and current row to see what blocks that stack and update accordingly
			var lineStart = line * cols
			var prevLineStart = (line - 1) * cols
			for i in range(cols - 1): # Compare the elements of both rows one by one
				var elem1 = gameWindow.pop_at(prevLineStart + i) # grab and save the elem to compare
				gameWindow.insert(prevLineStart + i, elem1) # but don't modify the array
				var elem2 = gameWindow.pop_at(lineStart + i) # grab and save the elem to compare

				# COMPARE FIRST ELEMENT OF THE PAIR, THE 2 ONE ARE ALWAYS DIFFERENT IMAGE INSTANCES
				if elem1[1] != elem2[1]: # always empty if they are different
					if elem1[1] == 1: # If it was a block falling,
						blocks = blocks - 1 # update the counter
					# Insert the empty block in the row
					gameWindow.insert(lineStart + i, elem1)
				if elem1[1] == elem2[1]: # elem was either empty or stack, so reinsert in same place
					gameWindow.insert(lineStart + i, elem2)
				
			# Check Game Over case
			if blocks == 0: # There are no ocupied blocks in the row
				pass # TO-DO
				
			# Create the new line so the game can continue
		line = line + 1
		newRow(blocks)
			
		# Avoid overflowing the screen and save resources
		# Delete first row of the array when there are too many lines on screen
		if line > nClean:
			line = line - 1 
			for i in range(cols):
				gameWindow.pop_front() 
				# TO-DO free the images instanced of that row
				# TO-DO move displayed blocks one row down
				
		
		
		
	# Shift current line of blocks moving
	shiftRow(line)
	# Display current stack
	get_node("Score").text = str(gameWindow)


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
	var rowStart = row * cols

	var elem1 = 0 # current elem in check
	var elem2 = 0 # To avoid error (wrong element checked) with insertions
	for i in (cols - 1):
		# Uptdate the array
		elem1 = gameWindow.pop_at(rowStart + i) # current elem out
		instance_from_id(elem1[1]).position = Vector2(line * bCoordinates.x, i * bCoordinates.y)
		elem2 = gameWindow.pop_at(rowStart + i) # after the first pop the same "i" is the next elem

		gameWindow.insert(rowStart + i, elem1)
		if (rowStart + i) <= (rowStart + cols -1): # If we haven't reached the end of the row
			gameWindow.insert(rowStart + i, elem2) # Since 2 elem were poped we need to reinsert 2
			instance_from_id(elem2[1]).position = Vector2(line * bCoordinates.x, (i + 1) * bCoordinates.y)


# To restart the game
func _on_NewGame_pressed():
	Autoload.goto_scene("res://Game.tscn")
	
