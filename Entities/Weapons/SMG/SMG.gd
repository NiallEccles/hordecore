extends Weapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Shooting variables
@export var fire_rate: float = 0.1  # Time between shots in seconds (0.1 = 10 shots/sec)
var can_shoot: bool = true
var shoot_timer: float = 0.0

# Instantiated scenes
var bullet = load("res://Entities/Weapons/SMG/Bullet/Bullet.tscn")
var instance

#var camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#camera = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire():
	print('firing...')
	print(current_mag_ammo)
	if current_mag_ammo <= 0:
		return
	
	current_mag_ammo = current_mag_ammo - 1
	
		# Play animation if not already playing
	if not animation_player.is_playing():
		animation_player.play("Shoot")
	
	# Create and spawn bullet
	instance = bullet.instantiate()
	instance.position = weapon_barrel.global_position
	
	# Get direction from camera center (crosshair) instead of barrel
	#instance.transform.basis = camera.global_transform.basis
	
	get_tree().root.get_child(0).add_child(instance)
	
	# Reset fire rate timer
	can_shoot = false
	shoot_timer = 0.0
