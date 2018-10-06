extends Node2D

var database_raw

# 
var char_name
var char_icon # accepts an res:// path to the icon
var char_diet

var char_battler_scene

var char_class
var class_role

# skills
var skill_list = []

# hp/adr
var base_health
var mod_health

var adrenaline = 100 # adrenaline max never changes

# physical stats
var base_might # influences attack damage
var mod_might

var base_tough # influences phys damage mitigation
var mod_tough

# magical stats
var base_power # influences spell damage
var mod_power

var base_ward # influences magic damage mitigation
var mod_ward

var base_speed # influences position in turn order
var mod_speed

func load_info_from_database(which,id):
	# which should be a string of either "character" or "enemy"
	database_raw = Global_DatabaseReader.get_from_database(id,which)

func set_from_raw():
	char_name = database_raw["name"]
	char_icon = database_raw["icon"]
	base_health = database_raw["max_hp"]
	
	base_might = database_raw["might"]
	base_tough = database_raw["tough"]
	
	base_power = database_raw["power"]
	base_ward = database_raw["ward"]
	
	base_speed = database_raw["speed"]