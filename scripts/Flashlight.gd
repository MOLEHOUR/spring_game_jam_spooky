extends Node3D

@onready var light = $SpotLight3D
@onready var timer = $Timer
@onready var battery_label = $"UI/battery label"

var on: bool = true
var has_power: bool = true
var default_light_energy: float = 10.0
var max_power: float = 100.0

func _ready():
	timer.set_wait_time(max_power)
	timer.start()

func _process(_delta):
	battery_label.text = (" Battery: " + str(round((round(timer.get_time_left())/max_power)*100)) + "%")

func toggle_flashlight():
	if has_power:
		if on:
			light.light_energy = 0
			timer.set_paused(true)
		else:
			light.light_energy = default_light_energy
			timer.set_paused(false)
		on = !on
	else:
		#Ran out of power!
		pass

func change_power(power: float):
	var current_time = timer.get_time_left()
	if ((current_time + power) > max_power):
		timer.set_wait_time(max_power)
	elif ((current_time + power) < 0):
		timer.set_wait_time(1)
	else:
		timer.set_wait_time(current_time+power)
	
	timer.start()
	
	if !has_power && power > 0:
		regain_power()

func _on_timer_timeout():
	has_power = false
	on = false
	light.light_energy = 0

func regain_power():
	has_power = true
	on = false
	toggle_flashlight()
	
