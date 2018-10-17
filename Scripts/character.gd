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
var mod_health = 0
var current_health #setget sethp,gethp
var hp_last_at

var adrenaline = 100 # adrenaline max never changes

# physical stats
var base_might # influences attack damage
var mod_might = 0

var base_tough # influences phys damage mitigation
var mod_tough = 0

# magical stats
var base_power # influences spell damage
var mod_power = 0

var base_ward # influences magic damage mitigation
var mod_ward = 0

var base_speed # influences position in turn order
var mod_speed = 0

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

func load_abilities():
	for i in database_raw["abilities"]:
		ability_list.append(Global_DatabaseReader.ability[i])
