extends Node2D

var STAT_GROWTH = {
	"VERY_SLOW": 1,
	"SLOw": 1.05,
	"MEDIUM": 1.10,
	"FAST": 1.125,
	"VERY_FAST": 1.15,
}

var STAT_APT = {
	"WEAK": 16,
	"AVERAGE": 18,
	"STRONG": 20
}

var database_raw

var char_name
var char_icon # accepts an res:// path to the icon
var char_diet

var char_battler_scene

var char_class
var class_role

var level

# skills
var attack_skill
var ability_list = []
var active_effects = []

# hp/adr
var base_health

var mod_health = []

var current_health #setget sethp,gethp
var blue_health = 0 
var hp_last_at

var adrenaline = 100 # adrenaline max never changes

# physical stats

var base_might # influences attack damage
var mod_might = []

var base_tough # influences phys damage mitigation
var mod_tough = []

# magical stats
var base_power # influences spell damage
var mod_power = []

var base_ward # influences magic damage mitigation
var mod_ward = []

var base_speed # influences position in turn order
var mod_speed = []

signal hp_changed

func addStatModifier(which, mod):
	# mod should be an dictionary containing MOD_TYPE, MOD, and SOURCE
	match which:
		"HEALTH": mod_health.append(mod)
		"MIGHT": mod_might.append(mod)
		"TOUGH": mod_tough.append(mod)
		"POWER": mod_power.append(mod)
		"WARD": mod_ward.append(mod)
		"SPEED": mod_speed.append(mod)

func removeHP(value):
	hp_last_at = current_health
	current_health -= value
	
	print(char_name + " HP: " + str(current_health) + " / " + str(base_health))
	
	var chg = (value / base_health) * 100
	emit_signal("hp_changed",chg,"down")

func addHP(value):
	hp_last_at = current_health
	current_health += value
	
	var chg = (value / base_health) * 100
	emit_signal("hp_changed",value,"up")

func changeBlue(value):
	blue_health += value

func regenerateFromBlue():
	var regen = (1 - (level / ( getTough() + level)))
	pass

func getAdjusted(val,mod):
	# val should be the base_stat value
	# mod should be the mod_stat value
	var add = 0.0
	var mult = 1.0
	
	if !mod.empty():
		print(mod)
		for i in mod:
			match i["MOD_TYPE"]:
				"FLAT": add += i["MOD"]
				"PERCENT": mult += i["MOD"]
		
		print(str(add) + " x " + str(mult))
		val = (float(val) + add) * mult
	return floor(val)

func getMaxHealth():
	return getAdjusted(base_health,mod_health)

func getMight():
	return getAdjusted(base_might,mod_might)

func getTough():
	return getAdjusted(base_tough,mod_tough)

func getPower():
	return getAdjusted(base_power,mod_power)

func getWard():
	return getAdjusted(base_ward,mod_ward)

func getSpeed():
	return getAdjusted(base_speed,mod_speed)

func load_info_from_database(which,id):
	# which should be a string of either "character" or "enemy"
	match which:
		"character": database_raw = Global_DatabaseReader.character[id]
	
	level = 1
	
	char_battler_scene = database_raw["path_to_battler"]
	
	char_name = database_raw["name"]
	char_icon = database_raw["icon"]
	
	base_health = calculate_stat(database_raw["hp_aptitude"],database_raw["hp_growth"],level,"hp")
	
	current_health = base_health
	hp_last_at = current_health
	
	base_might = calculate_stat(database_raw["might_aptitude"],database_raw["might_growth"],level)
	base_tough = calculate_stat(database_raw["tough_aptitude"],database_raw["tough_growth"],level)
	
	base_power = calculate_stat(database_raw["power_aptitude"],database_raw["power_growth"],level)
	base_ward = calculate_stat(database_raw["ward_aptitude"],database_raw["ward_growth"],level)
	
	base_speed = calculate_stat(database_raw["speed_aptitude"],database_raw["speed_growth"],level)
	
	var as = load("res://Database/abilityInstance.gd").new()
	as.load_from_database(0,database_raw["attack"])
	attack_skill = as
	
	load_abilities()
	
	return self

func calculate_stat(apt,grw,lvl,type="stat"):
	if type == "stat":
		return floor((STAT_APT[apt] + pow(lvl,STAT_GROWTH[grw]) * 1.5) - 1)
	elif type == "hp":
		return floor(((STAT_APT[apt]*2) + pow(lvl,STAT_GROWTH[grw]) * 2) - 1)
	elif type == "en":
		return floor(((STAT_APT[apt]*2) + pow(lvl,STAT_GROWTH[grw]) * 1.5) - 1)

func load_abilities():
	for i in database_raw["abilities"]:
		var newAb = Global_DatabaseReader.ability[i].copy()
		ability_list.append(newAb)

func reduceDuration():
	if !active_effects.empty():
		for i in active_effects:
			i.duration -= 1
			if i.duration <= 0:
				active_effects.erase(i)
				print("Effect fell off " + i.name)
			print("Reduced the duration of " + i.name)