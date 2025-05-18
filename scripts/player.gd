extends CharacterBody2D

const M = preload("res://scripts/minions.gd")

const TILE_SIZE: int = 32
const INPUTS = {"move_right": Vector2.RIGHT,
				"move_left": Vector2.LEFT,
				"move_up": Vector2.UP,
				"move_down": Vector2.DOWN}
const ANIMATION_SPEED: int = 3

var moving: bool = false

var cumulative_encounter_boost: float = 0.0

var encounter_list
var encounter_probabilities

signal encounter_triggered(encountered_minion)

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
	if self.is_visible_in_tree():
		ray.target_position = INPUTS[dir] * TILE_SIZE
		ray.force_raycast_update()
		if !ray.is_colliding():
			var tween = create_tween()
			tween.tween_property(self, "position",
			position + INPUTS[dir] * TILE_SIZE, 1.0/ANIMATION_SPEED).set_trans(Tween.TRANS_LINEAR)
			moving = true
			await tween.finished
			moving = false
			var encounter = check_for_random_encounter()
			if not encounter == M.Minion.Minions.None:
				encounter_triggered.emit(encounter)

func check_for_random_encounter() -> M.Minion.Minions:
	if Overworld.get_custom_data_at(position, "TallGrassTile"):
		var r = randf() + cumulative_encounter_boost
		for encounter in encounter_list:
			if r > encounter_probabilities[encounter]:
				return encounter
	return M.Minion.Minions.None
