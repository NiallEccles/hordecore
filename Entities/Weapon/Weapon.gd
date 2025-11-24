extends Node3D
class_name Weapon

@export_enum("SMG", "Assault Rifle", "Shotgun", "Sniper Rifle") var weapon_type: String
@export var weapon_name: String
@export var max_ammo: int
@export var max_mag_ammo: int

var current_mag_ammo: int = max_mag_ammo

@onready var weapon_barrel = RayCast3D

func _ready() -> void:
	if !weapon_barrel:
		printerr("Weapon Barrel not found!")
		
	#current_mag_ammo = max_mag_ammo

func fire():
	pass

func reload():
	pass
