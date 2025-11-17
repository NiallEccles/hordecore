@icon("res://Common/Health/icon_heart.png")
extends Node
class_name HealthComponent

signal health_changed(new_health, max_health)
signal died()
signal damage_taken(amount)

@export var max_health: float = 100.0
@export var current_health: float = max_health

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	current_health -= amount
	current_health = max(0, current_health)
	
	damage_taken.emit(amount)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()

func heal(amount: float) -> void:
	current_health += amount
	current_health = min(current_health, max_health)
	health_changed.emit(current_health, max_health)

func get_health_percentage() -> float:
	return current_health / max_health if max_health > 0 else 0.0

func is_alive() -> bool:
	return current_health > 0
