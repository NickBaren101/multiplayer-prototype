extends Node

var peer: ENetMultiplayerPeer

const IP_ADDRESS: String = "localhost"
const PORT: int = 7777

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	var host_id = multiplayer.get_unique_id()
	get_tree().call_group("spawner", "spawn_player", host_id)

func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
