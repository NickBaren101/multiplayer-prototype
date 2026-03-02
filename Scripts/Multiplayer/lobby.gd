extends Control

@onready var player_label: Label = %PlayerLabel
@onready var start_button: Button = %StartButton


func _ready():
	multiplayer.peer_connected.connect(_update_lobby)
	multiplayer.peer_disconnected.connect(_update_lobby)

	_update_lobby()

	if multiplayer.is_server():
		start_button.visible = true
	else:
		start_button.visible = false

func _update_lobby(_id = 0):
	var count = multiplayer.get_peers().size() + 1
	player_label.text = "Players: " + str(count)
	
func _on_start_button_pressed():
	if not multiplayer.is_server():
		return
	load_world.rpc()

@rpc("authority", "call_local")
func load_world():
	get_tree().change_scene_to_file("res://Scenes/Levels/main.tscn")
