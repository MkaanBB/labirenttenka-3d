extends Node

var volume = 80.0
var sensitivity = 0.003
var quality = 1
var high_score_endless = 0
var high_score_sprint = 0
var high_score_survival = 0
var player_name = ""

func _ready():
	load_settings()

func save():
	var config = ConfigFile.new()
	config.set_value("settings", "volume", volume)
	config.set_value("settings", "sensitivity", sensitivity)
	config.set_value("settings", "quality", quality)
	config.set_value("scores", "endless", high_score_endless)
	config.set_value("scores", "sprint", high_score_sprint)
	config.set_value("scores", "survival", high_score_survival)
	config.save("user://settings.cfg")
	config.set_value("player", "name", player_name)

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		volume = config.get_value("settings", "volume", 80.0)
		sensitivity = config.get_value("settings", "sensitivity", 0.003)
		quality = config.get_value("settings", "quality", 1)
		high_score_endless = config.get_value("scores", "endless", 0)
		high_score_sprint = config.get_value("scores", "sprint", 0)
		high_score_survival = config.get_value("scores", "survival", 0)
		player_name = config.get_value("player", "name", "")
