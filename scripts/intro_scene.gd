extends Node2D

@onready var info_text_box = $Control/MarginContainer/InfoTextBox
@onready var animation_player = $AnimationPlayer
@onready var first_minion_choice = $Control/FirstMinionChoice

# Called when the node enters the scene tree for the first time.
func _ready():
	await info_text_box.wait(2.5)
	var text_lines = [
		"Oh, my dearest grandson,\nyou're already 10 years old!",
		"Why, I was your age when I\nset out to conquer the world...",
		"I didn't get the whole world,\nof course, but a healthy portion, ha!",
		"What's that? You want to\nconquer the world also?",
		"Oh I believe in you, boyo,\nbut that's going to be hard to do\nwithout any minions.",
		"Tell you what, I'll give you\none of my old minions.",
		"Most of them are retired,\nbut I've got a few for you to choose from.",
		"Which one would you like?"
	]
	for line in text_lines:
		await info_text_box.show_text_and_wait_for_input(line)
		await info_text_box.wait(0.1)
	first_minion_choice.show()
	first_minion_choice.minion_chosen.connect(func(chosen_minion):
		first_minion_choice.hide()
		var starter = Minions.wild_minion_from_enum(chosen_minion)
		SceneManager.party = [starter]
		var final_text_lines = [
			"Ah, good choice! I always loved " + starter.Name + "!",
			"But, one minion is never enough!",
			"You'll need to venture into\nthe world and find more!",
			"Good luck, boyo. I believe in you!"
		]
		for line in final_text_lines:
			await info_text_box.show_text_and_wait_for_input(line)
			await info_text_box.wait(0.1)
		animation_player.play("IntroCutscene")
		await animation_player.animation_finished
		SceneManager.current_base_scene = load("res://scenes/Overworld.tscn")
		get_tree().change_scene_to_packed(SceneManager.current_base_scene)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
