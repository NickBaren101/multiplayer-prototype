extends MultiplayerSpawner


@export var player_scene: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)


func spawn_player(id: int) -> void:
	if not multiplayer.is_server():
		return
	
	var player: Node = player_scene.instantiate()
	player.name = str(id)
	
	get_node(spawn_path).call_deferred("add_child", player)

func remove_player(peer_id):
	var player = get_node(spawn_path).get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
