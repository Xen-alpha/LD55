extends Area2D
class_name Player_Sentry

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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var key_pressed = false
	# Post-LD Fix: process input here
	if Input.is_action_pressed("ui_up") and (position.y > 0) and acceleration.y > - 100: 
		if speed.y > 0:
			acceleration.y -= 20
		else: 
			acceleration.y -= 10
		key_pressed = true
	if Input.is_action_pressed("ui_down") and (position.y < 640) and acceleration.y < 100:
		if speed.y < 0:
			acceleration.y += 20
		else: 
			acceleration.y += 10
		key_pressed = true
	if Input.is_action_pressed("ui_left") and (position.x > 0) and acceleration.x > - 100:
		if speed.x > 0:
			acceleration.x -= 20
		else: 
			acceleration.x -= 10
		key_pressed = true
	if Input.is_action_pressed("ui_right") and (position.x < 640) and acceleration.x < 100: 
		if speed.x < 0:
			acceleration.x += 20
		else: 
			acceleration.x += 10
		key_pressed = true
	if key_pressed == false:
		acceleration = Vector2(0,0)
	var diff = Vector2(0,0)
	if Input.is_joy_known(0) and (Input.is_action_pressed("joy_left") or Input.is_action_pressed("joy_right") or Input.is_action_pressed("joy_up") or Input.is_action_pressed("joy_down")):
		var axis_x = 0
		axis_x = Input.get_joy_axis(0,JOY_AXIS_2)
		var axis_y = 0
		axis_y = Input.get_joy_axis(0,JOY_AXIS_3)
		diff = Vector2(axis_x, axis_y)
	else:
		# mouse_pos check
		var mouse_pos = get_global_mouse_position()
		diff = mouse_pos - position
	gun_vector = diff.normalized()
	get_node("Sprite/Gun").rotation = gun_vector.angle() + PI / 2
	# acceleration
	speed += acceleration * delta
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
