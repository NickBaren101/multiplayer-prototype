extends MultiplayerSpawner

@export var player_scene: PackedScene

@onready var spawn_1: Marker3D = $"../FinalStage/Marker3D SPAWN"
@onready var spawn_2: Marker3D = $"../FinalStage/Marker3D SPAWN2"


func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)

	if multiplayer.is_server():
		spawn_player(multiplayer.get_unique_id())
		for peer_id in multiplayer.get_peers():
			spawn_player(peer_id)

func spawn_player(id: int) -> void:
	if not multiplayer.is_server():
		return
	if get_node(spawn_path).has_node(str(id)):
		return
	
	
	var player: Node = player_scene.instantiate()
	player.name = str(id)
	
	get_node(spawn_path).add_child(player)
	
	if id == multiplayer.get_unique_id():
		player.global_transform = spawn_1.global_transform
		rpc("_set_spawn_transform", id, spawn_1.global_transform)
	else:
		player.global_transform = spawn_2.global_transform
		rpc("_set_spawn_transform", id, spawn_2.global_transform)


func remove_player(peer_id):
	var player = get_node(spawn_path).get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

@rpc("any_peer", "call_local")
func _set_spawn_transform(id, transform):
	var player = get_node(spawn_path).get_node_or_null(str(id))
	if player:
		player.global_transform = transform
