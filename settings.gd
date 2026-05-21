extends Control

@onready var volume_slider = $VBoxContainer/VolumeSlider
@onready var sens_slider = $VBoxContainer/SensSlider
@onready var quality_option = $VBoxContainer/QualityOption
@onready var back_btn = $VBoxContainer/BackButton

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	quality_option.add_item("Düşük")
	quality_option.add_item("Orta")
	quality_option.add_item("Yüksek")
	quality_option.selected = 1
	volume_slider.value = GameSettings.volume
	sens_slider.value = GameSettings.sensitivity * 1000
	quality_option.selected = GameSettings.quality
	back_btn.pressed.connect(_on_back)
	volume_slider.value_changed.connect(_on_volume_changed)
	sens_slider.value_changed.connect(_on_sens_changed)
	quality_option.item_selected.connect(_on_quality_changed)

func _on_volume_changed(value):
	GameSettings.volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))

func _on_sens_changed(value):
	GameSettings.sensitivity = value / 1000.0

func _on_quality_changed(index):
	GameSettings.quality = index
	match index:
		0: # Düşük
			RenderingServer.set_default_clear_color(Color.BLACK)
			get_viewport().msaa_3d = Viewport.MSAA_DISABLED
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			Environment
		1: # Orta
			get_viewport().msaa_3d = Viewport.MSAA_2X
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		2: # Yüksek
			get_viewport().msaa_3d = Viewport.MSAA_4X
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA

func _on_back():
	GameSettings.save()
	queue_free()
	get_tree().change_scene_to_file("res://menu.tscn")
