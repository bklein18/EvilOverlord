extends Node2D

static func wild_minion_from_enum(enum_val: Minion.Minions) -> Minion:
	var new = Minions.Minion.new()
	new.Name = new.get_minion_name(enum_val)
	new.Type = new.get_minion_types(enum_val)
	new.EnumVal = enum_val
	var level_range = new.get_minion_level_range(enum_val)
	if level_range.size() > 0:
		new.Level = randi() % (level_range[-1] - level_range[0] + 1) + level_range[0]
		var moves = []
		var learnset = Minion.get_learnset(enum_val)
		for level in range(1, new.Level + 1):
			if level in learnset.keys():
				moves.append(learnset[level])
				if moves.size() > 4:
					moves.pop_front()
		new.Moves = moves
	return new

class Minion:
	var Name: String = "Name"
	var EnumVal := Minions.None
	var Type: Array = []
	var Moves: Array = []
	var Level: int = 0
	var Current_Health: int = 10
	var Max_Health: int = 10
	var Attack: int = 10
	var Defense: int = 10
	var Magic_Attack: int = 10
	var Magic_Defense: int = 10
	var Speed: int = 10
	var Luck: float = 0.1
	var Number: int = 0
	
	# max boost increase is 40% above base stats (stored in -4 to 4 range)
	# if boosts are increased when at the cap, increase duration by 2 turns
	# any boost lasts for 5 turns by default
	var attack_boost_turns_remaining: int = 0
	var attack_boost_amount: int = 0:
		set(new_value):
			attack_boost_amount += new_value
			if attack_boost_amount >= 4:
				attack_boost_amount = 4
			elif attack_boost_amount <= -4:
				attack_boost_amount = -4
	var magic_attack_boost_turns_remaining: int = 0
	var magic_attack_boost_amount: int = 0:
		set(new_value):
			magic_attack_boost_amount += new_value
			if magic_attack_boost_amount >= 4:
				magic_attack_boost_amount = 4
			elif magic_attack_boost_amount <= -4:
				magic_attack_boost_amount = -4
	var defense_boost_turns_remaining: int = 0
	var defense_boost_amount: int = 0:
		set(new_value):
			defense_boost_amount += new_value
			if defense_boost_amount >= 4:
				defense_boost_amount = 4
			elif defense_boost_amount <= -4:
				defense_boost_amount = -4
	var magic_defense_boost_turns_remaining: int = 0
	var magic_defense_boost_amount: int = 0:
		set(new_value):
			magic_defense_boost_amount += new_value
			if magic_defense_boost_amount >= 4:
				magic_defense_boost_amount = 4
			elif magic_defense_boost_amount <= -4:
				magic_defense_boost_amount = -4
	var speed_boost_turns_remaining: int = 0
	var speed_boost_amount: int = 0
	
	func adjusted_attack() -> int:
		if attack_boost_turns_remaining > 0:
			return self.Attack * (1.0 + (attack_boost_amount / 10.0))
		else:
			return self.Attack
	
	func adjusted_magic_attack() -> int:
		if magic_attack_boost_turns_remaining > 0:
			return self.Magic_Attack * (1.0 + (magic_attack_boost_amount / 10.0))
		else:
			return self.Magic_Attack
	
	func adjusted_defense() -> int:
		if defense_boost_turns_remaining > 0:
			return self.Defense * (1.0 + (defense_boost_amount / 10.0))
		else:
			return self.Defense
	
	func adjusted_magic_defense() -> int:
		if magic_defense_boost_turns_remaining > 0:
			return self.Magic_Defense * (1.0 + (magic_defense_boost_amount / 10.0))
		else:
			return self.Magic_Defense
	
	func adjusted_speed() -> int:
		if speed_boost_turns_remaining > 0:
			return self.Speed * (1.0 + (speed_boost_amount / 10.0))
		else:
			return self.Speed
	
	enum Minions {
		None,
		Dave,
		Zulio,
		Skelly,
		Gelly,
		Phyll,
		Yyxyll,
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
	
	# Attack returns the amount of damage after attack stat increase
	# Defense returns 0 if the defense buff was allowed, 1 if the defense couldn't go any higher
	func perform(move: Move) -> int:
		match move.category:
			Move.Category.Attack:
				return move.base_val * self.adjusted_attack()
			Move.Category.Defense:
				if defense_boost_amount == 4:
					defense_boost_turns_remaining += 2
					return 1
				else:
					defense_boost_amount += move.base_val
					return 0
			Move.Category.Defense_Debuff:
				if defense_boost_amount == -4:
					defense_boost_turns_remaining += 2
					return 1
				else:
					defense_boost_amount -= move.base_val
					return 0
			Move.Category.Magic_Attack:
				return move.base_val * self.adjusted_magic_attack()
			Move.Category.Magic_Defense:
				if magic_defense_boost_amount == 4:
					magic_defense_boost_turns_remaining += 2
					return 1
				else:
					magic_defense_boost_amount += move.base_val
					return 0
			Move.Category.Magic_Defense_Debuff:
				if magic_defense_boost_amount == -4:
					magic_defense_boost_turns_remaining += 2
					return 1
				else:
					magic_defense_boost_amount -= move.base_val
					return 0
			_:
				print("special")
				return 0

	func get_minion_name(minion: Minions.Minion.Minions) -> String:
		match minion:
			Minions.Dave:
				return "Dave"
			Minions.Zulio:
				return "Zulio"
			Minions.Skelly:
				return "Skelly"
			Minions.Gelly:
				return "Gelly"
			Minions.Phyll:
				return "Phyll"
			Minions.Yyxyll:
				return "Yyxyll"
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
	func get_minion_types(minion: Minions.Minion.Minions) -> Array:
		match minion:
			Minions.Dave:
				return [Types.Normal]
			Minions.Zulio:
				return [Types.Demon]
			Minions.Skelly:
				return [Types.Undead]
			Minions.Gelly:
				return [Types.Ooze]
			Minions.Phyll:
				return [Types.Plant]
			Minions.Yyxyll:
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
				
	func get_minion_level_range(minion: Minions.Minion.Minions) -> Array:
		match minion:
			Minions.Gelly:
				return range(3, 6)
			Minions.Phyll:
				return range(1, 5)
			Minions.Yyxyll:
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
				return [5]
	
	static func get_learnset(minion: Minions.Minion.Minions) -> Dictionary:
		match minion:
			Minions.Dave:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			Minions.Skelly:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			Minions.Gelly:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			Minions.Phyll:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			Minions.Yyxyll:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			Minions.The_One_Who_Waits:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			Minions.Dhal:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			Minions.Eemini:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			Minions.Bear:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge)
				}
			_:
				return {}

class Move:
	var name: String
	var category: Category
	var type: Minion.Types
	var base_val: int
	var number: int
	
	enum Category {
		Attack,
		Attack_Buff,
		Defense,
		Defense_Debuff,
		Magic_Attack,
		Magic_Attack_Buff,
		Magic_Defense,
		Magic_Defense_Debuff,
		Special
	}
	
	static func init(name: String, category: Category, type: Minion.Types, base_val: int, number: int) -> Move:
		var new = Move.new()
		new.name = name
		new.category = category
		new.type = type
		new.base_val = base_val
		new.number = number
		return new
		
	enum Moves {
		Charge,
		Block,
		Fireball,
		Shield
	}
	
	static var moves: Array = [
		Move.init("Charge", Move.Category.Attack, Minion.Types.Normal, 2, 1),
		Move.init("Block", Move.Category.Defense, Minion.Types.Normal, 2, 2),
		Move.init("Fireball", Move.Category.Magic_Attack, Minion.Types.Dragon, 4, 3),
		Move.init("Shield", Move.Category.Magic_Defense, Minion.Types.Fey, 3, 4)
	]
	
	static func move_object_from_enum(move: Moves) -> Move:
		match move:
			Moves.Charge:
				return moves[0]
			Moves.Block:
				return moves[1]
			Moves.Fireball:
				return moves[2]
			Moves.Shield:
				return moves[3]
			_:
				return moves[0]
	
