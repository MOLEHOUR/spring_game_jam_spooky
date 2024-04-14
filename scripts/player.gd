extends CharacterBody3D

@onready var flashlight = $Camera3D/Flashlight
@onready var raycast = $Camera3D/RayCast3D
@onready var key_label = $"Camera3D/Flashlight/UI/key label"
@onready var flashlight_area = $"Camera3D/Flashlight/Flashlight Area"
@onready var prompt_label = $"Camera3D/Flashlight/UI/prompt label"
@onready var pause_menu = $"Pause Menu"

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_paused: bool = false

var key_count: int = 0

signal enemy_entered
signal enemy_exited

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_key_ui()
	prompt_label.text = " "
	pause_menu.hide()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
	if direction  && !is_paused:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("left") && !is_paused:
		rotation.y += 4.0 * delta
	if Input.is_action_pressed("right") && !is_paused:
		rotation.y -= 4.0 * delta

	move_and_slide()
	
	if raycast.is_colliding() && !is_paused:
		if raycast.get_collider() == null:
			pass
		else:
			if raycast.get_collider().is_in_group("Item"):
				prompt_label.text = "[center]Press [E] to pick up[/center]"
			elif raycast.get_collider().is_in_group("Door"):
				if raycast.get_collider().keys_required > key_count:
					prompt_label.text = "[center]Not enough keys![/center]"
				else:
					prompt_label.text = "[center]Press [E] to enter[/center]"
	else:
		prompt_label.text = " "

func _input(event: InputEvent):
	#Handle pausing
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			unpause()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_menu.show()
			pause_menu.focus()
			is_paused = true

	if Input.is_action_just_pressed("flashlight") && !is_paused:
		flashlight.toggle_flashlight()
	if Input.is_action_just_pressed("interact") && !is_paused:
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("Item"):
				var item = raycast.get_collider()
				if item.power > 0:
					flashlight.change_power(item.power)
				if item.is_key:
					key_count += 1
					update_key_ui()
				item.on_pickup()
			elif raycast.get_collider().is_in_group("Door"):
				var door = raycast.get_collider()
				if key_count >= door.keys_required:
					door.unlock()
				else:
					print("need more keys!")

func unpause():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause_menu.hide()
	is_paused = false

func update_key_ui():
	key_label.text = " Keys: " + str(key_count)

func _on_flashlight_area_body_entered(body):
	if body.is_in_group("enemy"):
		enemy_entered.emit()

func _on_flashlight_area_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_exited.emit()
