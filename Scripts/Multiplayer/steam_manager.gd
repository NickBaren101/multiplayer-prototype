extends Node

var is_owned: bool = false
var steam_app_id: int = 480 # test game id
var steam_id: int = 0
var steam_username: String = ""

var lobby_id: int = 0
var lobby_max_members: int = 2

func _init() -> void:
	OS.set_environment("SteamAppId", str(steam_app_id))
	OS.set_environment("SteamGameId", str(steam_app_id))

func _process(_delta: float) -> void:
	Steam.run_callbacks()

func initialize_steam():
	var initialize_response: Dictionary = Steam.steamInitEx()
	
	if initialize_response.status != 0:
		print("Failed to Steam init: %s" %initialize_response)
		get_tree().quit()
	
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	
	if not is_owned:
		print("You aint own this game")
		get_tree().quit()
