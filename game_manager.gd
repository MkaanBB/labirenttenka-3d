extends Node

enum GameMode {ENDLESS, SPRINT, SURVIVAL}
var current_mode = GameMode.ENDLESS

var current_level = 1
var max_levels = 10
var game_over_scene = preload("res://game_over.tscn")
var jumpscare_scene = preload("res://jumpscare.tscn")
var jumpscare_timer = 0.0
var next_jumpscare = 45.0
var jumpscare_active = false
var in_game = false
var total_score = 0
var level_timer = 0.0
var timer_active = false

func _ready():
	pass

func _process(delta):
	if not in_game:
		return
	if jumpscare_active:
		return
	if not get_tree().get_first_node_in_group("maze_generator"):
		return

	jumpscare_timer += delta
	if jumpscare_timer >= next_jumpscare:
		jumpscare_timer = 0.0
		next_jumpscare = randf_range(30.0, 60.0)
		_trigger_jumpscare()

	if timer_active:
		if current_mode == GameMode.SURVIVAL:
			level_timer -= delta
			if level_timer <= 0:
				level_timer = 0
				restart_level()
		else:
			level_timer += delta

	var timer_label = get_tree().get_root().find_child("TimerLabel", true, false)
	var score_label = get_tree().get_root().find_child("ScoreLabel", true, false)
	var mode_label = get_tree().get_root().find_child("ModeLabel", true, false)

	if timer_label:
		var mins = int(level_timer) / 60
		var secs = int(level_timer) % 60
		timer_label.text = "⏱ %02d:%02d" % [mins, secs]
	if score_label:
		score_label.text = "⭐ " + str(total_score)
	if mode_label:
		match current_mode:
			GameMode.ENDLESS: mode_label.text = "🔄 ENDLESS"
			GameMode.SPRINT: mode_label.text = "⚡ SPRINT - %d/10" % current_level
			GameMode.SURVIVAL: mode_label.text = "💀 SURVIVAL"

func _trigger_jumpscare():
	jumpscare_active = true
	var js = jumpscare_scene.instantiate()
	get_tree().get_root().add_child(js)

func jumpscare_done():
	jumpscare_active = false
	jumpscare_timer = 0.0
	next_jumpscare = randf_range(30.0, 60.0)

func _calculate_score():
	var player = get_tree().get_root().find_child("Player", true, false)
	var markers_used = 0
	if player:
		markers_used = player.max_markers - player.markers_left
	var time_bonus = 0
	if current_mode != GameMode.SURVIVAL:
		time_bonus = max(0, 300 - int(level_timer)) * 10
	var marker_bonus = (3 - markers_used) * 500
	var level_score = time_bonus + marker_bonus + 1000
	total_score += level_score
	print("Level skoru: ", level_score, " | Toplam: ", total_score)

func _show_level_banner(level: int):
	var banner = CanvasLayer.new()
	banner.layer = 10
	get_tree().get_root().add_child(banner)

	var label = Label.new()
	label.text = "LEVEL " + str(level)
	label.add_theme_font_size_override("font_size", 72)
	label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	banner.add_child(label)

	await get_tree().create_timer(2.0).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	await tween.finished
	banner.queue_free()

func start_level(level: int):
	in_game = true
	timer_active = true
	jumpscare_timer = 0.0
	jumpscare_active = false
	_show_level_banner(level)

	match current_mode:
		GameMode.ENDLESS:
			level_timer = 0.0
			next_jumpscare = randf_range(30.0, 60.0)
		GameMode.SPRINT:
			level_timer = 0.0
			next_jumpscare = 9999.0
		GameMode.SURVIVAL:
			level_timer = 120.0
			next_jumpscare = randf_range(10.0, 25.0)

	for marker in get_tree().get_nodes_in_group("markers"):
		marker.queue_free()
	for d in get_tree().get_nodes_in_group("decorations"):
		d.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var maze = get_tree().get_first_node_in_group("maze_generator")
	maze.generate(level)
	await get_tree().create_timer(0.3).timeout
	var player = get_tree().get_root().find_child("Player", true, false)
	if player:
		player.position = maze.get_player_start()
		player.reset_markers()

func next_level():
	timer_active = false
	_calculate_score()
	current_level += 1
	if current_mode == GameMode.SPRINT and current_level > 10:
		show_game_over(true)
		return
	if current_mode != GameMode.ENDLESS and current_level > max_levels:
		show_game_over(true)
	else:
		start_level(current_level)

func restart_level():
	timer_active = false
	show_game_over(false)

func show_game_over(won: bool):
	# Yüksek skor kontrolü
	match current_mode:
		GameMode.ENDLESS:
			if total_score > GameSettings.high_score_endless:
				GameSettings.high_score_endless = total_score
				GameSettings.save()
		GameMode.SPRINT:
			if total_score > GameSettings.high_score_sprint:
				GameSettings.high_score_sprint = total_score
				GameSettings.save()
		GameMode.SURVIVAL:
			if total_score > GameSettings.high_score_survival:
				GameSettings.high_score_survival = total_score
				GameSettings.save()

	in_game = false
	timer_active = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	for go in get_tree().get_nodes_in_group("game_over"):
		go.queue_free()
	var go = game_over_scene.instantiate()
	get_tree().get_root().add_child(go)
	go.add_to_group("game_over")
	go.setup(won, current_level)
	if won:
		current_level = 1
		total_score = 0

func go_to_menu():
	in_game = false
	timer_active = false
	total_score = 0
	current_level = 1
	for go in get_tree().get_nodes_in_group("game_over"):
		go.queue_free()
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://menu.tscn")
