@tool


extends Node

@export var GroundScene : PackedScene
@export var ObstacleScene : PackedScene

@export_range(1, 19) var map_width : int = 9:
	set(value):
		map_width = make_odd(map_width, value)
		generate_map()
		
@export_range(1, 19) var map_depth : int = 9:
	set(value):
		map_depth = make_odd(map_depth, value)
		generate_map()

@export_range(0, 1, 0.05) var obstacle_ratio : float = 0.2:
	set(value):
		obstacle_ratio = value
		generate_map()
		
@export_range(1, 5) var obstacle_min_height : float = 1:
	set(value):
		obstacle_min_height = min(value, obstacle_max_height)
		generate_map()
		
@export_range(1, 5) var obstacle_max_height : float = 5:
	set(value):
		obstacle_max_height = max(value, obstacle_min_height)
		generate_map()

@export var foreground_color : Color:
	set(value):
		foreground_color = value
		generate_map()

@export var background_color : Color:
	set(value):
		background_color = value
		generate_map()

@export var rng_seed = 12345:
	set(value):
		rng_seed = value
		generate_map()

var map_coords := []
var map_center : Coord
var obstacle_map := []
var shader_material : ShaderMaterial

class Coord:
	var x: int
	var z: int
	
	func _init(x: int, z: int):
		self.x = x
		self.z = z
		
	func _to_string():
		return "(x: " + str(x) + ", z: " + str(z) + ")"

	func equals(other: Coord) -> bool:
		return self.x == other.x && self.z == other.z

func make_odd(old_int, new_int) -> int:
	if new_int % 2 == 0:
		if new_int > old_int:
			return new_int + 1
		else:
			return new_int - 1
	else:
		return new_int
		

func fill_map_coords():
	map_coords = []
	for x in range(map_width):
		for z in range(map_depth):
			map_coords.append(Coord.new(x, z))

func fill_obstacle_map():
	obstacle_map = []

	for x in range(map_width):
		obstacle_map.append([])
		for z in range(map_depth):
			obstacle_map[x].append(false)

	print(obstacle_map)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_map()

func generate_map():
	print("Generating Map")
	
	clear_map()
	add_ground()
	update_map_center()
	update_obstacle_material()
	add_obstacles()

func clear_map():
	for node in get_children():
		node.queue_free()
		
func add_ground():
	var ground: CSGBox3D = GroundScene.instantiate()
	ground.size.x = map_width * 2
	ground.size.z = map_depth * 2
	add_child(ground)

func update_map_center():
	map_center = Coord.new(map_width / 2, map_depth / 2)

func update_obstacle_material():
	var temp_obstacle: CSGBox3D = ObstacleScene.instantiate()
	shader_material = temp_obstacle.material as ShaderMaterial
	shader_material.set_shader_parameter("foregroundColor", foreground_color)
	shader_material.set_shader_parameter("backgroundColor", background_color)
	shader_material.set_shader_parameter("depth", map_depth * 2)
	print(shader_material)

func add_obstacles():
	fill_map_coords()
	fill_obstacle_map()

	seed(rng_seed)
	map_coords.shuffle()

	var num_obstacles = map_coords.size() * obstacle_ratio
	var current_obstacle_count = 0

	if num_obstacles == 0:
		return

	for coord in map_coords.slice(0, num_obstacles - 1):
		if coord.equals(map_center):
			continue

		current_obstacle_count += 1
		obstacle_map[coord.x][coord.z] = true
		if map_is_fully_accessible(current_obstacle_count):
			create_obstacle_at(coord.x, coord.z)
		else:
			current_obstacle_count -= 1
			obstacle_map[coord.x][coord.z] = false

func map_is_fully_accessible(current_obstacle_count: int) -> bool:
	var we_already_checked_here = []
  
	for x in range(map_width):
		we_already_checked_here.append([])
		for z in range(map_depth):
			we_already_checked_here[x].append(false)

	# map center is always accessible
	var coords_to_check = [map_center]
	we_already_checked_here[map_center.x][map_center.z] = true
	var accessible_tile_count = 1
  
	while coords_to_check:
		var current_tile: Coord = coords_to_check.pop_front()
		for x in [-1, 0, 1]:
			for z in [-1, 0, 1]:
				if x == 0 or z == 0:  # non-diagonal neighbor
					var neighbor = Coord.new(current_tile.x + x, current_tile.z + z)
					# Make sure we don't go off map
					if on_the_map(neighbor):
						if not we_already_checked_here[neighbor.x][neighbor.z]:
							if not obstacle_map[neighbor.x][neighbor.z]:
								we_already_checked_here[neighbor.x][neighbor.z] = true
								coords_to_check.append(neighbor)
								accessible_tile_count += 1
	var target_accessible_tile_count = map_width * map_depth - current_obstacle_count
	return target_accessible_tile_count == accessible_tile_count

func on_the_map(coord: Coord) -> bool:
	return coord.x >= 0 and coord.x < map_width and coord.z >= 0 and coord.z < map_depth

func create_obstacle_at(x: int, z: int):
	var obstacle_position = Vector3(x * 2, 0, z * 2)
	var height = set_obstacle_height()
	obstacle_position += Vector3(-map_width + 1, height / 2, -map_depth + 1)
	var new_obstacle : CSGBox3D = ObstacleScene.instantiate()
	new_obstacle.transform.origin = obstacle_position
	new_obstacle.size.y = height
	
	new_obstacle.material = shader_material
	
	add_child(new_obstacle)

func set_obstacle_height() -> float :
	return randf_range(obstacle_min_height, obstacle_max_height)
