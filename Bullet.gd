extends Node3D

@export var speed = 10

const KILL_TIME = 2 # seconds
var timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)
	
	timer += delta
	
	if timer >= KILL_TIME:
		queue_free()


func _on_area_3d_body_entered(body):
#	print("Hit! ", body)
	queue_free()
	
