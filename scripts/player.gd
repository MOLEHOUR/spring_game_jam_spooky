extends CharacterBody3D

#@onready var camera = $Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#var look_direction: Vector2
#var camera_sens = 50

var is_paused: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("", "", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("left"):
		rotation.y += 4.0 * delta
	if Input.is_action_pressed("right"):
		rotation.y -= 4.0 * delta

	move_and_slide()
	#_rotate_camera(delta)

func _input(event: InputEvent):
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_paused = !is_paused

#func _rotate_camera(delta: float, sens_mod: float = 1.0):
#	if !is_paused:
#		var input = Input.get_vector("look_left","look_right","look_down","look_up")
#		look_direction += input
#		rotation.y -= look_direction.x * camera_sens * delta
#		camera.rotation.x = clamp(camera.rotation.x - look_direction.y * camera_sens * sens_mod * delta,-1.5,1.5)
#		look_direction = Vector2.ZERO