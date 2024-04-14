extends Control

@onready var restart = $VBoxContainer/Restart

func _ready():
	focus()

func _on_restart_button_down():
	get_tree().change_scene_to_file("res://scenes/mainLevel.tscn")

func _on_quit_button_down():
	#Go to main menu
	get_tree().change_scene_to_file("res://scenes/cole_test_scene.tscn") #repalce with main menu

func focus():
	restart.grab_focus()
