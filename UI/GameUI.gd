class_name GameUI
extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Control/Label_Score").text = "Score: %d" % get_parent().score
	get_node("Control/Label_Health").text = "Health: %d" % get_parent().home_health 

func set_score(val:int):
	get_parent().score = val
	get_node("Control/Label_Score").text = "Score: %d" % get_parent().score

func set_health(val:int):
	get_parent().home_health = val
	get_node("Control/Label_Health").text = "Health: %d" % get_parent().home_health 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
