extends Node2D

@onready var enemy_name_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyNameLabel
@onready var enemy_level_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyLevelLabel
@onready var enemy_sprite = $BattleLayout/MarginContainer/EnemySpriteContainer/EnemySprite

@onready var player_name_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer2/PlayerNameLabel
@onready var player_level_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer2/PlayerLevelLabel
@onready var player_sprite = $BattleLayout/MarginContainer/Container/PlayerSprite
@onready var player_hp_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/PlayerHPLabel
@onready var player_hp_bar = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer/PlayerHPBar

@onready var info_text_box = $BattleLayout/MarginContainer/InfoTextBox
@onready var info_text = $BattleLayout/MarginContainer/InfoTextBox/MarginContainer/HBoxContainer/InfoText
@onready var arrow_prompt = $BattleLayout/MarginContainer/InfoTextBox/MarginContainer/HBoxContainer/RichTextLabel

@onready var control_panel = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel
@onready var command = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel/MarginContainer/GridContainer/Command
@onready var minions = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel/MarginContainer/GridContainer/Minions
@onready var item = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel/MarginContainer/GridContainer/Item
@onready var retreat = $BattleLayout/MarginContainer/VBoxContainer/ControlPanel/MarginContainer/GridContainer/Retreat

@onready var move_panel = $BattleLayout/MarginContainer/VBoxContainer/MovePanel
@onready var move_1 = $BattleLayout/MarginContainer/VBoxContainer/MovePanel/MarginContainer/HBoxContainer/GridContainer/Move1
@onready var move_2 = $BattleLayout/MarginContainer/VBoxContainer/MovePanel/MarginContainer/HBoxContainer/GridContainer/Move2
@onready var move_3 = $BattleLayout/MarginContainer/VBoxContainer/MovePanel/MarginContainer/HBoxContainer/GridContainer/Move3
@onready var move_4 = $BattleLayout/MarginContainer/VBoxContainer/MovePanel/MarginContainer/HBoxContainer/GridContainer/Move4

@onready var minion_panel = $BattleLayout/MarginContainer/MinionPanel
@onready var minion_preview = $BattleLayout/MarginContainer/MinionPanel/Panel/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer/MinionPreview
@onready var minion_preview_2 = $BattleLayout/MarginContainer/MinionPanel/Panel/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer/MinionPreview2
@onready var minion_preview_3 = $BattleLayout/MarginContainer/MinionPanel/Panel/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer/MinionPreview3
@onready var minion_preview_4 = $BattleLayout/MarginContainer/MinionPanel/Panel/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer/MinionPreview4
@onready var minion_preview_5 = $BattleLayout/MarginContainer/MinionPanel/Panel/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer/MinionPreview5
@onready var minion_preview_6 = $BattleLayout/MarginContainer/MinionPanel/Panel/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer/MinionPreview6

@onready var minion_previews = [minion_preview, minion_preview_2, minion_preview_3, minion_preview_4, minion_preview_5, minion_preview_6]

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
	player_hp_label.text = str(current_player_minion.Current_Health) + "/" + str(current_player_minion.Max_Health)
	player_hp_bar.max_value = current_player_minion.Max_Health
	player_hp_bar.value = current_player_minion.Current_Health
	player_sprite.texture = load("res://assets/minions/" + current_player_minion.Name + ".png")
	camera_2d.make_current()
	info_text.text = ""
	arrow_prompt.hide()
	
func _input(event):
	if event.is_action_pressed("accept"):
		player_input.emit()

func set_wild_minion(minion: Minions.Minion):
	current_enemy_minion = minion
	enemy_sprite.texture = load("res://assets/minions/" + current_enemy_minion.Name + ".png")
	show_text_and_wait_for_input("A wild " + minion.get_minion_name(minion.EnumVal) + " appeared!")

func _on_command_pressed():
	var moves = current_player_minion.Moves
	var move_buttons = [move_1, move_2, move_3, move_4]
	for button in move_buttons:
		button.disabled = false
	
	for index in range(moves.size()):
		move_buttons[index].text = moves[index].name
	
	if moves.size() < 4:
		for index in range(moves.size(), 4):
			move_buttons[index].text = "DEFAULT"
			move_buttons[index].disabled = true
		
	control_panel.hide()
	disable_buttons()
	move_panel.show()

func _on_move_back_pressed():
	move_panel.hide()
	enable_buttons()
	control_panel.show()

func _on_minions_pressed():
	minion_panel.show()
	for index in range(player_minions.size()):
		minion_previews[index].minion = player_minions[index]
		minion_previews[index].show()
	
	if player_minions.size() < 6:
		for index in range(player_minions.size(), 6):
			minion_previews[index].minion = Minions.Minion.new()
			minion_previews[index].hide()

func _on_minion_back_pressed():
	minion_panel.hide()

func _on_item_pressed():
	pass # Replace with function body.

func _on_retreat_pressed():
	if !retreat.disabled:
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
