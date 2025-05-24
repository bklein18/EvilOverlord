extends Control

@onready var v_box_container = $MarginContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer
var party: Array = SceneManager.party

var minion_previews: Array
var in_switch_mode = false:
	set(new_value):
		in_switch_mode = new_value
		if not in_switch_mode:
			build_minion_previews()

# Called when the node enters the scene tree for the first time.
func _ready():
	build_minion_previews()
		
func build_minion_previews():
	for child in v_box_container.get_children():
		v_box_container.remove_child(child)
	minion_previews = []
	for minion in party:
		var new_preview = load("res://scenes/ui_elements/minion_preview.tscn").instantiate()
		new_preview.minion = minion
		new_preview.options = {
			"SWITCH": func():
				in_switch_mode = true
				new_preview.context_menu.hide()
				new_preview.button.hide()
				for preview in minion_previews:
					if preview.minion != minion:
						preview.options = {
							"SWITCH WITH " + minion.Name: func():
								swap_minions(minion, preview.minion)
								in_switch_mode = false
						}
		}
		minion_previews.append(new_preview)
		v_box_container.add_child(new_preview)

func swap_minions(minion1, minion2):
	var temp = minion1
	var minion1_idx = party.find(minion1)
	var minion2_idx = party.find(minion2)
	party[minion1_idx] = minion2
	party[minion2_idx] = minion1
	SceneManager.party = party
