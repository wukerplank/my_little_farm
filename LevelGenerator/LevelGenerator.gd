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

func make_odd(old_int, new_int) -> int:
	if new_int % 2 == 0:
		if new_int > old_int:
			return new_int + 1
		else:
			return new_int - 1
	else:
		return new_int
		

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
	for x in range(map_width):
		for z in range(map_depth):
			if randf() < obstacle_ratio:
				var obstacle_position = Vector3(x * 2, 0, z * 2)
				obstacle_position += Vector3(-map_width + 1, 1.25, -map_depth + 1)
				var new_obstacle : CSGBox3D = ObstacleScene.instantiate()
				new_obstacle.transform.origin = obstacle_position
				add_child(new_obstacle)
