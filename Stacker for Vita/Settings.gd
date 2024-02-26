extends Node2D
# Use to edit the Autoload variables so you can have some game features editables


var cols
var blocks
var refreshTime


func _ready():
	get_node("OcupiedSpace/Image2").set_visible(true)
	cols = get_node("/root/Autoload").cols
	blocks = get_node("/root/Autoload").blocks
	refreshTime = get_node("/root/Autoload").refreshTime


func _on_BlocksUP_pressed():
	if blocks < (cols - 1):
		blocks += 1
		get_node("/root/Autoload").blocks = blocks
		get_node("RectangleBlocks/Blocks").text = "FULL BLOCKS\n" + str(blocks)


func _on_BlocksDOWN_pressed():
	if blocks > 1:
		blocks -= 1
		get_node("/root/Autoload").blocks = blocks
		get_node("RectangleBlocks/Blocks").text = "FULL BLOCKS\n" + str(blocks)


func _on_ColsUP_pressed():
	if cols < 7:
		cols += 1
		get_node("/root/Autoload").cols = cols
		get_node("RectangleCols/Cols").text = "COLUMNS\n" + str(cols)


func _on_ColsDOWN_pressed():
	if cols > 2:
		cols -= 1
		get_node("/root/Autoload").cols = cols
		get_node("RectangleCols/Cols").text = "COLUMNS\n" + str(cols)
# Fix block limits after cols edits, for limit cases
	if blocks >= cols:
		blocks = cols -1
		get_node("/root/Autoload").blocks = blocks
		get_node("RectangleBlocks/Blocks").text = "FULL BLOCKS\n" + str(blocks)


func _on_RefreshUP_pressed():
	if refreshTime < 600000:
		refreshTime += 1
		get_node("/root/Autoload").refreshTime = refreshTime
		get_node("RectangleRefresh/Refresh").text = "SPEED\n" + str(refreshTime)


func _on_RefreshDOWN_pressed():
	if refreshTime > 300000:
		refreshTime -= 1
		get_node("/root/Autoload").refreshTime = refreshTime
		get_node("RectangleRefresh/Refresh").text = "SPEED\n" + str(refreshTime)


func _on_StartGame_pressed():
	get_tree().change_scene("res://Game.tscn")
