extends Node2D

@onready var enemy_name_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyNameLabel
@onready var enemy_level_label = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/EnemyLevelLabel
@onready var enemy_sprite = $BattleLayout/MarginContainer/EnemySpriteContainer/EnemySprite
@onready var enemy_hp_bar = $BattleLayout/MarginContainer/EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer/ProgressBar

@onready var player_info = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo
@onready var player_name_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer2/PlayerNameLabel
@onready var player_level_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer2/PlayerLevelLabel
@onready var player_sprite = $BattleLayout/MarginContainer/Container/PlayerSprite
@onready var player_hp_label = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/PlayerHPLabel
@onready var player_hp_bar = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer/PlayerHPBar
@onready var xp_bar = $BattleLayout/MarginContainer/VBoxContainer/PlayerInfo/MarginContainer/VBoxContainer/HBoxContainer3/XPBar

@onready var info_text_box = $BattleLayout/MarginContainer/InfoTextBox

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

@onready var item_panel = $BattleLayout/MarginContainer/ItemPanel
@onready var item_back = $BattleLayout/MarginContainer/ItemPanel/Panel/MarginContainer/HBoxContainer/ItemBack
@onready var item_container = $BattleLayout/MarginContainer/ItemPanel/Panel/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer

@onready var item_previews = []

@onready var select_new_minion_box = $BattleLayout/MarginContainer/SelectNewMinionBox
@onready var yes = $BattleLayout/MarginContainer/SelectNewMinionBox/MarginContainer/GridContainer/Yes
@onready var no = $BattleLayout/MarginContainer/SelectNewMinionBox/MarginContainer/GridContainer/No

@onready var camera_2d = $Camera2D
@export var enemy_minions: Array = [Minions.Minion.new()]
@export var player_minions: Array = SceneManager.party
@export var player_inventory: Array = SceneManager.inventory
var current_enemy_minion: Minions.Minion = Minions.Minion.new():
	set(new_minion):
		current_enemy_minion = new_minion
		enemy_name_label.text = new_minion.Name
		enemy_level_label.text = "LV. " + str(new_minion.Level)
		enemy_hp_bar.max_value = current_enemy_minion.Max_Health
		enemy_hp_bar.value = current_enemy_minion.Current_Health
	get:
		return current_enemy_minion
var current_player_minion: Minions.Minion:
	set(new_minion):
		current_player_minion = new_minion
		player_name_label.text = new_minion.Name
		player_level_label.text = "LV. " + str(new_minion.Level)
		player_hp_bar.max_value = current_player_minion.Max_Health
		player_hp_bar.value = current_player_minion.Current_Health
		player_hp_label.text = str(current_player_minion.Current_Health) + "/" + str(current_player_minion.Max_Health)
		xp_bar.min_value = current_player_minion.get_xp_for_level(current_player_minion.Level)
		xp_bar.max_value = current_player_minion.get_xp_for_level(current_player_minion.Level + 1)
		xp_bar.value = current_player_minion.XP
		var other_minions_in_battle = minions_and_xp_share.keys()
		var xp_share: float = 1.0 / (1.0 + float(other_minions_in_battle.size()))
		for minion in other_minions_in_battle:
			minions_and_xp_share[minion] = xp_share
		minions_and_xp_share[current_player_minion] = xp_share

var is_in_submenu := false
var wait_for_input := false

var is_wild_encounter := false

var minions_and_xp_share: Dictionary = {}

var player_hp_amount: int = player_minions[0].Current_Health:
	set(new_value):
		player_hp_amount = new_value if new_value >= 0 else 0
		player_hp_label.text = str(player_hp_amount) + "/" + str(current_player_minion.Max_Health)

var player_turn := false:
	set(new_value):
		await check_for_battle_win()
		if !new_value:
			disable_buttons()
			await enemy_turn()
		else:
			enable_buttons()
			if !player_info.is_visible_in_tree():
				player_info.show()
		player_turn = new_value
	get:
		return player_turn

signal battle_finished

const ANIMATION_SPEED = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	if enemy_minions.size() < 1:
		enemy_minions = [Minions.Minion.new()]
	current_enemy_minion = enemy_minions[0]
	player_info.hide()
	camera_2d.make_current()
	info_text_box.clear()
	
	for item in  player_inventory:
		if item.CurrentQuantity > 0:
			var new_item_preview = load("res://scenes/ui_elements/item_preview.tscn").instantiate()
			new_item_preview.item = item
			item_container.add_child(new_item_preview)
			item_previews.append(new_item_preview)

func set_active_player_minion(to: Minions.Minion):
	disable_buttons()
	await info_text_box.show_text_and_wait_for_input("You sent out " + to.Name + "!")
	if not player_info.is_visible_in_tree():
		player_info.show()
	current_player_minion = to
	player_name_label.text = current_player_minion.Name
	player_level_label.text = "LV. " + str(current_player_minion.Level)
	player_hp_label.text = str(current_player_minion.Current_Health) + "/" + str(current_player_minion.Max_Health)
	player_hp_bar.max_value = current_player_minion.Max_Health
	player_hp_bar.value = current_player_minion.Current_Health
	player_sprite.texture = load("res://assets/minions/" + current_player_minion.Name + ".png")
	enable_buttons()

func enemy_turn():
	var selected_move = current_enemy_minion.Moves[(randi() % current_enemy_minion.Moves.size()) - 1]
	await info_text_box.show_text_and_wait_for_input("Enemy " + current_enemy_minion.Name + " used " + selected_move.name + "!")
	await enemy_move_selected(selected_move)
	player_turn = true
	
func set_wild_minion(minion: Minions.Minion):
	is_wild_encounter = true
	current_enemy_minion = minion
	enemy_sprite.texture = load("res://assets/minions/" + current_enemy_minion.Name + ".png")
	await info_text_box.show_text_and_wait_for_input("A wild " + minion.get_minion_name(minion.EnumVal) + " appeared!")
	var alive_player_minions = player_minions.filter(func(m):
		return m.Current_Health > 0
	)
	await set_active_player_minion(alive_player_minions[0])
	var enemy_speed_roll = (randi() % 100) + current_enemy_minion.Speed
	var player_speed_roll = (randi() % 100) + current_player_minion.Speed
	player_turn = player_speed_roll > enemy_speed_roll

func _on_command_pressed():
	var moves = current_player_minion.Moves
	var move_buttons = [move_1, move_2, move_3, move_4]
	for button in move_buttons:
		button.disabled = false
	
	for index in range(moves.size()):
		move_buttons[index].text = moves[index].name
		move_buttons[index].pressed.connect(player_move_selected.bind(moves[index]))
	
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
		minion_previews[index].options = {
			"SWAP": player_minion_changed
		}
		minion_previews[index].show()
	
	if player_minions.size() < 6:
		for index in range(player_minions.size(), 6):
			minion_previews[index].minion = Minions.Minion.new()
			minion_previews[index].hide()

func _on_minion_back_pressed():
	if not current_player_minion.Current_Health == 0:
		minion_panel.hide()
		enable_buttons()

func _on_item_pressed():
	item_panel.show()
	for item in item_previews:
		item.item_clicked.connect(player_item_selected)

func _on_item_back_pressed():
	item_panel.hide()

func _on_retreat_pressed():
	if !retreat.disabled:
		var enemy_speed_roll = (randi() % 75) + current_enemy_minion.Speed
		var player_speed_roll = (randi() % 100) + current_player_minion.Speed
		if player_speed_roll > enemy_speed_roll:
			await info_text_box.show_text_with_auto_timeout("Got away safely!")
			battle_finished.emit()
		else:
			disable_buttons()
			await info_text_box.show_text_with_auto_timeout("Couldn't get away!")
			player_turn = false

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout

func disable_buttons():
	command.disabled = true
	command.release_focus()
	minions.disabled = true
	minions.release_focus()
	item.disabled = true
	item.release_focus()
	retreat.disabled = true
	retreat.release_focus()

func enable_buttons():
	command.disabled = false
	minions.disabled = false
	item.disabled = false
	retreat.disabled = false

func player_minion_changed(minion: Minions.Minion):
	if current_player_minion == minion:
		info_text_box.show_text_and_wait_for_input(minion.Name + " is already out!")
	elif minion.Current_Health == 0:
		info_text_box.show_text_and_wait_for_input(minion.Name + " is dead!")
	else:
		minion_panel.hide()
		select_new_minion_box.hide()
		await set_active_player_minion(minion)
		player_turn = false

func player_move_selected(move: Minions.Move):
	move_panel.hide()
	control_panel.show()
	disable_buttons()
	var result = current_player_minion.perform(move)
	await info_text_box.show_text_and_wait_for_input(current_player_minion.Name + " used " + move.name + "!")
	match move.category:
		Minions.Move.Category.Attack, Minions.Move.Category.Magic_Attack:
			await damage_enemy(current_enemy_minion, result, move.category)
			await wait(0.5)
		Minions.Move.Category.Defense, Minions.Move.Category.Magic_Defense:
			if result == 0:
				var defense_boost_amt = "up" if move.base_val == 1 else "way up"
				var defense_type = "defense" if move.catergory == Minions.Move.Category.Defense else "magic defense"
				await info_text_box.show_text_and_wait_for_input(current_player_minion.Name + "'s " + defense_type + " went " + defense_boost_amt)
			else:
				var defense_type = "defense" if move.catergory == Minions.Move.Category.Defense else "magic defense"
				await info_text_box.show_text_and_wait_for_input(current_player_minion.Name + "'s " + defense_type + " can't go any higher!")
		Minions.Move.Category.Defense_Debuff, Minions.Move.Category.Magic_Defense_Debuff:
			if result == 0:
				var defense_boost_amt = "down" if move.base_val == 1 else "way down"
				var defense_type = "defense" if move.catergory == Minions.Move.Category.Defense else "magic defense"
				await info_text_box.show_text_and_wait_for_input(current_enemy_minion.Name + "'s " + defense_type + " went " + defense_boost_amt)
			else:
				var defense_type = "defense" if move.catergory == Minions.Move.Category.Defense else "magic defense"
				await info_text_box.show_text_and_wait_for_input(current_enemy_minion.Name + "'s " + defense_type + " can't go any lower!")
		_:
			pass
	player_turn = false

func damage_enemy(minion: Minions.Minion, amount: int, category: Minions.Move.Category):
		var defense_val = minion.adjusted_defense() if category == Minions.Move.Category.Defense else minion.adjusted_magic_defense()
		var tween = create_tween()
		minion.Current_Health -= (amount * (1.0 - (float(100 - defense_val) / 100.0)))
		var new_hp_val = minion.Current_Health
		tween.tween_property(enemy_hp_bar, "value", new_hp_val, ANIMATION_SPEED)
		await tween.finished

func heal_enemy(minion: Minions.Minion, amount: int):
		var tween = create_tween()
		minion.Current_Health += amount
		tween.tween_property(enemy_hp_bar, "value", minion.Current_Health + amount, ANIMATION_SPEED)
		await tween.finished

func enemy_move_selected(move: Minions.Move):
	var result = current_enemy_minion.perform(move)
	match move.category:
		Minions.Move.Category.Attack, Minions.Move.Category.Magic_Attack:
			await damage_player(current_player_minion, result, move.category)
			await wait(0.5)
		Minions.Move.Category.Defense, Minions.Move.Category.Magic_Defense:
			if result == 0:
				var defense_boost_amt = "up" if move.base_val == 1 else "way up"
				var defense_type = "defense" if move.catergory == Minions.Move.Category.Defense else "magic defense"
				await info_text_box.show_text_and_wait_for_input(current_enemy_minion.Name + "'s " + defense_type + " went " + defense_boost_amt)
			else:
				var defense_type = "defense" if move.catergory == Minions.Move.Category.Defense else "magic defense"
				await info_text_box.show_text_and_wait_for_input(current_enemy_minion.Name + "'s " + defense_type + " can't go any higher!")
		Minions.Move.Category.Defense_Debuff, Minions.Move.Category.Magic_Defense_Debuff:
			if result == 0:
				var defense_boost_amt = "down" if move.base_val == 1 else "way down"
				var defense_type = "defense" if move.catergory == Minions.Move.Category.Defense else "magic defense"
				await info_text_box.show_text_and_wait_for_input(current_enemy_minion.Name + "'s " + defense_type + " went " + defense_boost_amt)
			else:
				var defense_type = "defense" if move.catergory == Minions.Move.Category.Defense else "magic defense"
				await info_text_box.show_text_and_wait_for_input(current_enemy_minion.Name + "'s " + defense_type + " can't go any lower!")
		_:
			pass

func damage_player(minion: Minions.Minion, amount: int, category: Minions.Move.Category):
		var defense_val = minion.adjusted_defense() if category == Minions.Move.Category.Defense else minion.adjusted_magic_defense()
		var tween = create_tween()
		minion.Current_Health -= (amount * (1.0 - (float(100 - defense_val) / 100.0)))
		var new_hp_val = minion.Current_Health
		tween.tween_property(player_hp_bar, "value", new_hp_val, ANIMATION_SPEED)
		tween.parallel().tween_property(self, "player_hp_amount", new_hp_val, ANIMATION_SPEED)
		await tween.finished

func heal_player(minion: Minions.Minion, amount: int):
		var tween = create_tween()
		minion.Current_Health += amount
		tween.tween_property(player_hp_bar, "value", minion.Current_Health + amount, ANIMATION_SPEED)
		await tween.finished

func player_item_selected(item: Items.Item):
	item_panel.hide()
	var offset = player_inventory.find(item)
	player_inventory[offset].CurrentQuantity -= 1
	item_previews[offset].item = player_inventory[offset]
	var items_to_pop = []
	for i in player_inventory:
		if i.CurrentQuantity <= 0:
			for index in range(item_previews.size()):
				if item_previews[index].item.Name == i.Name:
					items_to_pop.append(item_previews[index])
	for i in items_to_pop:
		var index = item_previews.find(i)
		item_container.remove_child(i)
		item_previews.pop_at(index)
		player_inventory.pop_at(index)
	await info_text_box.show_text_and_wait_for_input("You used " + item.Name + "!")
	enable_buttons()
	player_turn = false

func check_for_battle_win():
	disable_buttons()
	var player_minion_hp_above_zero = player_minions.filter(func(minion):
		return minion.Current_Health > 0
	)
	if current_enemy_minion.Current_Health == 0:
		await info_text_box.show_text_and_wait_for_input(current_enemy_minion.Name + " was killed!")
		if is_wild_encounter:
			var xp_gain = current_enemy_minion.Base_XP_Yield * current_enemy_minion.Level
			for minion in minions_and_xp_share.keys():
				var actual_xp: int = xp_gain * minions_and_xp_share[minion]
				await info_text_box.show_text_and_wait_for_input(minion.Name + " gained " + str(actual_xp) + " XP!")
				var tween = create_tween()
				tween.tween_property(xp_bar, "value", minion.XP + actual_xp, 0.5)
				await tween.finished
				await wait(1.0)
				await info_text_box.show_text_with_auto_timeout("You won the fight!")
				minion.XP += actual_xp
		if current_player_minion.Current_Health == 0 and player_minion_hp_above_zero.size() > 0:
			show_select_new_minion_box()
		else:
			battle_finished.emit()
	if current_player_minion.Current_Health == 0 and player_minion_hp_above_zero.size() > 0:
		show_select_new_minion_box()

func show_select_new_minion_box():
	await info_text_box.show_text_and_wait_for_input(current_player_minion.Name + " was killed!")
	info_text_box.show_text_and_wait_for_input("Send next minion?")
	select_new_minion_box.show()

func _on_yes_pressed():
	_on_minions_pressed()

func _on_no_pressed():
	if is_wild_encounter:
		var enemy_speed_roll = (randi() % 75) + current_enemy_minion.Speed
		var player_speed_roll = (randi() % 100) + current_player_minion.Speed
		if player_speed_roll > enemy_speed_roll:
			await info_text_box.show_text_with_auto_timeout("Got away safely!")
			battle_finished.emit()
		else:
			disable_buttons()
			await info_text_box.show_text_with_auto_timeout("Couldn't get away!")
			_on_minions_pressed()
