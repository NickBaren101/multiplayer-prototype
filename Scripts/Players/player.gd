extends CharacterBody3D

@export var speed := 6.0
@onready var camera: Node3D = $Camera


func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _ready():
	if not is_multiplayer_authority():
		set_physics_process(false)


func _physics_process(delta):
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
