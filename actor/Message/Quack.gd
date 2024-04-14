extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var state = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state >= 80:
		queue_free()
	else:
		position.y -= 1
		state += 1
