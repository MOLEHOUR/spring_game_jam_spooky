extends Node3D

@onready var light = $SpotLight3D
@onready var timer = $Timer

var on: bool = true
var has_power: bool = true
var default_energy: float = 10.0

func _ready():
	timer.start()

func toggle_flashlight():
	if has_power:
		if on:
			light.light_energy = 0
			timer.set_paused(true)
		else:
			light.light_energy = default_energy
			timer.set_paused(false)
		on = !on
	else:
		print("out of battery!")

func _on_timer_timeout():
	has_power = false
	on = false
	light.light_energy = 0
	print("ran out of battery")
