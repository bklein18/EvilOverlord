extends Node

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
