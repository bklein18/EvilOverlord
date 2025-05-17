extends CharacterBody2D

const TILE_SIZE: int = 32
const INPUTS = {"move_right": Vector2.RIGHT,
				"move_left": Vector2.LEFT,
				"move_up": Vector2.UP,
				"move_down": Vector2.DOWN}
const ANIMATION_SPEED: int = 3

var moving: bool = false

@onready var ray: RayCast2D = $RayCast2D

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE/2

func _physics_process(_delta):
	if moving:
		return
	if Input.is_action_pressed("move_down"):
		move("move_down")
	elif Input.is_action_pressed("move_up"):
		move("move_up")
	elif Input.is_action_pressed("move_left"):
		move("move_left")
	elif Input.is_action_pressed("move_right"):
		move("move_right")

func move(dir: String):
	ray.target_position = INPUTS[dir] * TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(self, "position",
		position + INPUTS[dir] * TILE_SIZE, 1.0/ANIMATION_SPEED).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false
