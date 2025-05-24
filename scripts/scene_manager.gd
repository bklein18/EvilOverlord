extends Node

static var party: Array = [
	Minions.wild_minion_from_enum(Minions.Minion.Minions.Dave),
	Minions.wild_minion_from_enum(Minions.Minion.Minions.Yyxyll),
	Minions.wild_minion_from_enum(Minions.Minion.Minions.Gelly),
	Minions.wild_minion_from_enum(Minions.Minion.Minions.Bear)
]

static var inventory: Array = [
	Items.create_item("Potion", 2, "Heals one minion for 20HP", Items.Item.ItemTypes.Healing),
	Items.create_item("Scroll of Stoneskin", 1, "Boosts the defense of one minion", Items.Item.ItemTypes.Buff)
]

var current_base_scene = preload("res://scenes/IntroScene.tscn")
