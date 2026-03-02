extends MultiplayerSpawner

@export var target_scene: PackedScene

@onready var target_spawn: Node3D = $"../FinalStage/TargetSpawn"

func _ready():
	if not multiplayer.is_server():
		return

	spawn_targets()

func spawn_targets():
	var spawn_markers = target_spawn.get_children()
	for marker in spawn_markers:
		var target = target_scene.instantiate()
		target.global_transform = marker.global_transform
		get_node(spawn_path).add_child(target, true)
