extends Control

class_name MinionPreview

var minion: Minions.Minion = Minions.Minion.new():
	set(new_minion):
		minion = new_minion
		var minion_name_str = "res://assets/minions/" + minion.Name + ".png"
		sprite.texture = load(minion_name_str)
		minion_name.text = minion.Name
		hp_label.text = str(minion.Current_Health) + "/" + str(minion.Max_Health)
		progress_bar.value = minion.Current_Health
		progress_bar.max_value = minion.Max_Healtha
@onready var sprite = $MarginContainer/HBoxContainer/Control/Sprite2D
@onready var minion_name: Label = $MarginContainer/HBoxContainer/MinionName
@onready var hp_label: Label = $MarginContainer/HBoxContainer/HPLabel
@onready var progress_bar = $MarginContainer/HBoxContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = load("res://assets/minions/" + minion.Name + ".png")
	minion_name.text = minion.Name
	hp_label.text = str(minion.Current_Health) + "/" + str(minion.Max_Health)
	progress_bar.value = minion.Current_Health
	progress_bar.max_value = minion.Max_Health
