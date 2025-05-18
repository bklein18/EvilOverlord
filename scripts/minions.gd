extends Node

static func wild_minion_from_enum(enum_val: Minion.Minions) -> Minion:
	var new = Minion.new()
	new.Name = new.get_minion_name(enum_val)
	new.Type = new.get_minion_types(enum_val)
	var level_range = new.get_minion_level_range(enum_val)
	new.Level = randi() % (level_range[-1] - level_range[0] + 1) + level_range[0]
	
	return new

class Minion:
	var Name: String
	var Type: Array
	var Level: int
	var Current_Health: int
	var Max_Health: int = 10
	var Attack: int
	var Defense: int
	var Magic_Attack: int
	var Magic_Defense: int
	var Speed: int

	enum Minions {
		None,
		Dave,
		Zulio,
		Skelly,
		Gelatinous_Cube,
		Phyll,
		Yyx_yll,
		The_One_Who_Waits,
		Dhal,
		Eemini,
		Bear
	}

	enum Types {
		Normal,
		Demon,
		Undead,
		Ooze,
		Plant,
		Cthonic,
		Fey,
		Dragon,
		Goblin,
		Beast
	}

	func get_minion_name(minion: Minions) -> String:
		match minion:
			Minions.Dave:
				return "Dave"
			Minions.Zulio:
				return "Zulio"
			Minions.Skelly:
				return "Skelly"
			Minions.Gelatinous_Cube:
				return "Gelatinous Cube"
			Minions.Phyll:
				return "Phyll"
			Minions.Yyx_yll:
				return "Yyx'yll"
			Minions.The_One_Who_Waits:
				return "The One Who Waits"
			Minions.Dhal:
				return "Dhal"
			Minions.Eemini:
				return "Eemini"
			Minions.Bear:
				return "Bear"
			_:
				return ""

	# returns an array of the minions types, will be of length one for monotypes
	func get_minion_types(minion: Minions) -> Array:
		match minion:
			Minions.Dave:
				return [Types.Normal]
			Minions.Zulio:
				return [Types.Demon]
			Minions.Skelly:
				return [Types.Undead]
			Minions.Gelatinous_Cube:
				return [Types.Ooze]
			Minions.Phyll:
				return [Types.Plant]
			Minions.Yyx_yll:
				return [Types.Cthonic]
			Minions.The_One_Who_Waits:
				return [Types.Fey]
			Minions.Dhal:
				return [Types.Dragon]
			Minions.Eemini:
				return [Types.Goblin]
			Minions.Bear:
				return [Types.Beast]
			_:
				return []
				
	func get_minion_level_range(minion: Minions) -> Array:
		match minion:
			Minions.Gelatinous_Cube:
				return range(3, 6)
			Minions.Phyll:
				return range(1, 5)
			Minions.Yyx_yll:
				return range(3, 6)
			Minions.The_One_Who_Waits:
				return range(5, 8)
			Minions.Dhal:
				return [7, 12]
			Minions.Eemini:
				return range(2, 5)
			Minions.Bear:
				return range(3, 6)
			_:
				return []
