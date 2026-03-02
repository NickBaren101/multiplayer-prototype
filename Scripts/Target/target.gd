extends CharacterBody3D

@export var max_health: int = 100

@onready var health_component: HealthComponent = $HealthComponent


func _ready() -> void:
	health_component.update_max_health(max_health)

func take_damage(damage_in: float) -> void:
	health_component.take_damage(damage_in)
