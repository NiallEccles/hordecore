extends Node3D

const SPEED = 80.0

# Export damage so you can set different values per bullet type
@export var DAMAGE: float = 4.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: RayCast3D = $RayCast3D
@onready var particles = $GPUParticles3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		
		# Check if the collided object has a HealthComponent
		if collider:
			var health_component = _find_health_component(collider)
			if health_component:
				health_component.take_damage(DAMAGE)
		
		# Bullet impact effects
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

# Helper function to find HealthComponent in the node or its children
func _find_health_component(node: Node) -> HealthComponent:
	# Check if the node itself is a HealthComponent
	if node is HealthComponent:
		return node
	
	# Look through the node's children
	for child in node.get_children():
		if child is HealthComponent:
			return child
	
	return null

func _on_timer_timeout() -> void:
	queue_free()
