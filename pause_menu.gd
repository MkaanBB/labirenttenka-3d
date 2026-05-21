extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$VBoxContainer/Button.pressed.connect(_on_continue)
	$VBoxContainer/Button2.pressed.connect(_on_menu)

func _on_continue():
	queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.start_level(GameManager.current_level)

func _on_menu():
	queue_free()
	GameManager.current_level = 1
	get_tree().change_scene_to_file("res://menu.tscn")
