extends CharacterBody3D

const SPEED = 5.0

@onready var camera = $Camera3D
@onready var flashlight = $Camera3D/SpotLight3D
@onready var heartbeat = $HeartBeat

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var marker_scene = preload("res://marker.tscn")
var max_markers = 3
var markers_left = 3
var flashlight_on = true
var heartbeat_active = false

# Bob efekti
var bob_timer = 0.0
var bob_amount = 0.05
var bob_speed = 8.0
var original_camera_y = 0.6

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_marker_hud()
	original_camera_y = camera.position.y

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * GameSettings.sensitivity)
		camera.rotate_x(-event.relative.y * GameSettings.sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	if event.is_action_pressed("ui_cancel"):
		var pause = load("res://pause_menu.tscn").instantiate()
		get_tree().get_root().add_child(pause)
	if event.is_action_pressed("place_marker"):
		place_marker()
	if event.is_action_pressed("toggle_flashlight"):
		flashlight_on = !flashlight_on
		flashlight.visible = flashlight_on

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

	# Bob efekti
	var horizontal_velocity = Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and horizontal_velocity > 0.5:
		bob_timer += delta * bob_speed
		camera.position.y = original_camera_y + sin(bob_timer) * bob_amount
	else:
		bob_timer = 0.0
		camera.position.y = lerp(camera.position.y, original_camera_y, delta * 10)

	# Kalp atışı - çıkışa yaklaşınca
	var exit = get_tree().get_root().find_child("Exit", true, false)
	if exit:
		var dist = global_position.distance_to(exit.global_position)
		if dist < 15.0 and not heartbeat_active:
			heartbeat_active = true
			heartbeat.play()
		elif dist >= 15.0 and heartbeat_active:
			heartbeat_active = false
			heartbeat.stop()

func place_marker():
	if markers_left <= 0:
		print("İşaret hakkın kalmadı!")
		return
	var marker = marker_scene.instantiate()
	get_parent().add_child(marker)
	marker.position = Vector3(position.x, 0.05, position.z)
	markers_left -= 1
	update_marker_hud()

func update_marker_hud():
	var label = get_tree().get_root().find_child("MarkerLabel", true, false)
	if label:
		label.text = "İşaret: " + str(markers_left) + " / " + str(max_markers)

func reset_markers():
	markers_left = max_markers
	update_marker_hud()
