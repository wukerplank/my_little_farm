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

@export var rng_seed = 12345:
	set(value):
		rng_seed = value
		generate_map()

var map_coords := []

class Coord:
	var x: int
	var z: int
	
	func _init(x: int, z: int):
		self.x = x
		self.z = z
		
	func _to_string():
		return "(x: " + str(x) + ", z: " + str(z) + ")"

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_map()

func generate_map():
	print("Generating Map")
	
	clear_map()
	add_ground()
	add_obstacles()

func clear_map():
	for node in get_children():
		node.queue_free()
		
func add_ground():
	var ground: CSGBox3D = GroundScene.instantiate()
	ground.size.x = map_width * 2
	ground.size.z = map_depth * 2
	add_child(ground)

func add_obstacles():
	fill_map_coords()
#	print(map_coords)
	seed(rng_seed)
	map_coords.shuffle()
#	print(map_coords)
	
	var num_obstacles = map_coords.size() * obstacle_ratio
	if num_obstacles == 0:
		return
	
	for coord in map_coords.slice(0, num_obstacles-1):
		create_obstacle_at(coord.x, coord.z)
	
func create_obstacle_at(x: int, z: int):
	var obstacle_position = Vector3(x * 2, 0, z * 2)
	var height = set_obstacle_height()
	obstacle_position += Vector3(-map_width + 1, height / 2, -map_depth + 1)
	var new_obstacle : CSGBox3D = ObstacleScene.instantiate()
	new_obstacle.transform.origin = obstacle_position
	new_obstacle.size.y = height
	add_child(new_obstacle)

func set_obstacle_height() -> float :
	return randf_range(obstacle_min_height, obstacle_max_height)
