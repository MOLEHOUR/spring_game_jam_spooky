extends Area3D

@onready var lights = $"../Lights"
@onready var enemy = $"../Monster"
@onready var chair = $"../chair"
@onready var door = $"../EndDoor"
@onready var music = $"../AudioStreamPlayer"

var on = false

func unlock():
	if !on:
		lights.visible = true
		chair.visible = true
		door.visible = true
		music.stop()
		enemy.queue_free()
		on = true
