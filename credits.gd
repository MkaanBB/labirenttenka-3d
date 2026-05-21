extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Button.pressed.connect(_on_back)

func _on_back():
	get_tree().change_scene_to_file("res://menu.tscn")
