extends CharacterBody3D

class_name Enemy

@onready var nav : NavigationRegion3D = $"../Navigation"
@onready var navigation_agent : NavigationAgent3D = $NavigationAgent
@onready var player = $"../Player"
@onready var attack_timer : Timer = $AttackTimer



var default_material = load("res://Enemy/EnemyDefaultMaterial.tres")
var attack_material = load("res://Enemy/EnemyAttackMaterial.tres")
var resting_material = load("res://Enemy/EnemyRestingMaterial.tres")



@export var movement_speed = 2

var attack_speed_multiplier = 5
var attack_target : Vector3
var return_target : Vector3

enum state {
	SEEKING,
	ATTACKING,
	RETURNING,
	RESTING,
}
var current_state = state.SEEKING


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_instance_valid(player):
		return
	
	update_path(player.global_transform.origin)
	
	match current_state:
		state.SEEKING:
			$Body.set_surface_override_material(0, default_material)
			collide_with_other_enemies(true)
			var next_path_position : Vector3 = navigation_agent.get_next_location()
			var current_agent_position : Vector3 = global_transform.origin
			var new_velocity : Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
			navigation_agent.set_velocity(new_velocity)
			look_at(next_path_position)
			
			if $AttackRadius.overlaps_body(player):
				init_attack()
				
		state.ATTACKING:
			$Body.set_surface_override_material(0, attack_material)
			collide_with_other_enemies(false)
			move_and_attack()
		state.RETURNING:
			move_and_attack()
		state.RESTING:
			$Body.set_surface_override_material(0, resting_material)
			collide_with_other_enemies(true)

# Navigation ---------------------------------------------------------------------------------------

# More information about the Godot 4 navigation: https://godotengine.org/article/navigation-server-godot-4-0

func _on_navigation_agent_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func update_path(target_position: Vector3):
	navigation_agent.set_target_location(target_position)
	
	if not navigation_agent.is_target_reachable():
		print("Target is no reachable :-(")


func _on_path_update_timer_timeout():
#	print("Looking for player!")
	if !is_instance_valid(player):
		return
	update_path(player.global_transform.origin)


func _on_stats_you_died_signal():
	queue_free()

# Attacking ----------------------------------------------------------------------------------------

func move_and_attack():
	var attack_vector : Vector3 = attack_target - global_transform.origin
	var direction : Vector3 = attack_vector.normalized()
	var distance = attack_vector.length()
	velocity = direction * movement_speed * attack_speed_multiplier
	
	print("I'm this far away from my target: ", distance)
	move_and_slide()

	if distance < 0.5:
		match current_state:
			state.ATTACKING:
				# Do damage to the player
				var player_stats : Stats = player.get_node("Stats")
				player_stats.take_hit(1)
				print("I hit you: ", player_stats.current_hit_points, "/", player_stats.max_hit_points)
				
				
				current_state = state.RETURNING
				attack_target = return_target
			state.RETURNING:
				current_state = state.RESTING
				attack_timer.start()
				move_and_slide()
			state.RESTING:
				# Make sure to slide a little to prevent overlaps of resting enemies
				move_and_slide()
			

func collide_with_other_enemies(should_we_collide : bool):
	set_collision_mask_value(2, should_we_collide)

func init_attack():
	# print("Something entered my attack radius ", body)
	attack_target = player.global_transform.origin
	return_target = global_transform.origin
	current_state = state.ATTACKING

func _on_attack_timer_timeout():
	current_state = state.SEEKING
