extends Node

var peer: ENetMultiplayerPeer

const PORT: int = 46834

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	_on_connected()

func start_client(ip_address := "") -> void:
	ip_address = ip_address.strip_edges()
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(_on_connected)

func _on_connected():
	get_tree().change_scene_to_file("res://Scenes/Multiplayer/lobby.tscn")
