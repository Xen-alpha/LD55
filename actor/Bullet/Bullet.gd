class_name Bullet_Game
extends Area2D

signal hit(id, dmg)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enabled = false
var captured = false

var direction = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func LaunchBullet(parm1:Vector2):
	direction = parm1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_queued_for_deletion():
		return
	if enabled == false:
		return
	position += direction * delta * 1280


func _on_Bullet_area_entered(area):
	if enabled:
		if area is Duck_Base:
			emit_signal("hit", area.get_instance_id(), 1)
			queue_free()
