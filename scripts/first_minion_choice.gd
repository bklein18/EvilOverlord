extends Control

@onready var info_text_box = $MarginContainer/InfoTextBox
@onready var yes_no_box = $MarginContainer/YesNoBox

signal minion_chosen(minion: Minions.Minion.Minions)

func _on_dave_pressed():
	if not yes_no_box.is_visible_in_tree() and not info_text_box.is_visible_in_tree():
		await info_text_box.show_text_and_wait_for_input("What's that? You want Dave, the Bandit?")
		yes_no_box.show()
		yes_no_box.choice.connect(func (choice):
			if choice:
				minion_chosen.emit(Minions.Minion.Minions.Dave)
			else:
				yes_no_box.hide()
		)

func _on_zulio_pressed():
	if not yes_no_box.is_visible_in_tree() and not info_text_box.is_visible_in_tree():
		await info_text_box.show_text_and_wait_for_input("What's that? You want Zulio, the Imp?")
		yes_no_box.show()
		yes_no_box.choice.connect(func (choice):
			if choice:
				minion_chosen.emit(Minions.Minion.Minions.Zulio)
			else:
				yes_no_box.hide()
		)

func _on_skelly_pressed():
	if not yes_no_box.is_visible_in_tree() and not info_text_box.is_visible_in_tree():
		await info_text_box.show_text_and_wait_for_input("What's that? You want Skelly, the Skeleton?")
		yes_no_box.show()
		yes_no_box.choice.connect(func (choice):
			if choice:
				minion_chosen.emit(Minions.Minion.Minions.Dave)
			else:
				yes_no_box.hide()
		)
