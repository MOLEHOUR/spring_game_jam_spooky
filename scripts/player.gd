extends CharacterBody3D

#@onready var camera = $Camera3D
#var look_direction: Vector2
#var camera_sens = 50

@onready var flashlight = $Camera3D/Flashlight
@onready var raycast = $Camera3D/RayCast3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_paused: bool = false

var key_count: int = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
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

func _input(event: InputEvent):
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_paused = !is_paused
	if Input.is_action_just_pressed("flashlight"):
		flashlight.toggle_flashlight()
	if Input.is_action_just_pressed("interact"):
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("Item"):
				var item = raycast.get_collider()
				if item.power > 0:
					flashlight.change_power(item.power)
				if item.is_key:
					key_count += 1
					print("Keys: " + str(key_count))
				item.on_pickup()
	
	#For debugging
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_R:
			flashlight.change_power(10.0)



#func _rotate_camera(delta: float, sens_mod: float = 1.0):
#	if !is_paused:
#		var input = Input.get_vector("look_left","look_right","look_down","look_up")
#		look_direction += input
#		rotation.y -= look_direction.x * camera_sens * delta
#		camera.rotation.x = clamp(camera.rotation.x - look_direction.y * camera_sens * sens_mod * delta,-1.5,1.5)
#		look_direction = Vector2.ZERO
