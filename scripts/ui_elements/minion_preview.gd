extends MarginContainer

class_name MinionPreview

var minion: Minions.Minion = Minions.Minion.new():
	set(new_minion):
		minion = new_minion
		if self.is_visible_in_tree():
			var minion_name_str = "res://assets/minions/" + minion.Name + ".png"
			sprite.texture = load(minion_name_str)
			minion_name.text = minion.Name
			hp_label.text = str(minion.Current_Health) + "/" + str(minion.Max_Health)
			progress_bar.value = minion.Current_Health
			progress_bar.max_value = minion.Max_Health
			xp_bar.min_value = minion.get_xp_for_level(minion.Level)
			xp_bar.max_value = minion.get_xp_for_level(minion.Level + 1)
			xp_bar.value = minion.XP
			level_label.text = "LV. " + str(minion.Level)

@onready var sprite = $VBoxContainer/HBoxContainer/Control/Sprite2D
@onready var minion_name: Label = $VBoxContainer/HBoxContainer/MinionName
@onready var hp_label: Label = $VBoxContainer/HBoxContainer/HPLabel
@onready var progress_bar = $VBoxContainer/HBoxContainer/ProgressBar
@onready var xp_bar = $VBoxContainer/MarginContainer/HBoxContainer2/XPBar
@onready var level_label = $VBoxContainer/MarginContainer/HBoxContainer2/MarginContainer2/LevelLabel
@onready var context_menu = $ContextMenu
@onready var option_container = $ContextMenu/PanelContainer/MarginContainer/OptionContainer
@onready var button = $VBoxContainer/HBoxContainer/Button

# should map text to callables
@export var options: Dictionary
var option_buttons: Array

func _ready():
	var minion_name_str = "res://assets/minions/" + minion.Name + ".png"
	sprite.texture = load(minion_name_str)
	minion_name.text = minion.Name
	hp_label.text = str(minion.Current_Health) + "/" + str(minion.Max_Health)
	progress_bar.value = minion.Current_Health
	progress_bar.max_value = minion.Max_Health
	xp_bar.min_value = minion.get_xp_for_level(minion.Level)
	xp_bar.max_value = minion.get_xp_for_level(minion.Level + 1)
	xp_bar.value = minion.XP
	level_label.text = "LV. " + str(minion.Level)
	
func _process(_delta):
	if Input.is_action_just_pressed("menu_back"):
		context_menu.hide()

func _on_button_pressed():
	for key in options.keys():
		var new_button = Button.new()
		new_button.text = key
		new_button.theme = load("res://assets/game_theme.tres")
		new_button.pressed.connect(options[key])
		option_buttons.append(new_button)
		option_container.add_child(new_button)
	context_menu.show()
