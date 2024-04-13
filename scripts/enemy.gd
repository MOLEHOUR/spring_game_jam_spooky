extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 3.0

func _physics_process(_delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	#look_at(Vector3(nav_agent.target_position.global_position.x, global_position.y, nav_agent.target_position.global_position.z), Vector3.UP)
	velocity = new_velocity
	move_and_slide()
	nav_agent.set_velocity(new_velocity)
	
#gets target location	
func update_target_location(target_location):
	nav_agent.target_position = target_location
	#print_debug(nav_agent.target_position)

#pipeline for interactions
func _on_navigation_agent_3d_target_reached():
	print("in range")
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
	
	
func _ready():
	set_physics_process(false)
	call_deferred("actor_setup")
func actor_setup():
	await get_tree().physics_frame
	set_physics_process(true)

