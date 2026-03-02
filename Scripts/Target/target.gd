extends CharacterBody3D

@export var max_health: int = 100

@onready var health_component: HealthComponent = $HealthComponent


func _ready() -> void:
	health_component.update_max_health(max_health)
	health_component.defeat.connect(_on_defeat)

func take_damage(damage_in: float) -> void:
	if not multiplayer.is_server():
		return
	health_component.take_damage(damage_in)
	
func _on_defeat() -> void:
	queue_free()
