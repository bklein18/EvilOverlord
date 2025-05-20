extends MarginContainer

class_name ItemPreview

var item: Items.Item = Items.Item.new():
	set(new_item):
		item = new_item
		var item_name_str = "res://assets/minions/" + item.Name + ".png"
		if not item_name == null:
			item_name.text = item.Name
		if not quantity_available == null:
			quantity_available.text = str(item.CurrentQuantity) + "x"

@onready var item_name: Label = $HBoxContainer/ItemName
@onready var quantity_available: Label = $HBoxContainer/QuantityAvailable
	
signal item_clicked(item: Items.Item)

func _ready():
	if not item_name == null:
		item_name.text = item.Name
	if not quantity_available == null:
		quantity_available.text = str(item.CurrentQuantity) + "x"

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			item_clicked.emit(item)
