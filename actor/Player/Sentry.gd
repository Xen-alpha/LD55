extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gun_vector = Vector2(0,0)

var acceleration = Vector2(0,0)
var speed = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		var event_key = event as InputEventKey
		if event_key.pressed:
			var key = OS.get_scancode_string(event_key.scancode)
			if key == "W" and (position.y > 0) and acceleration.y > -0.5: 
				acceleration.y -= 0.1
			if key == "S" and (position.y < 640) and acceleration.y < 0.5: 
				acceleration.y += 0.1
			if key == "A" and (position.x > 0) and acceleration.x > -0.5:
				acceleration.x -= 0.1
			if key == "D" and (position.x < 640) and acceleration.x < 0.5: 
				acceleration.x += 0.1
		else:
			acceleration = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var diff = mouse_pos - position
	gun_vector = diff.normalized()
	get_node("Sprite/Gun").rotation = gun_vector.angle() + PI / 2
	# acceleration
	speed += acceleration
	position += speed * delta
	if (position.y <= 0):
		position.y = 1
		speed.y *= -1
		acceleration.y = 0
	if (position.y >= 640):
		position.y = 640 - 1
		speed.y *= -1
		acceleration.y = 0
	if (position.x <= 0):
		position.x = 1
		speed.x *= -1
		acceleration.x = 0
	if (position.x >= 640 ):
		position.x = 640 - 1
		speed.x *= -1
		acceleration.x = 0
	
