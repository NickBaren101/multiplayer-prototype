extends Node

const PORT = 7777
const PlayerScene = preload("res://Scenes/Players/player.tscn")

@onready var players_node = get_parent().get_node("Players")

var peer : ENetMultiplayerPeer

func host_game():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	print("Hosting on port ", PORT)

	# Spawn host player manually (host is always ID 1)
	_spawn_player(multiplayer.get_unique_id())


func join_pressed():
	var ip = get_parent().get_node("UI/IPInput").text
	join_game(ip)


func join_game(ip):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	print("Connecting to ", ip)

@rpc("any_peer", "call_local")
func _notify_network_ready():
	for child in players_node.get_children():
		child._set_network_ready()

func _on_connected_to_server():
	print("Connected to server")


func _on_peer_connected(id):
	print("Peer connected: ", id)
	rpc("_spawn_player_rpc", id)
	rpc("_notify_network_ready")
	_spawn_player(id)


func _on_peer_disconnected(id):
	print("Peer disconnected: ", id)
	if players_node.has_node(str(id)):
		players_node.get_node(str(id)).queue_free()


func _spawn_player(id):
	var player = PlayerScene.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	players_node.add_child(player)
