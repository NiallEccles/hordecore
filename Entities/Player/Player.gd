extends CharacterBody3D

# Movement variables
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var mouse_sensitivity = 0.003

# Camera variables
@onready var camera = $Camera3D
@onready var weapon = $Camera3D/Smg
@onready var weapon_animation = $Camera3D/Smg/AnimationPlayer
@onready var weapon_barrel = $Camera3D/Smg/RayCast3D

# Instantiated scenes
var bullet = load("res://Entities/Weapons/SMG/Bullet/Bullet.tscn")
var instance

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Capture the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse movement for camera look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Toggle mouse capture with Escape key
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	 # handle shooting
	if Input.is_action_pressed('shoot'):
		if !weapon_animation.is_playing():
			#if weapon.has_node("AnimationPlayer"):
			weapon_animation.play("Shoot")
			instance = bullet.instantiate()
			instance.position = weapon_barrel.global_position
			instance.transform.basis = weapon_barrel.global_transform.basis
			get_tree().root.get_child(0).add_child(instance)
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# Determine current speed (sprint or walk)
	#var current_speed = sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	var current_speed = walk_speed
	# Get input direction and handle movement
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
