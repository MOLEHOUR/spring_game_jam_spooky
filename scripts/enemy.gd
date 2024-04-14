extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var collision_shape_3d = $CollisionShape3D

var _nest = null
var _player = null

var new_velocity
var SPEED = 3.0

func _physics_process(_delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	new_velocity = (next_location - current_location).normalized() * SPEED
	#look_at(Vector3(nav_agent.target_position.global_position.x, global_position.y, nav_agent.target_position.global_position.z), Vector3.UP)
	velocity = new_velocity
	move_and_slide()
	nav_agent.set_velocity(new_velocity)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Player":
			get_tree().change_scene_to_file("res://scenes/mainLevel.tscn")
#gets target location	
func update_target_location(player, nest):
	nav_agent.target_position = player.global_transform.origin
	_player = player
	_nest = nest
	#_player.enemy_exited.connect(flashlight_stuff)
	#print_debug(nav_agent.target_position)

#pipeline for interactions
	
func _ready():
	set_physics_process(false)
	call_deferred("actor_setup")
func actor_setup():
	await get_tree().physics_frame
	set_physics_process(true)

