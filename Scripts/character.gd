extends Node2D

var database_raw

var char_name
var char_icon # accepts an res:// path to the icon
var char_diet

var char_battler_scene

var char_class
var class_role

var level

# skills
var ability_list = []
var active_effects = []

# hp/adr
var base_health
var mod_health = []
var current_health #setget sethp,gethp
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

func load_info_from_database(which,id):
	# which should be a string of either "character" or "enemy"
	match which:
		"character": database_raw = Global_DatabaseReader.character[id]
	
	char_battler_scene = database_raw["path_to_battler"]
	
	char_name = database_raw["name"]
	char_icon = database_raw["icon"]
	base_health = database_raw["max_hp"]
	current_health = base_health
	hp_last_at = current_health
	
	base_might = database_raw["might"]
	base_tough = database_raw["tough"]
	
	base_power = database_raw["power"]
	base_ward = database_raw["ward"]
	
	base_speed = database_raw["speed"]
	
	load_abilities()
	
	level = 1
	
	return self

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

func addModifiers(val,mod):
	# val should be the base_stat value
	# mod should be the mod_stat value
	var add
	var mult
	
	if mod != null:
		for i in mod:
			match mod["MOD_TYPE"]:
				"ADD": add += mod["MOD"]
				"MULTIPLY": mult += mod["MOD"]
		
		val = val + add * mult
	return val

func getMaxHealth():
	return addModifiers(base_health,mod_health)

func getMight():
	return addModifiers(base_might,mod_might)

func getTough():
	return addModifiers(base_tough,mod_tough)

func getPower():
	return addModifiers(base_power,mod_power)

func getWard():
	return addModifiers(base_ward,mod_ward)

func getSpeed():
	return addModifiers(base_speed,mod_speed)

func load_abilities():
	for i in database_raw["abilities"]:
		ability_list.append(Global_DatabaseReader.ability[i])
