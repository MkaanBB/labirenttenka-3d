extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)
	monitoring = true
	monitorable = true

func _process(delta):
	rotation.y += delta * 1.5

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.next_level()
