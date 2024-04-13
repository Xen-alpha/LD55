extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var initial_spawn_timing = 4.0
var phase_counter = 0

var home_health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = load("res://actor/Player/Sentry.tscn").instance()
	player.position = Vector2(320, 400)
	get_node("GunHolder").add_child(player)
	get_node("EnemySpawnTimer").start(initial_spawn_timing)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_EnemySpawnTimer_timeout():
	var duck = null
	rand_seed(Time.get_ticks_usec())
	var rand_type = randi() % 2
	match rand_type:
		0:
			duck = load("res://actor/Enemy/Duck_Walking.tscn").instance()
		_:
			duck = load("res://actor/Enemy/Duck_Flying.tscn").instance()
	rand_seed(Time.get_ticks_usec())
	var rand_int = randi() % 4
	match rand_int:
		0:
			duck.position.x = 0
			duck.position.y = rand_range(0, 640)
		1:
			duck.position.x = 640
			duck.position.y = rand_range(0, 640)
			var sprite = duck.get_node_or_null("AnimatedSprite") as AnimatedSprite
			if sprite != null:
				sprite.flip_h = true
		2:
			duck.position.x = rand_range(0, 640)
			duck.position.y = -64
			var sprite = duck.get_node_or_null("AnimatedSprite") as AnimatedSprite
			if sprite != null and duck.position.x >= 320:
				sprite.flip_h = true
		_:
			duck.position.x = rand_range(0, 640)
			duck.position.y = 640
			var sprite = duck.get_node_or_null("AnimatedSprite") as AnimatedSprite
			if sprite != null and duck.position.x >= 320:
				sprite.flip_h = true
	get_node("EnemyPoint").add_child(duck)
	if (phase_counter >= 12000):
		get_node("EnemySpawnTimer").start(0.1)
	else:
		get_node("EnemySpawnTimer").start(initial_spawn_timing - 0.001 * floor(phase_counter / 3))
		phase_counter += 1


func _on_Platform_area_entered(area:Area2D):
	if area.name == "EnemyCollision":
		home_health -= 1
		if home_health <= 0:
			self.queue_free()
		area.queue_free()


func _on_BulletSpawnTimer_timeout():
	pass # Replace with function body.
