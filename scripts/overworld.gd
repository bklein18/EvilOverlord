extends Node2D
class_name Overworld
const M = preload("res://scripts/minions.gd")

@onready var tall_grass = $TallGrass
@onready var player = $Player

static var _instance: Overworld = null

const encounter_list := [
	M.Minion.Minions.Phyll,
	M.Minion.Minions.Eemini,
	M.Minion.Minions.Bear
]

const encounter_probabilities := {
	M.Minion.Minions.Phyll: 0.95,
	M.Minion.Minions.Eemini: 0.90,
	M.Minion.Minions.Bear: 0.85
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_instance = self if _instance == null else _instance
	
	player.encounter_list = encounter_list
	player.encounter_probabilities = encounter_probabilities

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
	var minion = M.wild_minion_from_enum(encountered_minion)
	var battle_scene = load("res://scenes/Battle.tscn").instantiate()
	get_tree().root.add_child(battle_scene)
	self.hide()
	player.hide()
	battle_scene.set_wild_minion(minion)
