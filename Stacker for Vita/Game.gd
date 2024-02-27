extends Node2D


var cols # global var from Autoload
var blocks # global var from Autoload
var refreshTime # global var from Autoload
var race = false

var gameOver = false
var gameWindow = [] # To control the blocks logic 
var line = 0 # number of lines stacked successfully in current run, reset every few times for ram/screen efficency
var score = 0 # it's the number of lines completed
var nClean = 9 # max number of lines in screen, avoid getting out of display boundaries

var  emptySquares = preload("res://EmptySpace.tscn") # Image to display in screen
var  ocupiedSquares = preload("res://OcupiedSpace.tscn") # Image to display in screen
var bCoordinates = Vector2(64,64) # Base coordinates (plus size) in screen for easily displaying blocks

onready var background = preload("res://Assets/BGM.wav")
onready var falling = preload("res://Assets/Fall.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	soundON()
	cols = get_node("/root/Autoload").cols
	
	blocks = get_node("/root/Autoload").blocks
	refreshTime = get_node("/root/Autoload").refreshTime
	# Create and Initialize first row (uses an array to manage)
	# if the position has a 0, there's no block in it
	# if the position has a 1, there's a block in it
	newRow(blocks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !gameOver:
		# Add sound if it's not already playing
		soundON()
		# Shift current line of blocks moving
	if race == false:
		shiftRow(line)


# The button has to be asyncronous, so the refresh can be modified for a person to be able to follow the blocks
# https://docs.godotengine.org/en/3.5/classes/class_%40globalscope.html#enum-globalscope-joysticklist
# Separated function so it can be called from keyInput and from buttonNode
func pressToStack():
	race = true
	if line != 0: # The first line always stacks
		# Compare previous and current row to see what blocks that stack and update accordingly
		var lineStart = line * cols
		var prevLineStart = (line - 1) * cols
		for i in (cols): # Compare the elements of both rows one by one
			var elem1 = gameWindow.pop_at(prevLineStart + i) # grab and save the elem to compare
			gameWindow.insert(prevLineStart + i, elem1) # but don't modify the array
			var elem2 = gameWindow.pop_at(lineStart + i) # grab and save the elem to compare
			# COMPARE FIRST ELEMENT OF THE PAIR, THE 2 ONE ARE ALWAYS DIFFERENT IMAGE INSTANCES
			if elem1[0] == elem2[0]: # elem was either empty or stack, so reinsert in same place
				gameWindow.insert(lineStart + i, elem2)
			if elem1[0] != elem2[0]: # always empty if they are different
				if elem2[0] == 1: # If it was a block falling,
					soundOFF()
					if !$Sounds/BGM.is_playing():
						$Sounds/BGM.stream = falling
						$Sounds/BGM.play()
					blocks = blocks - 1 # update the counter
					elem2[0] = 0
					instance_from_id(elem2[1]).get_node("Image").set_visible(false)
					instance_from_id(elem2[1]).get_node("Image2").set_visible(true)
				# Insert the empty block in the row
				gameWindow.insert(lineStart + i, elem2)
		# Check Game Over case
		if blocks == 0: # There are no ocupied blocks in the row
			gameOver = true
			soundOFF()
	
	# Avoid overflowing the screen and save resources
	# Delete first row of the array when there are too many lines on screen
	if line >= nClean:
		lastRow()
	
	# Create the new line so the game can continue
	line = line + 1
	newRow(blocks)
	
	# Update current Score
	score = score + 1
	if gameOver:
		get_node("ReplayMenu/ScoreBoard/Score").text = "SCORE:\n" + str(score) + "\nFAME OVER" 
	else:
		get_node("ReplayMenu/ScoreBoard/Score").text = "SCORE:\n" + str(score)
		
	race = false


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
			newOcupy.position = Vector2((900-bCoordinates.x) - (line * bCoordinates.x), i * bCoordinates.y + 48)
			newOcupy.set_visible(true)
			gameWindow.push_back([1,newOcupy.get_instance_id()])
		else: # fill the rest of the row with empty spaces
			var newEmpty = emptySquares.instance()
			add_child(newEmpty)
			newEmpty.position = Vector2((900-bCoordinates.x) - (line * bCoordinates.x), i * bCoordinates.y + 48)
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
			instance_from_id(elem1[1]).position = Vector2((900-bCoordinates.x) - (line * bCoordinates.x), (i + 1) * bCoordinates.y + 48)
			gameWindow.insert(rowStart + i + 1, elem1)
			elem1 = elem2
		else: # if this was the last element of the row
			elem2 = gameWindow.pop_at(rowStart) # first element of the row is the next elem
			instance_from_id(elem1[1]).position = Vector2((900-bCoordinates.x) - (line * bCoordinates.x), 0 * bCoordinates.y + 48)
			gameWindow.insert(rowStart, elem1)
			elem1 = elem2


# Redraw last row in the previous line to avoid losing current display on screen maximum lines situation
func lastRow():
	var temp = []
	for i in cols: # save last stacked row and delete it from the array
		temp.push_front( gameWindow.pop_back())
	for i in cols: # clean previous row
		gameWindow.pop_back()
	line -= 1
	for i in cols: # insert saved row and draw in proper line
		var elem = temp.pop_front()
		instance_from_id(elem[1]).position = Vector2((900-bCoordinates.x) - ((line)* bCoordinates.x), (i) * bCoordinates.y + 48)
		gameWindow.push_back( elem )


func soundON():
	if !$Sounds/BGM.is_playing():
		$Sounds/BGM.stream = background
		$Sounds/BGM.play()

func soundOFF():
	if $Sounds/BGM.is_playing():
		$Sounds/BGM.stop()


# Go back to Settings menu
func _on_Settings_pressed():
	get_tree().change_scene("res://Settings.tscn")

# Restart the game
func _on_NewGame_pressed():
	get_tree().change_scene("res://Game.tscn")

# Stop button, option A
func _unhandled_input(event):
	if !gameOver:
		if event.is_action_pressed("Red_Button"):
			pressToStack()

# Stop button, option B
#func _on_StopButton_pressed():
#	if !gameOver:
#		pressToStack()

