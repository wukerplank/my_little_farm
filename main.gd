extends Node3D

@onready var player : Node3D = $Player
@onready var player_hand : Node3D = $Player/Body/Hand

var ray_origin = Vector3()
var ray_target = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_instance_valid(player):
		return
	
	var mouse_position = get_viewport().get_mouse_position()
#	print("Mouse Position: ", mouse_position)

	ray_origin = $Camera.project_ray_origin(mouse_position)
#	print("Ray Origin: ", ray_origin)

	ray_target = ray_origin + $Camera.project_ray_normal(mouse_position) * 2000
	
	var space_state = get_world_3d().direct_space_state
	
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_target
	params.collision_mask = 8 # only collide with the ground mask
	params.exclude = []
	var intersection = space_state.intersect_ray(params)
	
	if not intersection.is_empty():
		var pos = intersection.position
		var look_at_me = Vector3(pos.x, player.position.y ,pos.z)
		player.look_at(look_at_me, Vector3.UP)
		var distance_to_pointer = player_hand.global_transform.origin - look_at_me
		if distance_to_pointer.length() > 3:
			player_hand.look_at(look_at_me, Vector3.UP)
