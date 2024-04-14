extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var level = load("res://UI/MainUI.tscn").instance()
	add_child(level)
	var bgm = load("res://media/sound/BGM.tscn").instance()
	add_child(bgm)
	# pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
