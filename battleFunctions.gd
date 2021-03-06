extends Node

static func isSpeedGreater(a,b):
	return a.character.getSpeed() > b.character.getSpeed()

static func _deal_damage(a,b,ds):
	#a is the attacker
	#b is the target
	#ds is the damage stack
	
	var dam
	
	match ds["type"]:
		"HP_DAMAGE":
			dam = calculateDamage(a,b,ds)
			b.character.removeHP(dam)
			b.character.changeBlue(dam*0.25)
		#TODO: ADD MORE
	
	
	

static func calculateDamage(a,b,ds):
	var totaldamage
	var statUsed
	var armor
	
	match ds["based_stat"]:
		"MIGHT":
			statUsed = a.character.getMight()
		_:
			print("Unrecognized based_stat... defaulting to MIGHT")
			statUsed = a.character.getMight()
	
	match ds["element"]:
		"PHYSICAL":
			var def = b.character.getTough()
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
	var selected
	
	var randNum = randi() % 100
	
	var hostSum = 0.0
	var lastValue = 0.0
	var newRange
	
	for i in blist:
		hostSum += i.hostility
	for i in blist:
		newRange = float(i.hostility) / hostSum * 100 + lastValue
		
		if randNum > lastValue and randNum < newRange:
			selected = i
		lastValue = newRange
	
	if selected == null:
		selected = blist[0]
	
	return selected