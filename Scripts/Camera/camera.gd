extends Node3D

@export var camera_target: Node3D
@onready var camera_3d: Camera3D = $CameraTarget/SpringArm3D/Camera3D

var yaw: float
var yaw_sensitivity: float = 0.002


func _ready() -> void:
	if is_multiplayer_authority():
		camera_3d.current = true
	else:
		camera_3d.current = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		get_parent().rotate_y(-event.relative.x * yaw_sensitivity)
		
