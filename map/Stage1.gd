extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var initial_spawn_timing = 4.0
var phase_counter = 0

var score = 0
var home_health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var game_ui = load("res://UI/GameUI.tscn").instance()
	add_child(game_ui)
	phase_counter = 0
	var player = load("res://actor/Player/Sentry.tscn").instance()
	player.position = Vector2(320, 400)
	add_child(player)
	get_node("EnemySpawnTimer").start(initial_spawn_timing)
	get_node("BulletSpawnTimer").start(0.1)

func _input(event):
	if event is InputEventMouseButton:
		var event_btn = event as InputEventMouseButton
		var player = get_node_or_null("Player") as Player_Sentry
		if player == null:
			return
		if event_btn.button_index == 2: # right
			var bullet_list = player.get_overlapping_areas()
			for elem in bullet_list:
				if elem is Bullet_Game and elem.captured == false:
					var elem_bullet = elem as Bullet_Game
					get_node("GunHolder").remove_child(elem)
					player.get_node("BulletHolder").add_child(elem)
					elem.position = elem_bullet.position - player.position
					elem.captured = true
		if event_btn.button_index == 1: # left
			var bullet_list = player.get_node("BulletHolder").get_children()
			for bullet in bullet_list:
				var bullet_elem = bullet as Bullet_Game
				var mouse_pos = get_global_mouse_position()
				var diff = mouse_pos - player.position
				bullet_elem.direction = diff.normalized()
				bullet_elem.enabled = true
				bullet_elem.position = player.position
				player.get_node("BulletHolder").remove_child(bullet)
				add_child(bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_EnemySpawnTimer_timeout():
	var duck = null
	randomize()
	var rand_type = randi() % 2
	match rand_type:
		0:
			duck = load("res://actor/Enemy/Duck_Walking.tscn").instance()
		_:
			duck = load("res://actor/Enemy/Duck_Flying.tscn").instance()
	randomize()
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
	# set randomized stat to duck
	var base_stat = floor(phase_counter / 100)
	randomize()
	var health_random = base_stat + randi() % 2
	randomize()
	var speed_random = 16 + base_stat* 4 + randi() %4
	duck.initStat(duck.position, health_random, speed_random)
	if (phase_counter >= 1200):
		get_node("EnemySpawnTimer").start(0.05)
	else:
		get_node("EnemySpawnTimer").start(initial_spawn_timing - 0.01 * floor(phase_counter / 3))
		phase_counter += 1

var screen_state = 0

func _on_Platform_area_entered(area:Area2D):
	var game_ui = get_node_or_null("GameUI") as GameUI
	if game_ui == null:
		return
	if area is WalkingDuck or area is FlyingDuck:
		screen_state = 10
		get_node("ScreenShakeTimer").start(0.02)
		game_ui.set_health(home_health - 1)
		area.set_process(false)
		if home_health <= 0:
			# End Game
			var main_ui = get_parent().get_node_or_null("MainUI") as MainUI
			if main_ui != null:
				main_ui.get_node("Panel/Label").text = "Score: %d" % score
				main_ui.show()
				var sound = load("res://media/sound/Damaged.tscn").instance()
				main_ui.add_child(sound)
			self.queue_free()
		else:
			var sound = load("res://media/sound/Damaged.tscn").instance()
			add_child(sound)
		area.queue_free()


func _on_BulletSpawnTimer_timeout():
	var GunHolder = get_node("GunHolder").get_children()
	if GunHolder.size() >= 5 + floor(phase_counter/ 1000):
		get_node("BulletSpawnTimer").start(0.5) # just restart timer
		return
	var notvalidpos = true
	var x = 0
	var y = 0
	while notvalidpos:
		notvalidpos = false
		randomize()
		x = rand_range(4, 636)
		randomize()
		y = rand_range(4, 636)
		if (x >= 288 and x <= 352 and y >= 288 and y <= 352):
			notvalidpos = true
	var bullet = load("res://actor/Bullet/Bullet.tscn").instance() as Bullet_Game
	bullet.enabled = false
	bullet.connect("hit", self, "_on_EnemyPoint_hit")
	var bullet_pos = Vector2(x,y)
	bullet.position = bullet_pos
	get_node("GunHolder").add_child(bullet)
	if (phase_counter >= 1200):
		get_node("BulletSpawnTimer").start(0.1)
	else:
		get_node("BulletSpawnTimer").start(0.5 - phase_counter / 3000)


func _on_EnemyPoint_hit(id, dmg):
	var enemy_list = get_node("EnemyPoint").get_children()
	var game_ui = get_node_or_null("GameUI") as GameUI
	for enemy in enemy_list:
		var duck = enemy as Duck_Base
		if duck.id == id:
			duck.health -= dmg
			if duck.health <= 0:
				# Quack message
				var message = load("res://actor/Message/Quack.tscn").instance()
				message.position = duck.position
				add_child(message)
				# hit sound
				var sound = load("res://media/sound/Hit.tscn").instance()
				add_child(sound)
				# eliminate duck
				get_node("EnemyPoint").remove_child(enemy)
				duck.queue_free()
				if game_ui != null:
					game_ui.set_score(score + 10)
			else:
				# Damaged message
				var message = load("res://actor/Message/NotDead.tscn").instance()
				message.position = duck.position
				add_child(message)



func _on_WorldCollision_area_exited(area):
	if area is Bullet_Game and area.get_parent() == self:
		var bullet = area as Bullet_Game
		if bullet.enabled:
			print("Bullet out!")
			area.queue_free()



func _on_ScreenShakeTimer_timeout():
	if screen_state <= 0:
		position = Vector2(0,0)
		get_node("ScreenShakeTimer").stop()
	else:
		randomize()
		var x = rand_range(-1, 1)
		position.x = x
		randomize()
		var y = rand_range(-1, 1)
		position.y = y
		screen_state -= 1
