extends CharacterBody3D

@export var speed := 10.0
@export var jump_velocity = 10.0

@onready var camera: Node3D = $Camera3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D


var gravity = 20.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	if is_multiplayer_authority():
		camera.current = true
	else:
		camera.current = false
		set_physics_process(false)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event) -> void:
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		
	if Input.is_action_just_pressed("shoot"):
		play_shoot_audio.rpc()
		if multiplayer.is_server():
			request_shoot()
		else:
			request_shoot.rpc_id(1)


func _physics_process(delta) -> void:
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

@rpc("call_local")
func play_shoot_audio() -> void:
		audio_player.play()

@rpc("any_peer")
func request_shoot() -> void:
	if not multiplayer.is_server():
		return
	
	perform_shoot()

func perform_shoot() -> void:
	var space_state = get_world_3d().direct_space_state
	var origin = global_transform.origin + Vector3(0, 1.5, 0)
	var direction = -global_transform.basis.z
	var ray_end = origin + direction * 1000.0

	var query = PhysicsRayQueryParameters3D.create(origin, ray_end)
	query.exclude = [self]

	query.collision_mask = 0xFFFFFFFF

	var result = space_state.intersect_ray(query)

	if result:
		var collider = result.collider
		if collider.has_method("take_damage"):
			collider.take_damage(100)
