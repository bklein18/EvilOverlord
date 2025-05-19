extends MarginContainer

class_name MinionPreview

var minion: Minions.Minion = Minions.Minion.new():
	set(new_minion):
		minion = new_minion
		var minion_name_str = "res://assets/minions/" + minion.Name + ".png"
		sprite.texture = load(minion_name_str)
		minion_name.text = minion.Name
		hp_label.text = str(minion.Current_Health) + "/" + str(minion.Max_Health)
		progress_bar.value = minion.Current_Health
		progress_bar.max_value = minion.Max_Health

@onready var sprite = $HBoxContainer/Control/Sprite2D
@onready var minion_name: Label = $HBoxContainer/MinionName
@onready var hp_label: Label = $HBoxContainer/HPLabel
@onready var progress_bar = $HBoxContainer/ProgressBar
	
signal minion_clicked(minion: Minions.Minion)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			minion_clicked.emit(minion)
