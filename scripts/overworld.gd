extends Node2D
class_name Overworld

@onready var tall_grass = $TallGrass
@onready var player = $Player
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var necromancer = $Necromancer

static var _instance: Overworld = null

const encounter_list := [
	Minions.Minion.Minions.Phyll,
	Minions.Minion.Minions.Eemini,
	Minions.Minion.Minions.Bear
]

const encounter_probabilities := {
	Minions.Minion.Minions.Phyll: 0.95,
	Minions.Minion.Minions.Eemini: 0.90,
	Minions.Minion.Minions.Bear: 0.85
}

var is_interaction_occurring = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_instance = self if _instance == null else _instance
	
	player.encounter_list = encounter_list
	player.encounter_probabilities = encounter_probabilities
	
	necromancer.on_interaction = func():
		if not is_interaction_occurring:
			is_interaction_occurring = true
			player.interaction_started.emit
		else:
			return
		var damaged_minions = SceneManager.party.filter(func(minion):
				return minion.Current_Health < minion.Max_Health
		)
		if damaged_minions.size() > 0:
			await player.info_text_box.show_text_and_wait_for_input("Oh no!")
			await player.info_text_box.show_text_and_wait_for_input("You seem to have some damaged minions.")
			await player.info_text_box.show_text_with_auto_timeout("Let me bring them back to their (mostly) normal selves")
			for minion in SceneManager.party:
				minion.Current_Health = minion.Max_Health
			await player.info_text_box.show_text_and_wait_for_input("There, all healed! Don't hesitate to come back!")
			is_interaction_occurring = false
		else:
			await player.info_text_box.show_text_and_wait_for_input("Oh no! Your minions are all healthy.")
			await player.info_text_box.show_text_and_wait_for_input("Come back if you need to bring them back to life")
			is_interaction_occurring = false
		player.interaction_finished.emit()
		

static func get_tile_data_at(position: Vector2) -> TileData:
	var local_position: Vector2 = _instance.tall_grass.local_to_map(position)
	return _instance.tall_grass.get_cell_tile_data(local_position)


static func get_custom_data_at(position: Vector2, custom_data_name: String) -> Variant:
	if _instance == null:
		return null
	var data = get_tile_data_at(position)
	if data == null:
		return null
	return data.get_custom_data(custom_data_name)
	

func _on_player_encounter_triggered(encountered_minion):
	var minion = Minions.wild_minion_from_enum(encountered_minion)
	var battle_scene = load("res://scenes/Battle.tscn").instantiate()
	get_tree().root.add_child(battle_scene)
	self.hide()
	audio_stream_player_2d.stop()
	player.hide()
	battle_scene.set_wild_minion(minion)
	await battle_scene.battle_finished
	self.show()
	audio_stream_player_2d.play()
	player.show()
	player.camera.make_current()
	get_tree().root.remove_child(battle_scene)
