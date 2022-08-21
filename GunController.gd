extends Node


@export var StartingWeapon : PackedScene
var hand : Position3D
var equipped_weapon : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	hand = get_parent().find_child("Hand")
	if StartingWeapon:
		equip_weapon(StartingWeapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func equip_weapon(weapon_to_equip : PackedScene):
	if equipped_weapon:
		print("Deleting current weapon")
		equipped_weapon.queue_free()
	else:
		print("No weapon equipped")
	
	equipped_weapon = weapon_to_equip.instantiate()
	hand.add_child(equipped_weapon)

func shoot():
	if not equipped_weapon:
		return
		
	equipped_weapon.shoot()
