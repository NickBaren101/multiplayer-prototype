extends Control

@onready var host_button: Button = $VBoxContainer/HostButton
@onready var join_button: Button = $VBoxContainer/JoinButton
@onready var ip_address_entry: LineEdit = $VBoxContainer/IPAddressEntry

func _on_host_button_pressed() -> void:
	NetworkHandler.start_server()
	hide_ui()


func _on_join_button_pressed() -> void:
	NetworkHandler.start_client(ip_address_entry.text)
	hide_ui()


func hide_ui() -> void:
	host_button.disabled = true
	join_button.disabled = true
	visible = false
