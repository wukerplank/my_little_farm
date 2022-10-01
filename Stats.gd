extends Node

class_name Stats

@export var max_hit_points : int = 10
var current_hit_points : int = max_hit_points

signal you_died_signal


# Called when the node enters the scene tree for the first time.
func _ready():
	current_hit_points = max_hit_points


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_hit(damage : int):
	current_hit_points -= damage
#	print("I'm hit! ", current_hit_points, "/", max_hit_points)
	
	if current_hit_points <= 0:
		die()
	
func die():
	emit_signal("you_died_signal")
