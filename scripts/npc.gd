extends StaticBody2D

@export var sprite_texture: Texture2D:
	set(new_value):
		sprite_texture = new_value
		if !sprite_2d == null:
			sprite_2d.texture = new_value
@export var on_interaction: Callable

@onready var sprite_2d = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = sprite_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
