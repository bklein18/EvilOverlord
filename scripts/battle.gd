extends Node2D

@onready var enemy_name_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyNameLabel
@onready var enemy_level_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyLevelLabel

@onready var player_name_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer2/PlayerNameLabel
@onready var player_level_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer2/PlayerLevelLabel
@onready var player_sprite = $BattleLayout/MarginContainer/Container/PlayerSprite

@onready var camera_2d = $Camera2D
@export var enemy_minions: Array = [Minions.Minion.new()]
@export var player_minions: Array = SceneManager.party
var current_enemy_minion: Minions.Minion = Minions.Minion.new():
	set(new_minion):
		current_enemy_minion = new_minion
		enemy_name_label.text = new_minion.Name
		enemy_level_label.text = "LV. " + str(new_minion.Level)
	get:
		return current_enemy_minion
var current_player_minion: Minions.Minion = player_minions[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	if enemy_minions.size() < 1:
		enemy_minions = [Minions.Minion.new()]
	current_enemy_minion = enemy_minions[0]
	player_name_label.text = current_player_minion.Name
	player_level_label.text = "LV. " + str(current_player_minion.Level)
	player_sprite.texture = load("res://assets/minions/" + current_player_minion.Name + ".png")
	camera_2d.make_current()
	
func set_wild_minion(minion: Minions.Minion):
	current_enemy_minion = minion
