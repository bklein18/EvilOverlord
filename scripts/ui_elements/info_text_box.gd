extends PanelContainer

@onready var info_text_box = $"."
@onready var info_text = $MarginContainer/HBoxContainer/InfoText
@onready var arrow_prompt = $MarginContainer/HBoxContainer/ArrowPrompt

signal player_input
signal info_finished_showing

func _input(event):
	if event.is_action_pressed("accept"):
		player_input.emit()

func clear():
	info_text.text = ""
	self.hide()

func show_text_with_auto_timeout(text: String):
	info_text_box.show()
	arrow_prompt.hide()
	info_text.text = text
	await wait(2.5)
	info_text_box.hide()
	info_text.text = ""

func show_text_and_wait_for_input(text: String):
	info_text_box.show()
	arrow_prompt.show()
	info_text.text = text
	await player_input
	info_text_box.hide()
	info_text.text = ""

func wait(seconds: float):
	await get_tree().create_timer(seconds).timeout
