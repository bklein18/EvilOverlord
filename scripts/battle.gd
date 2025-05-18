extends Node2D
const M = preload("res://scripts/minions.gd")

@onready var enemy_name_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyNameLabel
@onready var enemy_level_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyLevelLabel

@onready var camera_2d = $Camera2D
@export var enemy_minions: Array = [M.Minion.new()]
@export var player_minions: Array
var current_minion: M.Minion = M.Minion.new():
	set(new_minion):
		current_minion = new_minion
		enemy_name_label.text = new_minion.Name
		enemy_level_label.text = "LV. " + str(new_minion.Level)
	get:
		return current_minion

# Called when the node enters the scene tree for the first time.
func _ready():
	if enemy_minions.size() < 1:
		enemy_minions = [M.Minion.new()]
	current_minion = enemy_minions[0]
	camera_2d.make_current()
	
func set_wild_minion(minion: M.Minion):
	current_minion = minion
