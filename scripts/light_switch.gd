extends StaticBody3D

@export var keys_required: int = 0
@onready var directional_light_3d = $"../DirectionalLight3D"
@onready var enemy = $"../enemy"

func unlock():
	directional_light_3d.visible = true
	enemy.queue_free()
