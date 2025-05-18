extends Node2D

@onready var enemy_name_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyNameLabel
@onready var enemy_level_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyLevelLabel

@onready var player_name_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer2/PlayerNameLabel
@onready var player_level_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer2/PlayerLevelLabel
@onready var player_sprite = $BattleLayout/MarginContainer/Container/PlayerSprite

@onready var info_text_box = $BattleLayout/MarginContainer/InfoTextBox
@onready var info_text = $BattleLayout/MarginContainer/InfoTextBox/MarginContainer/HBoxContainer/InfoText
@onready var arrow_prompt = $BattleLayout/MarginContainer/InfoTextBox/MarginContainer/HBoxContainer/RichTextLabel

@onready var command = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel/MarginContainer/GridContainer/Command
@onready var minions = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel/MarginContainer/GridContainer/Minions
@onready var item = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel/MarginContainer/GridContainer/Item
@onready var retreat = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel/MarginContainer/GridContainer/Retreat

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

var is_in_submenu := false
var wait_for_input := false

var player_turn := false

signal battle_finished
signal player_input

# Called when the node enters the scene tree for the first time.
func _ready():
	if enemy_minions.size() < 1:
		enemy_minions = [Minions.Minion.new()]
	current_enemy_minion = enemy_minions[0]
	player_name_label.text = current_player_minion.Name
	player_level_label.text = "LV. " + str(current_player_minion.Level)
	player_sprite.texture = load("res://assets/minions/" + current_player_minion.Name + ".png")
	camera_2d.make_current()
	info_text.text = ""
	arrow_prompt.hide()
	
func _input(event):
	if event.is_action_pressed("accept"):
		player_input.emit()

func set_wild_minion(minion: Minions.Minion):
	current_enemy_minion = minion
	show_text_and_wait_for_input("A wild " + minion.get_minion_name(minion.EnumVal) + " appeared!")

func _on_command_pressed():
	pass # Replace with function body.

func _on_minions_pressed():
	pass # Replace with function body.

func _on_item_pressed():
	pass # Replace with function body.

func _on_retreat_pressed():
	var enemy_speed_roll = (randi() % 10) + current_enemy_minion.Speed
	var player_speed_roll = (randi() % 15) + current_player_minion.Speed
	if player_speed_roll > enemy_speed_roll:
		await show_text_with_auto_timeout("Got away safely!")
		battle_finished.emit()
	else:
		await show_text_with_auto_timeout("Couldn't get away!")

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func show_text_with_auto_timeout(text: String):
	disable_buttons()
	info_text_box.show()
	info_text.text = text
	await wait(2.5)
	info_text_box.hide()
	enable_buttons()
	info_text.text = ""
	
func show_text_and_wait_for_input(text: String):
	disable_buttons()
	info_text_box.show()
	arrow_prompt.show()
	info_text.text = text
	await player_input
	arrow_prompt.hide()
	info_text_box.hide()
	enable_buttons()
	info_text.text = ""
	

func disable_buttons():
	command.disabled = true
	minions.disabled = true
	item.disabled = true
	retreat.disabled = true

func enable_buttons():
	command.disabled = false
	minions.disabled = false
	item.disabled = false
	retreat.disabled = false
