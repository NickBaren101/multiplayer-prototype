extends Control

@onready var ip_address_entry: LineEdit = $VBoxContainer/IPAddressEntry


func _on_host_button_pressed() -> void:
	NetworkHandler.start_server()


func _on_join_button_pressed() -> void:
	NetworkHandler.start_client(ip_address_entry.text)
