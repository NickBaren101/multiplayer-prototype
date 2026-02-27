extends Node3D

@export var camera_target: Node3D

var yaw: float
var yaw_sensitivity: float = 0.002


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	camera_target.rotation.y = lerpf(camera_target.rotation.y, yaw, delta * 10)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() != 0:
		yaw += -event.relative.x * yaw_sensitivity
		
