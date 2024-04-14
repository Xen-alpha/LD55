class_name Duck_Base
extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 16.0
var health = 1

var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	id = get_instance_id()

func initStat(pos:Vector2, healthpoint:int, speed_init:int):
	position = pos
	health = healthpoint
	speed = speed_init

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
