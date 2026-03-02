extends Node3D

@onready var hud: CanvasLayer = $HUD
@onready var score_label: Label = $HUD/ScoreLabel
@onready var players: Node3D = $Players


var local_player: CharacterBody3D = null



func _process(_delta) -> void:
	if local_player == null:
		find_local_player()
		return

	update_score_display()

func find_local_player():
	for p in players.get_children():
		if p.is_multiplayer_authority():
			local_player = p
			return

func update_score_display():
	var opponent_score := 0

	for p in players.get_children():
		if p != local_player:
			opponent_score = p.score

	score_label.text = "You: %d - Opponent: %d" % [local_player.score, opponent_score]

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
