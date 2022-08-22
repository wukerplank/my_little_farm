extends CharacterBody3D

@onready var nav : NavigationRegion3D = $"../Navigation"
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent
@onready var player = $"../Player"

@export var movement_speed = 4

var speed = 2

# More information about the Godot 4 navigation: https://godotengine.org/article/navigation-server-godot-4-0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_path(player.global_transform.origin)
	
	var next_path_position : Vector3 = navigation_agent.get_next_location()
	var current_agent_position : Vector3 = global_transform.origin
	var new_velocity : Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
	navigation_agent.set_velocity(new_velocity)
	look_at(next_path_position)

func _on_navigation_agent_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func update_path(target_position: Vector3):
	navigation_agent.set_target_location(target_position)
	
	if not navigation_agent.is_target_reachable():
		print("Target is no reachable :-(")


func _on_timer_timeout():
#	print("Looking for player!")
	update_path(player.global_transform.origin)


func _on_stats_you_died_signal():
	queue_free()
