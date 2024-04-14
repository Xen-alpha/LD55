extends CanvasLayer
class_name MainUI

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "HTML5":
		get_node("Panel/ExitButton").hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
	var level = load("res://map/Stage1.tscn").instance()
	get_parent().add_child(level)
	hide()


func _on_ExitButton_button_up():
	get_tree().quit()
	# pass # Replace with function body.

var bgm_on = true

func _on_BGMButton_button_up():
	if bgm_on:
		# turn off
		var bgm = get_parent().get_node_or_null("BGM") as AudioStreamPlayer2D
		if bgm != null:
			bgm.stop()
		bgm_on = false
		get_node("Panel/BGM/Button").text = "Off"
	else:
		# turn on
		var bgm = get_parent().get_node_or_null("BGM") as AudioStreamPlayer2D
		if bgm != null:
			bgm.play()
		bgm_on = true
		get_node("Panel/BGM/Button").text = "On"
