extends Node3D


@export var enemy : PackedScene
@onready var timer : Timer = $Timer

var enemies_remaining_to_spawn : int
var enemies_killed_this_wave : int

var waves# : Array[EnemyWave]
var current_wave : EnemyWave
var current_wave_number = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	print($Waves.get_children())
	print($Waves.get_children() as Array[EnemyWave])
	waves = $Waves.get_children() as Array[EnemyWave]
	start_next_wave()
	
func start_next_wave():
	enemies_killed_this_wave = 0
	current_wave_number += 1
	if current_wave_number < waves.size():
		current_wave = waves[current_wave_number]
		enemies_remaining_to_spawn = current_wave.num_enemies
		timer.wait_time = current_wave.num_seconds_spawns
		timer.start()

func connect_to_enemy_signals(enemy_instance : Enemy):
	var stats : Stats = enemy_instance.get_node("Stats")
	stats.connect("you_died_signal", self._on_enemy_stats_you_died_signal)

func _on_timer_timeout():
	if enemies_remaining_to_spawn > 0:
		var enemy_instance : Enemy = enemy.instantiate()
		connect_to_enemy_signals(enemy_instance)
		var scene_root = get_parent_node_3d()
		scene_root.add_child(enemy_instance)
		enemies_remaining_to_spawn -= 1
	elif enemies_killed_this_wave == current_wave.num_enemies:
			start_next_wave()

func _on_enemy_stats_you_died_signal():
	enemies_killed_this_wave += 1
