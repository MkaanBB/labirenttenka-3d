extends Node3D

var tutorial_open = false

func _ready():
	await get_tree().process_frame
	_show_tutorial()

func _unhandled_input(event):
	if tutorial_open:
		if event is InputEventKey and event.pressed:
			_close_tutorial()

func _show_tutorial():
	tutorial_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	var banner = CanvasLayer.new()
	banner.name = "TutorialBanner"
	banner.layer = 10
	add_child(banner)

	var panel = ColorRect.new()
	panel.color = Color(0, 0, 0, 0.85)
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	banner.add_child(panel)

	var label = Label.new()
	label.name = "TutorialLabel"
	label.text = "KONTROLLER\n\nWASD  ->  Hareket\nFare   ->  Bakis\nE       ->  Isaret Birak\nF       ->  El Feneri Ac/Kapat\nESC   ->  Menu\n\nAMAC\nLabirentte parlayan portal cikisini bul!\n\nDIKKAT: Jumpscare icerir!\n\n[ Devam icin herhangi bir tusa bas ]"
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(1, 1, 1))
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	banner.add_child(label)

func _close_tutorial():
	tutorial_open = false
	var banner = get_node_or_null("TutorialBanner")
	if banner:
		banner.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.start_level(GameManager.current_level)
