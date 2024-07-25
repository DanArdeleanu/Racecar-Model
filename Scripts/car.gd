extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_FORCE = 300

var look_at

@onready var pivot_camera = $PivotCamera
@onready var camera_3d = $PivotCamera/Camera3D
@onready var reverse_camera = $PivotCamera/ReverseCamera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_at = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	steering =  move_toward(steering, Input.get_axis("MoveRight", "MoveLeft") * MAX_STEER, delta * 2.5)
	engine_force = Input.get_axis("Reverse", "Accelerate") * ENGINE_FORCE
	pivot_camera.global_position = pivot_camera.global_position.lerp(global_position, delta * 20.0)
	pivot_camera.transform = pivot_camera.transform.interpolate_with(transform, delta * 5.0)
	look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
	camera_3d.look_at(look_at)
	reverse_camera.look_at(look_at)
	_check_camera_switch()

func _check_camera_switch():
	if linear_velocity.dot(transform.basis.z) > 0:
		camera_3d.current = true
	else:
		reverse_camera.current = true
