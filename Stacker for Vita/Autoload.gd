extends Node


var current_scene = null

# Global variables, to make them editable via settings
var cols = 7
var blocks = 3 # number of currently moving blocks
# Time for the shift refresh (hacky method I had to come up with), I know it eats resources
var refreshTime = 300000 # use refreshTime = 300000 for the vita

