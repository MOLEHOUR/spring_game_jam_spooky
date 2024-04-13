extends Node

var scene_dictionary  = {
	"start" : "res://scenes/cole_test_scene.tscn",
	"fail" : "res://Scenes/Settings Menu/settings_menu.tscn",
	"win" : "res://Scenes/World Map/Level/world_map.tscn",
}

signal change_scene_requested

###Changing Scenes

func _ready() -> void:
#Based on signal run function to change the scene
	change_scene_requested.connect(change_scene)
	
func change_scene(scene_name: String) -> void:
	get_tree().change_scene(scene_name)
