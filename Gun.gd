extends Node3D


@export var bullet : PackedScene
@export var muzzle_speed = 30
@export var millis_between_shots = 100

@onready var rate_of_fire_timer : Timer = $Timer
var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	rate_of_fire_timer.wait_time = millis_between_shots / 1000.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	shoot()
	pass
	
func shoot():
	if not can_shoot:
		return
		
	var new_bullet = bullet.instantiate()
	new_bullet.global_transform = $Muzzle.global_transform
	new_bullet.speed = muzzle_speed
	var scene_root = get_tree().root
	scene_root.add_child(new_bullet)
	can_shoot = false
	rate_of_fire_timer.start()


func _on_timer_timeout():
	can_shoot = true
