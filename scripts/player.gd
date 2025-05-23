extends CharacterBody2D

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

var direction: Vector2 = Vector2.DOWN

signal encounter_triggered(encountered_minion)
signal interaction_started
signal interaction_finished
var is_interaction_occurring = false

@onready var ray: RayCast2D = $RayCast2D
@onready var camera = $Camera2D
@onready var info_text_box = $Camera2D/Control/InfoTextBox

var interaction_cooldown = false
@onready var cooldown_timer = $CooldownTimer

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE/2

func _physics_process(_delta):
	if moving or is_interaction_occurring:
		return
	if Input.is_action_pressed("move_down"):
		move("move_down")
		direction = Vector2.DOWN
	elif Input.is_action_pressed("move_up"):
		move("move_up")
		direction = Vector2.UP
	elif Input.is_action_pressed("move_left"):
		move("move_left")
		direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		move("move_right")
		direction = Vector2.RIGHT
	elif Input.is_action_just_pressed("accept"):
		ray.target_position = direction * TILE_SIZE
		ray.force_raycast_update()
		if ray.is_colliding():
			var colliding_object = ray.get_collider()
			if !colliding_object.on_interaction == null and not interaction_cooldown:
				colliding_object.on_interaction.call()

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
			if not encounter == Minions.Minion.Minions.None:
				encounter_triggered.emit(encounter)

func check_for_random_encounter() -> Minions.Minion.Minions:
	if Overworld.get_custom_data_at(position, "TallGrassTile"):
		var r = randf() + cumulative_encounter_boost
		for encounter in encounter_list:
			if r > encounter_probabilities[encounter]:
				return encounter
	return Minions.Minion.Minions.None


func _on_interaction_started():
	is_interaction_occurring = true

func _on_interaction_finished():
	is_interaction_occurring = false
	interaction_cooldown = true
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	interaction_cooldown = false
