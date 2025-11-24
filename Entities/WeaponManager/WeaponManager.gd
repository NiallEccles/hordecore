@icon("res://Entities/WeaponManager/icon_propeller.png")
class_name WeaponManager
extends Node

@onready var weapon_socket: Marker3D = $"../Camera3D/WeaponSocket"

var weapons = {
	"smg": preload("res://Entities/Weapons/SMG/SMG.tscn")
}

var current_weapon: Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var weapon_instance = weapons.get("smg").instantiate()
	weapon_instance.max_mag_ammo = 28
	weapon_socket.add_child(weapon_instance)
	weapon_instance.transform = Transform3D()
	current_weapon = weapon_instance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fire():
	current_weapon.fire()
