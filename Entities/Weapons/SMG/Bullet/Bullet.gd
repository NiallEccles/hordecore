extends Node3D

const SPEED = 80.0

# Export damage so you can set different values per bullet type
@export var DAMAGE: float = 4.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var area: Area3D = $Area3D  # Use Area3D instead of RayCast3D
@onready var particles = $GPUParticles3D

var has_hit: bool = false

func _ready() -> void:
	# Connect the body_entered signal
	if area:
		area.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if not has_hit:
		position += transform.basis * Vector3(0, 0, -SPEED) * delta

func _on_body_entered(body: Node3D) -> void:
	if has_hit:
		return  # Prevent multiple hits
	
	has_hit = true
	
	# Check if the body has a HealthComponent
	var health_component = _find_health_component(body)
	if health_component:
		health_component.take_damage(DAMAGE)
		print("Hit detected! Dealt ", DAMAGE, " damage to ", body.name)
	
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
	if not has_hit:
		queue_free()
