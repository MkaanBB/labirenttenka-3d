extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var ok_btn = $VBoxContainer/OkButton

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ok_btn.pressed.connect(_on_ok)
	name_input.grab_focus()

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			_on_ok()

func _on_ok():
	var name = name_input.text.strip_edges()
	if name == "":
		name = "Anonim"
	GameSettings.player_name = name
	GameSettings.save()
	queue_free()
	get_tree().change_scene_to_file("res://menu.tscn")
