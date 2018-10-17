extends Node

static func isSpeedGreater(a,b):
	return a.character.base_speed > b.character.base_speed

static func _deal_damage(a,b,ds):
	#a is the attacker
	#b is the target
	#ds is the damage stack
	
	var dam
	
	match ds["type"]:
		"HP_DAMAGE":
			dam = calculateDamage(a,b,ds)
		#TODO: ADD MORE
	
	
	b.character.removeHP(dam)

static func calculateDamage(a,b,ds):
	var totaldamage
	var statUsed
	var armor
	
	match ds["based_stat"]:
		"MIGHT":
			statUsed = a.character.base_might
		_:
			print("Unrecognized based_stat... defaulting to MIGHT")
			statUsed = a.character.base_might
	
	match ds["element"]:
		"PHYSICAL":
			var def = b.character.base_tough
			var level = a.character.level
			armor = 1 - (def / ((9 * (1 + level)) + def))
			
			totaldamage = statUsed * armor * ds["power"]
	
#	def = float(def)
#	var level = 10
#
#	var armor = 1 - (def / ((9 * (1+level))+def))
#	var totaldamage = atk * armor * boost
	
	return floor(totaldamage)

static func getRandomBattler(blist):
	# form the percentage of each battler getting hit, based on hostility
	# percent hostility is the current selected battlers hostility over the party's total hostility times 100
	# randomly generate one of them
	var randNum = randi() % 100
	print(randNum)
	
	var hostSum = 0.0
	var lastValue = 0.0
	var newRange
	
	for i in blist:
		hostSum += i.hostility
	for i in blist:
		newRange = float(i.hostility) / hostSum * 100 + lastValue
		
		if randNum > lastValue and randNum < newRange:
			return i
		lastValue = newRange