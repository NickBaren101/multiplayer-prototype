extends Control

@onready var ip_address_entry: LineEdit = %IPAddressEntry
@onready var lobby_list: VBoxContainer = %LobbyList

var current_lobby_id: int

func _ready() -> void:
	SteamManager.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	NetworkHandler.list_lobbies()

func _on_host_enet_button_pressed() -> void:
	NetworkHandler.start_enet_server()


func _on_join_enet_button_pressed() -> void:
	NetworkHandler.start_enet_client(ip_address_entry.text)


func _on_host_steam_button_pressed() -> void:
	NetworkHandler.start_steam_server()


func _on_join_steam_button_pressed() -> void:
	NetworkHandler.start_steam_client(current_lobby_id)


func lobby_clicked(lobby: int) -> void:
	current_lobby_id = lobby
	print(current_lobby_id)


func _on_lobby_match_list(lobbies: Array):
	for lobby_child in lobby_list.get_children():
		lobby_child.queue_free()
	
	for lobby in lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		var lobby_mode: String = Steam.getLobbyData(lobby, "mode")
		
		if lobby:
			var lobby_button: Button = Button.new()
			lobby_button.text = lobby_name + "|" + lobby_mode
			lobby_button.add_theme_font_size_override("font_size", 12)
			lobby_button.set_name("lobby %s" % lobby)
			lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			lobby_button.connect("pressed", Callable(self, "lobby_clicked").bind(lobby))
			
			lobby_list.add_child(lobby_button)
