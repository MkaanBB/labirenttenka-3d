extends CharacterBody3D

const SPEED = 2.5
const CATCH_DISTANCE = 1.5

var player = null
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var move_timer = 0.0
var current_direction = Vector3.ZERO
var caught = false
var active = false

@onready var body = $Body

func _ready():
	add_to_group("enemy")
	caught = false
	active = false
	await get_tree().create_timer(3.0).timeout
	player = get_tree().get_root().find_child("Player", true, false)
	active = true

func _physics_process(delta):
	# Sallanma animasyonu
	body.rotation.z = sin(Time.get_ticks_msec() * 0.005) * 0.15
	body.rotation.x = sin(Time.get_ticks_msec() * 0.003) * 0.05

	if not player or caught or not active:
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	var dist = global_position.distance_to(player.global_position)
	if dist < CATCH_DISTANCE:
		_catch_player()
		return
	move_timer -= delta
	if move_timer <= 0:
		move_timer = 0.5
		var dir = (player.global_position - global_position)
		dir.y = 0
		current_direction = dir.normalized()
	velocity.x = current_direction.x * SPEED
	velocity.z = current_direction.z * SPEED
	move_and_slide()
	if get_slide_collision_count() > 0:
		current_direction = current_direction.rotated(Vector3.UP, PI / 2)

func _catch_player():
	if caught:
		return
	caught = true
	active = false
	print("Yakalandın!")
	GameManager.restart_level()
