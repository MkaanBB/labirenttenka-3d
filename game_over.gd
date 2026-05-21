extends Control

@onready var title_label = $VBoxContainer/TitleLabel
@onready var level_label = $VBoxContainer/LevelLabel
@onready var menu_btn = $VBoxContainer/MenuButton

func _ready():
	add_to_group("game_over")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menu_btn.pressed.connect(_on_menu)

func setup(won: bool, level: int):
	var mode_text = ""
	var high_score = 0
	match GameManager.current_mode:
		GameManager.GameMode.ENDLESS:
			mode_text = "🔄 Endless"
			high_score = GameSettings.high_score_endless
		GameManager.GameMode.SPRINT:
			mode_text = "⚡ Sprint"
			high_score = GameSettings.high_score_sprint
		GameManager.GameMode.SURVIVAL:
			mode_text = "💀 Survival"
			high_score = GameSettings.high_score_survival

	if won:
		title_label.text = "Tebrikler, " + GameSettings.player_name + "! 🎉"
		level_label.text = "Mod: " + mode_text + "\n" + str(level) + " leveli tamamladın!\n⭐ Skor: " + str(GameManager.total_score) + "\n🏆 En Yüksek: " + str(high_score)
	else:
		title_label.text = GameSettings.player_name + " oyun bitti! 💀"
		level_label.text = "Mod: " + mode_text + "\n" + str(level) + ". levelde öldün!\n⭐ Skor: " + str(GameManager.total_score) + "\n🏆 En Yüksek: " + str(high_score)

func _on_menu():
	GameManager.go_to_menu()
