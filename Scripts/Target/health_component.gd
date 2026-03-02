extends Node
class_name HealthComponent

signal defeat()
signal health_changed()

@export var body: PhysicsBody3D
@export var max_health: int = 0

var current_health: float:
	set(value):
		current_health =clamp(value, 0, max_health)
		if current_health == 0.0:
			defeat.emit()
		health_changed.emit()

# Runs at _ready()
func update_max_health(max_hp_in: int) -> void:
	if max_health == 0:
		max_health = max_hp_in
	current_health = max_health

# Use for taking damage
func take_damage(damage_in: float) -> void:
	var damage = damage_in
	current_health -= damage

# Debugging
func get_health_string() -> String:
	return "%d/%d" % [current_health, max_health]
