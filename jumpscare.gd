extends Control

@onready var video = $VideoStreamPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	video.stream = load("res://jumpscare/jumpscare.ogv")
	video.expand = true
	video.anchors_preset = Control.PRESET_FULL_RECT
	video.play()
	video.finished.connect(_on_video_finished)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_close()

func _on_video_finished():
	_close()

func _close():
	video.stop()
	GameManager.jumpscare_done()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
