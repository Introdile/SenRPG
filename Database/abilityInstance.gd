extends Node

enum target {
	ONE_FOE,
	ONE_ALLY,
	ALL_FOE,
	ALL_ALLY,
}

enum type {
	DAMAGE,
	HEAL,
	BUFF,
	DEBUFF,
}

var database_raw

var abID = -1
var abIcon = -1

var abName = " "
var abDescription = " "

var abTarget = target.ONE_FOE
var abType = type.DAMAGE

var abEffects
var abAnimation

var abCooldown
var cur_cooldown = 0

func load_from_database(id,dbr=null):
	
	if dbr != null:
		database_raw = dbr
	else:
		database_raw = Global_DatabaseReader.get_from_database(id,"ability")
		
		if database_raw == null:
			print("No ability found for ID " + str(id) + "!")
			pass
	
	abID =  id
	abIcon = database_raw["icon"]
	
	abName = database_raw["name"]
	name = abName
	abDescription = database_raw["description"]
	
	abTarget = database_raw["targets"]
#	match database_raw["targets"]:
#		"ONE_FOE": abTarget = target.ONE_FOE
#		"ONE_ALLY": abTarget = target.ONE_ALLY
#		"ALL_ALLY": abTarget = target.ALL_ALLY
#		"ALL_FOE": abTarget = target.ALL_FOE
	
	match database_raw["type"]:
		"DAMAGE": abType = type.DAMAGE
		"HEAL": abType = type.HEAL
		"BUFF": abType = type.BUFF
		"DEBUFF": abType = type.DEBUFF
	
	abEffects = database_raw["effect"]
	abAnimation = database_raw["animation"]
	
	abCooldown = database_raw["cooldown"]

func copy():
	var x = self.duplicate()
	
	x.abID = abID
	x.abIcon = abIcon
	x.abName = abName
	x.abDescription = abDescription
	x.abTarget = abTarget
	x.abType = abType
	x.abEffects = abEffects
	x.abAnimation = abAnimation
	x.abCooldown = abCooldown
	
	return x





