extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 16.0
var offset = 0

var health = 1

var startpoint

var endpoint = Vector2(320,320)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initStat(pos:Vector2, healthpoint):
	position = pos
	health = healthpoint

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_queued_for_deletion():
		return
	position = position.move_toward(endpoint, delta* speed)



func _on_EnemyCollision_area_entered(area):
	pass # Replace with function body.
