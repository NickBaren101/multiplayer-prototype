extends Node

var enet_peer: ENetMultiplayerPeer
var steam_peer: SteamMultiplayerPeer
var _hosted_lobby_id: int

const PORT: int = 46834
const LOBBY_NAME: String = "Nick's Lobby"
const LOBBY_MODE: String = "1v1"

func _ready() -> void:
	Steam.lobby_created.connect(_on_lobby_created.bind())

func start_enet_server() -> void:
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	_on_connected()

func start_enet_client(ip_address := "") -> void:
	ip_address = ip_address.strip_edges()
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = enet_peer

	multiplayer.connected_to_server.connect(_on_connected)

func start_steam_server() -> void:
	steam_peer = SteamMultiplayerPeer.new()
	
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, SteamManager.lobby_max_members)

func start_steam_client(lobby_id :int) -> void:
	steam_peer = SteamMultiplayerPeer.new()
	
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	Steam.joinLobby(lobby_id)

func _on_lobby_created(connection: int, lobby_id):
	if connection == 1:
		_hosted_lobby_id = lobby_id
		print("created_lobby ", _hosted_lobby_id)
		
		Steam.setLobbyJoinable(_hosted_lobby_id, true)
		Steam.setLobbyData(_hosted_lobby_id, "name", LOBBY_NAME)
		Steam.setLobbyData(_hosted_lobby_id, "mode", LOBBY_MODE)
		
		_create_host()

func _create_host():
	var success = steam_peer.create_host(0)
	if success == OK:
		multiplayer.multiplayer_peer = steam_peer
	
	else:
		push_error(success)

func _on_lobby_joined(lobby_id, permissions, locked_status, response):
	if response == 1:
		var id = Steam.getLobbyOwner(lobby_id)
		if id != Steam.getSteamID():
			connect_socket(id)
		_on_connected()
	
	else:
		push_error(response)

func connect_socket(steam_id):
	var success = steam_peer.create_client(steam_id, 0)
	if success == OK:
		multiplayer.multiplayer_peer = steam_peer
	
	else:
		push_error(success)

func list_lobbies():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.addRequestLobbyListStringFilter("name", LOBBY_NAME, Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()

func _on_connected():
	get_tree().change_scene_to_file("res://Scenes/Multiplayer/lobby.tscn")
