extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
	position += direction


func _on_Bullet_area_entered(area):
	if area.name == "EnemyCollsion":
		area.health -= 1
		if area.health <= 0:
			area.queue_free()
		queue_free()
