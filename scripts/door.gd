extends StaticBody3D

@export var keys_required: int = 3

func unlock():
	#Load final scene
	get_tree().change_scene_to_file("res://scenes/win.tscn")
