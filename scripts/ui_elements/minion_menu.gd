extends Control

@onready var v_box_container = $MarginContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer
var party: Array = SceneManager.party

var minion_previews: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for minion in party:
		var new_preview = load("res://scenes/ui_elements/minion_preview.tscn").instantiate()
		new_preview.minion = minion
		new_preview.minion_clicked.connect(player_minion_selected)
		minion_previews.append(new_preview)
		v_box_container.add_child(new_preview)

func player_minion_selected(minion: Minions.Minion):
	print("here")
