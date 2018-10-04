extends Node

static func isSpeedGreater(a,b):
	return a.speed > b.speed

static func _deal_damage(a,b,ab):
	#a is the attacker
	#b is the target
	#ab is the ability
	var dam = calculateDamage(a.attack,b.defense)
	b.hp -= dam


static func calculateDamage(atk,def,boost=1.0):
#	print("atk: "+str(atk)+" | def: "+str(def))
	def = float(def)
	var level = 10
	
	var armor = 1 - (def / ((9 * (1+level))+def))
#	print("armor is " + str(armor)+"!")
	var totaldamage = atk * armor * boost
#	print("totaldamage is " + str(totaldamage)+"!")
	
	return floor(totaldamage)