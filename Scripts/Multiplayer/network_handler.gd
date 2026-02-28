extends Node

var peer: ENetMultiplayerPeer

const PORT: int = 7777

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	var host_id = multiplayer.get_unique_id()
	get_tree().call_group("spawner", "spawn_player", host_id)

func start_client(ip_address: String) -> void:
	if ip_address.strip_edges() == "":
		ip_address = "localhost"
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer
