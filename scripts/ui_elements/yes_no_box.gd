extends PanelContainer

signal choice(yes: bool)

func _on_yes_pressed():
	choice.emit(true)
	self.hide()

func _on_no_pressed():
	choice.emit(false)
	self.hide()
