extends Node3D

@onready var light = $SpotLight3D
@onready var time = $Timer

var on: bool = true
var has_power: bool = true
var default_energy: float = 10.0

func toggle_flashlight():
	if has_power:
		if on:
			light.light_energy = 0
		else:
			light.light_energy = default_energy
		on = !on
	else:
		print("out of battery")
