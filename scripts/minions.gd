extends Node2D

static func wild_minion_from_enum(enum_val: Minion.Minions) -> Minion:
	var new = Minions.Minion.new()
	new.Name = new.get_minion_name(enum_val)
	new.Type = new.get_minion_types(enum_val)
	new.EnumVal = enum_val
	var level_range = new.get_minion_level_range(enum_val)
	new.Level = randi() % (level_range[-1] - level_range[0] + 1) + level_range[0]
	var attack_range = new.get_minion_base_stat_range(Minions.Minion.Stats.Attack)
	new.Attack = randi() % (attack_range[-1] - attack_range[0] + 1) + attack_range[0]
	var defense_range = new.get_minion_base_stat_range(Minions.Minion.Stats.Defense)
	new.Defense = randi() % (defense_range[-1] - defense_range[0] + 1) + defense_range[0]
	var magic_attack_range = new.get_minion_base_stat_range(Minions.Minion.Stats.Magic_Attack)
	new.Magic_Attack = randi() % (magic_attack_range[-1] - magic_attack_range[0] + 1) + magic_attack_range[0]
	var magic_defense_range = new.get_minion_base_stat_range(Minions.Minion.Stats.Magic_Defense)
	new.Magic_Defense = randi() % (magic_defense_range[-1] - magic_defense_range[0] + 1) + magic_defense_range[0]
	var speed_range = new.get_minion_base_stat_range(Minions.Minion.Stats.Speed)
	new.Speed = randi() % (speed_range[-1] - speed_range[0] + 1) + speed_range[0]
	new.Luck = new.get_minion_base_stat_range(Minions.Minion.Stats.Luck)[0]
	new.Attack_Growth_Rate = new.get_minion_base_stat_range(Minions.Minion.Stats.Attack_Growth_Rate)[0]
	new.Defense_Growth_Rate = new.get_minion_base_stat_range(Minions.Minion.Stats.Defense_Growth_Rate)[0]
	new.Magic_Attack_Growth_Rate = new.get_minion_base_stat_range(Minions.Minion.Stats.Magic_Attack_Growth_Rate)[0]
	new.Magic_Defense_Growth_Rate = new.get_minion_base_stat_range(Minions.Minion.Stats.Magic_Defense_Growth_Rate)[0]
	new.Speed_Growth_Rate = new.get_minion_base_stat_range(Minions.Minion.Stats.Speed_Growth_Rate)[0]
	if level_range.size() > 0:
		var moves = []
		var learnset = Minion.get_learnset(enum_val)
		for level in range(1, new.Level + 1):
			new.Attack += ceil(new.Attack_Growth_Rate * new.Attack / 50)
			new.Defense += ceil(new.Defense_Growth_Rate * new.Attack / 50)
			new.Magic_Attack += ceil(new.Magic_Attack_Growth_Rate * new.Attack / 50)
			new.Magic_Defense += ceil(new.Magic_Defense_Growth_Rate * new.Attack / 50)
			new.Speed += ceil(new.Speed_Growth_Rate * new.Attack / 50)
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
	var Current_Health: int = 10:
		set(new_value):
			Current_Health = clampi(new_value, 0, Max_Health)
	var Max_Health: int = 10
	var Attack: int = 10
	var Attack_Growth_Rate: float = 1.0:
		set(new_value):
			Attack_Growth_Rate = clampf(new_value, 0.5, 1.5)
	var Defense: int = 10
	var Defense_Growth_Rate: float = 1.0:
		set(new_value):
			Defense_Growth_Rate = clampf(new_value, 0.5, 1.5)
	var Magic_Attack: int = 10
	var Magic_Attack_Growth_Rate: float = 1.0:
		set(new_value):
			Magic_Attack_Growth_Rate = clampf(new_value, 0.5, 1.5)
	var Magic_Defense: int = 10
	var Magic_Defense_Growth_Rate: float = 1.0:
		set(new_value):
			Magic_Defense_Growth_Rate = clampf(new_value, 0.5, 1.5)
	var Speed: int = 10
	var Speed_Growth_Rate: float = 1.0:
		set(new_value):
			Speed_Growth_Rate = clampf(new_value, 0.5, 1.5)
	var Luck: float = 0.1
	var Number: int = 0
	var Base_XP_Yield: int = 10
	var Growth_Rate: float:
		set(new_value):
			Growth_Rate = clampf(new_value, 0.5, 1.5)
	
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
	
	enum Stats {
		Attack,
		Attack_Growth_Rate,
		Defense,
		Defense_Growth_Rate,
		Magic_Attack,
		Magic_Attack_Growth_Rate,
		Magic_Defense,
		Magic_Defense_Growth_Rate,
		Speed,
		Speed_Growth_Rate,
		Luck
	}
	
	func get_minion_base_stat_range(stat: Stats) -> Array:
		match stat:
			Stats.Attack:
				match self.EnumVal:
					Minions.Dave:
						return range(6, 11)
					Minions.Zulio:
						return range(7, 12)
					Minions.Skelly:
						return range(5, 10)
					Minions.Gelly:
						return range(3, 6)
					Minions.Phyll:
						return range(4, 7)
					Minions.Yyxyll:
						return range(7, 10)
					Minions.The_One_Who_Waits:
						return range(5, 8)
					Minions.Dhal:
						return range(9, 11)
					Minions.Eemini:
						return range(4, 8)
					Minions.Bear:
						return range(7, 9)
					_:
						return []
			Stats.Attack_Growth_Rate:
				match self.EnumVal:
					Minions.Dave:
						return [1.2]
					Minions.Zulio:
						return [1.3]
					Minions.Skelly:
						return [0.9]
					Minions.Gelly:
						return [0.5]
					Minions.Phyll:
						return [0.7]
					Minions.Yyxyll:
						return [1.1]
					Minions.The_One_Who_Waits:
						return [1.0]
					Minions.Dhal:
						return [1.3]
					Minions.Eemini:
						return [0.8]
					Minions.Bear:
						return [1.2]
					_:
						return []	
			Stats.Defense:
				match self.EnumVal:
					Minions.Dave:
						return range(7,12)
					Minions.Zulio:
						return range(5, 10)
					Minions.Skelly:
						return range(6, 11)
					Minions.Gelly:
						return range(7, 10)
					Minions.Phyll:
						return range(6, 9)
					Minions.Yyxyll:
						return range(5, 7)
					Minions.The_One_Who_Waits:
						return range(6, 9)
					Minions.Dhal:
						return range(8, 10)
					Minions.Eemini:
						return range(3, 6)
					Minions.Bear:
						return range(8, 11)
					_:
						return []
			Stats.Defense_Growth_Rate:
				match self.EnumVal:
					Minions.Dave:
						return [13]
					Minions.Zulio:
						return [0.9]
					Minions.Skelly:
						return [11]
					Minions.Gelly:
						return [1.4]
					Minions.Phyll:
						return [0.9]
					Minions.Yyxyll:
						return [0.9]
					Minions.The_One_Who_Waits:
						return [0.7]
					Minions.Dhal:
						return [1.1]
					Minions.Eemini:
						return [0.6]
					Minions.Bear:
						return [1.3]
					_:
						return []
			Stats.Magic_Attack:
				match self.EnumVal:
					Minions.Dave:
						return range(5, 10)
					Minions.Zulio:
						return range(7, 12)
					Minions.Skelly:
						return range(6, 11)
					Minions.Gelly:
						return range(5, 7)
					Minions.Phyll:
						return range(7, 10)
					Minions.Yyxyll:
						return range(6, 9)
					Minions.The_One_Who_Waits:
						return range(8, 12)
					Minions.Dhal:
						return range(4, 6)
					Minions.Eemini:
						return range(7, 10)
					Minions.Bear:
						return range(4, 6)
					_:
						return []
			Stats.Magic_Attack_Growth_Rate:
				match self.EnumVal:
					Minions.Dave:
						return [0.9]
					Minions.Zulio:
						return [1.3]
					Minions.Skelly:
						return [1.1]
					Minions.Gelly:
						return [1.0]
					Minions.Phyll:
						return [1.0]
					Minions.Yyxyll:
						return [0.9]
					Minions.The_One_Who_Waits:
						return [1.3]
					Minions.Dhal:
						return [0.6]
					Minions.Eemini:
						return [1.1]
					Minions.Bear:
						return [0.8]
					_:
						return []
			Stats.Magic_Defense:
				match self.EnumVal:
					Minions.Dave:
						return range(6, 11)
					Minions.Zulio:
						return range(7, 12)
					Minions.Skelly:
						return range(5, 10)
					Minions.Gelly:
						return range(3, 6)
					Minions.Phyll:
						return range(4, 7)
					Minions.Yyxyll:
						return range(7, 10)
					Minions.The_One_Who_Waits:
						return range(5, 8)
					Minions.Dhal:
						return range(9, 11)
					Minions.Eemini:
						return range(4, 8)
					Minions.Bear:
						return range(7, 9)
					_:
						return []
			Stats.Magic_Defense_Growth_Rate:
				match self.EnumVal:
					Minions.Dave:
						return [1.2]
					Minions.Zulio:
						return [1.3]
					Minions.Skelly:
						return [0.9]
					Minions.Gelly:
						return [0.5]
					Minions.Phyll:
						return [0.7]
					Minions.Yyxyll:
						return [1.1]
					Minions.The_One_Who_Waits:
						return [1.0]
					Minions.Dhal:
						return [1.3]
					Minions.Eemini:
						return [0.8]
					Minions.Bear:
						return [1.2]
					_:
						return []
			Stats.Speed:
				match self.EnumVal:
					Minions.Dave:
						return range(6, 11)
					Minions.Zulio:
						return range(7, 12)
					Minions.Skelly:
						return range(5, 10)
					Minions.Gelly:
						return range(3, 6)
					Minions.Phyll:
						return range(4, 7)
					Minions.Yyxyll:
						return range(7, 10)
					Minions.The_One_Who_Waits:
						return range(5, 8)
					Minions.Dhal:
						return range(9, 11)
					Minions.Eemini:
						return range(4, 8)
					Minions.Bear:
						return range(7, 9)
					_:
						return []
			Stats.Speed_Growth_Rate:
				match self.EnumVal:
					Minions.Dave:
						return [1.2]
					Minions.Zulio:
						return [1.3]
					Minions.Skelly:
						return [0.9]
					Minions.Gelly:
						return [0.5]
					Minions.Phyll:
						return [0.7]
					Minions.Yyxyll:
						return [1.1]
					Minions.The_One_Who_Waits:
						return [1.0]
					Minions.Dhal:
						return [1.3]
					Minions.Eemini:
						return [0.8]
					Minions.Bear:
						return [1.2]
					_:
						return []
			Stats.Luck:
				match self.EnumVal:
					Minions.Dave:
						return [1.2]
					Minions.Zulio:
						return [1.3]
					Minions.Skelly:
						return [0.9]
					Minions.Gelly:
						return [0.5]
					Minions.Phyll:
						return [0.7]
					Minions.Yyxyll:
						return [1.1]
					Minions.The_One_Who_Waits:
						return [1.0]
					Minions.Dhal:
						return [1.3]
					Minions.Eemini:
						return [0.8]
					Minions.Bear:
						return [1.2]
					_:
						return []
			_:
				return []
	
	static func get_learnset(minion: Minions.Minion.Minions) -> Dictionary:
		match minion:
			Minions.Dave:
				return {
					1: Move.move_object_from_enum(Move.Moves.Charge),
					3: Move.move_object_from_enum(Move.Moves.Fireball)
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
	
