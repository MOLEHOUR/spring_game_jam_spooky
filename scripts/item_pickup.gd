class_name Item extends Area3D

@export var power: float = 10
@export var add_to_inventory: bool = false

func on_pickup():
	queue_free()
