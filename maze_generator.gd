extends Node

var CELL_SIZE = 4
var WALL_HEIGHT = 3
var WALL_THICKNESS = 0.3
var maze_width = 8
var maze_height = 8
var grid = []
var visited = []

var DIRS = [
	Vector2i(0, -1),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
]

func generate(level: int):
	maze_width = 6 + level
	maze_height = 6 + level
	grid = []
	visited = []
	for x in range(maze_width):
		grid.append([])
		visited.append([])
		for y in range(maze_height):
			grid[x].append([false, false, false, false])
			visited[x].append(false)
	_carve(0, 0)
	_clear_maze()
	_build_maze()
	_place_exit()
	_place_decorations()

func _carve(x: int, y: int):
	visited[x][y] = true
	var dirs = DIRS.duplicate()
	dirs.shuffle()
	for dir in dirs:
		var nx = x + dir.x
		var ny = y + dir.y
		if nx >= 0 and nx < maze_width and ny >= 0 and ny < maze_height:
			if not visited[nx][ny]:
				var dir_idx = DIRS.find(dir)
				var opp_idx = (dir_idx + 2) % 4
				grid[x][y][dir_idx] = true
				grid[nx][ny][opp_idx] = true
				_carve(nx, ny)

func _clear_maze():
	for child in get_parent().get_children():
		if child.is_in_group("maze_walls"):
			child.queue_free()

func _build_maze():
	var wall_mat = StandardMaterial3D.new()
	wall_mat.albedo_texture = load("res://textures/duvar.png")
	wall_mat.uv1_scale = Vector3(2, 1, 1)

	var floor_mat = StandardMaterial3D.new()
	floor_mat.albedo_texture = load("res://textures/zemin.png")
	floor_mat.uv1_scale = Vector3(4, 4, 1)

	_make_box(
		Vector3(maze_width * CELL_SIZE / 2.0, -0.5, maze_height * CELL_SIZE / 2.0),
		Vector3(maze_width * CELL_SIZE, 1, maze_height * CELL_SIZE),
		floor_mat
	)

	for x in range(maze_width):
		for y in range(maze_height):
			var wx = x * CELL_SIZE
			var wy = y * CELL_SIZE
			if not grid[x][y][0]:
				_make_box(
					Vector3(wx + CELL_SIZE/2.0, WALL_HEIGHT/2.0, wy),
					Vector3(CELL_SIZE + WALL_THICKNESS, WALL_HEIGHT, WALL_THICKNESS),
					wall_mat
				)
			if not grid[x][y][3]:
				_make_box(
					Vector3(wx, WALL_HEIGHT/2.0, wy + CELL_SIZE/2.0),
					Vector3(WALL_THICKNESS, WALL_HEIGHT, CELL_SIZE + WALL_THICKNESS),
					wall_mat
				)

	_make_box(
		Vector3(maze_width * CELL_SIZE / 2.0, WALL_HEIGHT/2.0, maze_height * CELL_SIZE),
		Vector3(maze_width * CELL_SIZE + WALL_THICKNESS, WALL_HEIGHT, WALL_THICKNESS),
		wall_mat
	)
	_make_box(
		Vector3(maze_width * CELL_SIZE, WALL_HEIGHT/2.0, maze_height * CELL_SIZE / 2.0),
		Vector3(WALL_THICKNESS, WALL_HEIGHT, maze_height * CELL_SIZE + WALL_THICKNESS),
		wall_mat
	)

func _bake_navigation():
	var nav = get_parent().get_node_or_null("NavigationRegion3D")
	if nav:
		nav.bake_navigation_mesh()

func _make_box(pos: Vector3, size: Vector3, mat: StandardMaterial3D):
	var body = StaticBody3D.new()
	body.add_to_group("maze_walls")
	var mesh_inst = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = size
	mesh_inst.mesh = box
	mesh_inst.material_override = mat
	var col = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = size
	col.shape = shape
	body.add_child(mesh_inst)
	body.add_child(col)
	body.position = pos
	get_parent().add_child(body)

func _place_exit():
	var exit = get_parent().get_node_or_null("Exit")
	if exit:
		var ex = (maze_width - 1) * CELL_SIZE + CELL_SIZE / 2.0
		var ey = (maze_height - 1) * CELL_SIZE + CELL_SIZE / 2.0
		exit.position = Vector3(ex, 1.5, ey)
		print("Exit pozisyonu: ", exit.position)

func _place_decorations():
	for d in get_tree().get_nodes_in_group("decorations"):
		d.queue_free()
	await get_tree().process_frame
	var deco_scene = load("res://decoration.tscn")
	for x in range(maze_width):
		for y in range(maze_height):
			if randi() % 4 == 0:
				var deco = deco_scene.instantiate()
				deco.add_to_group("decorations")
				get_parent().add_child(deco)
				deco.position = Vector3(
					x * CELL_SIZE + randf_range(0.5, CELL_SIZE - 0.5),
					0.15,
					y * CELL_SIZE + randf_range(0.5, CELL_SIZE - 0.5)
				)
				deco.rotation.y = randf_range(0, PI * 2)

func get_player_start() -> Vector3:
	return Vector3(CELL_SIZE / 2.0, 1, CELL_SIZE / 2.0)
