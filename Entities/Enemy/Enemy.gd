extends CharacterBody3D

var SPEED = 2.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var health_component: HealthComponent = $Health

func _ready() -> void:
	# Connect to health component signals
	if health_component:
		health_component.died.connect(_on_died)
		health_component.damage_taken.connect(_on_damage_taken)

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func _on_died() -> void:
	# Add death behavior here (animation, particles, etc.)
	queue_free()

func _on_damage_taken(amount: float) -> void:
	# Optional: Add visual feedback when damaged (flash, sound, etc.)
	print("Enemy took ", amount, " damage!")
