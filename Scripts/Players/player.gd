extends CharacterBody3D

@export var speed := 10.0
@export var jump_velocity = 10.0

@onready var camera: Node3D = $Camera3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var gravity = 20.0

func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _ready():
	if is_multiplayer_authority():
		camera.current = true
	else:
		camera.current = false
		set_physics_process(false)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		
	if Input.is_action_just_pressed("shoot"):
		audio_player.play()


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
