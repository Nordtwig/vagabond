class_name PlayerController
extends CharacterBody3D

@export_group("Moving")
@export var _max_speed: float = 4.0
@export var _max_run_speed: float = 6.0
@export var _acceleration: float = 20.0
@export var _braking: float = 20.0

@export_group("Jumping")
@export var _jump_force: float = 5.0
@export var _air_acceleration: float = 4.0
@export var _gravity_modifier: float = 1.5

@export_group("Looking")
@export var _look_sensitivity: float = 0.005

var _is_running: bool = false
var _camera_look_input: Vector2

@onready var camera: Camera3D = get_node("Camera3D")
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * _gravity_modifier


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = _jump_force
		
	# moving
	var move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_direction = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()

	_is_running = Input.is_action_pressed("sprint")

	var target_speed = _max_speed

	if _is_running:
		target_speed = _max_run_speed
		var run_dot = -move_direction.dot(transform.basis.z)
		run_dot = clamp(run_dot, 0.0, 1.0)
		move_direction *= run_dot

	var current_smoothing = _acceleration

	if not is_on_floor():
		current_smoothing = _air_acceleration
	elif not move_direction:
		current_smoothing = _braking

	var target_velocity = move_direction * target_speed

	velocity.x = lerp(velocity.x, target_velocity.x, current_smoothing * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, current_smoothing * delta)

	move_and_slide()

	# looking
	rotate_y(-_camera_look_input.x * _look_sensitivity)
	camera.rotate_x(-_camera_look_input.y * _look_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)
	_camera_look_input = Vector2.ZERO


	# mouse
	if Input.is_action_just_pressed("toggle_menu"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		_camera_look_input = event.relative
	
