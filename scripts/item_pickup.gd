class_name Item extends Area3D

@onready var sprite = $Sprite3D

@export var power: float = 10
@export var is_key: bool = false
@export var texture: Texture2D
@export var default_texture: Texture2D

func _ready():
	if texture == null:
		sprite.texture = default_texture
	else:
		sprite.texture = texture

func on_pickup():
	queue_free()
