extends CharacterBody3D

@onready var gun_controller = $GunController
var speed = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector3()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.z -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.z += 1

	velocity = velocity.normalized() * speed

	move_and_slide()
	
	if Input.is_action_pressed("primary_action"):
		gun_controller.shoot()


func _on_stats_you_died_signal():
	queue_free()
