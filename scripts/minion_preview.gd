extends Control

var minion: Minions.Minion = Minions.Minion.new():
	set(new_minion):
		minion = new_minion
		sprite.texture = load("res://assets/minions/" + minion.Name + ".png")
		minion_name = minion.Name
		hp_label = str(minion.Current_Health) + "/" + str(minion.Max_Health)
		progress_bar.value = minion.Current_Health
		progress_bar.max_value = minion.Max_Health
@onready var sprite = $MarginContainer/HBoxContainer/Control/Sprite2D
@onready var minion_name = $MarginContainer/HBoxContainer/MinionName
@onready var hp_label = $MarginContainer/HBoxContainer/HPLabel
@onready var progress_bar = $MarginContainer/HBoxContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = load("res://assets/minions/" + minion.Name + ".png")
	minion_name = minion.Name
	hp_label = str(minion.Current_Health) + "/" + str(minion.Max_Health)
	progress_bar.value = minion.Current_Health
	progress_bar.max_value = minion.Max_Health
