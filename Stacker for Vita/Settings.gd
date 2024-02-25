extends Node2D
# Use to edit the Autoload variables so you can have some game features editables


var cols
var blocks
var refreshTime

func _ready():
	cols = get_node("/root/Autoload").cols
	
	blocks = get_node("/root/Autoload").blocks
	refreshTime = get_node("/root/Autoload").refreshTime

func _on_BlocksUP_pressed():
	blocks += 1
	get_node("/root/Autoload").blocks = blocks
	get_node("RectangleMenu/Blocks").text = "BLOCKS\n" + str(blocks)


func _on_StartGame_pressed():
	get_tree().change_scene("res://Game.tscn")
