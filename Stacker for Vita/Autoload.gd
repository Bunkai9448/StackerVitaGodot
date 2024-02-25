extends Node


var current_scene = null

# Global variables, to make them editable via settings
var cols = 7
var blocks = 3 # number of currently moving blocks
# Time for the shift refresh (hacky method I had to come up with), I know it eats resources
var refreshTime = 300000 # use refreshTime = 300000 for the vita


# Code to Reload Screen for New Game
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() -1 )

#	
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

#	
func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	

