extends Control

@onready var new_game_btn = $VBoxContainer/NewGameButton
@onready var settings_btn = $VBoxContainer/SettingsButton
@onready var credits_btn = $VBoxContainer/CreditsButton
@onready var quit_btn = $VBoxContainer/QuitButton
@onready var seed_input = $VBoxContainer/SeedInput
@onready var mode_btn = $VBoxContainer/ModeButton
@onready var welcome_label = $VBoxContainer/WelcomeLabel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	new_game_btn.pressed.connect(_on_new_game)
	settings_btn.pressed.connect(_on_settings)
	credits_btn.pressed.connect(_on_credits)
	quit_btn.pressed.connect(_on_quit)
	mode_btn.add_item("🔄 Endless")
	mode_btn.add_item("⚡ Sprint")
	mode_btn.add_item("💀 Survival")
	mode_btn.selected = 0

	if GameSettings.player_name == "":
		get_tree().change_scene_to_file("res://name_input.tscn")
	else:
		welcome_label.text = "Hoş geldin, " + GameSettings.player_name + "! 👋"

func _on_new_game():
	if seed_input.text != "":
		seed(seed_input.text.hash())
	match mode_btn.selected:
		0: GameManager.current_mode = GameManager.GameMode.ENDLESS
		1: GameManager.current_mode = GameManager.GameMode.SPRINT
		2: GameManager.current_mode = GameManager.GameMode.SURVIVAL
	GameManager.current_level = 1
	GameManager.total_score = 0
	for go in get_tree().get_nodes_in_group("game_over"):
		go.queue_free()
	get_tree().change_scene_to_file("res://main.tscn")

func _on_settings():
	get_tree().change_scene_to_file("res://settings.tscn")

func _on_credits():
	get_tree().change_scene_to_file("res://credits.tscn")

func _on_quit():
	get_tree().quit()
