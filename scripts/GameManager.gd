extends Node3D

@onready var player = $Player
@onready var nest = $nest

func _physics_process(delta):
	get_tree().call_group("enemy", "update_target_location", player, nest)
