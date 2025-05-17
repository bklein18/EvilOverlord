extends Node2D
class_name Overworld
const M = preload("res://scripts/minions.gd")

@onready var tall_grass = $TallGrass
@onready var player = $Player

static var _instance: Overworld = null

const encounter_list := [
	M.Minions.Phyll,
	M.Minions.Eemini,
	M.Minions.Bear
]

const encounter_probabilities := {
	M.Minions.Phyll: 0.95,
	M.Minions.Eemini: 0.90,
	M.Minions.Bear: 0.85
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_instance = self if _instance == null else _instance
	DI.set_default_scene_parent(self)
	
	DI.bind(encounter_list, DI.As.VALUE).to_var("encounter_list")
	DI.bind(encounter_probabilities, DI.As.VALUE).to_var("encounter_probabilities")
	
	DI.provide_tree(self)

static func get_tile_data_at(position: Vector2) -> TileData:
	var local_position: Vector2 = _instance.tile_map.local_to_map(position)
	return _instance.tile_map.get_cell_tile_data(0, local_position)


static func get_custom_data_at(position: Vector2, custom_data_name: String) -> Variant:
	var data = get_tile_data_at(position)
	return data.get_custom_data(custom_data_name)
	

func _on_player_encounter_triggered(encountered_minion):
	pass # Replace with function body.
