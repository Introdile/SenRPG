extends Node

enum {
	DOT,
	DEBUFF,
	BUFF,
	REGEN,
	SETUP
}

var database_raw

var statusID = -1
var statusIcon = -1

var statusName = " "
var statusDescription = " "

var duration = 1
var type = DOT

var canStack = false
var maxStacks = 1
var currentStacks = 1

var process = []

func load_from_database(id):
	database_raw = Global_DatabaseReader.get_from_database(id,"status")
	if database_raw == null:
		print("No status found for ID " + str(id) + "!")
	
	statusID = id
	statusIcon = database_raw["icon"]
	
	statusName = database_raw["name"]
	name = statusName
	statusDescription = database_raw["description"]
	
	duration = database_raw["duration"]
	match database_raw["type"]:
		"DOT": type = DOT
		"DEBUFF": type = DEBUFF
		"BUFF": type = BUFF
		"REGEN": type = REGEN
		_: 
			print("Type not found: " + database_raw["type"] + "\nDefaulting to DOT")
			type = DOT
	canStack = database_raw["can_stack"]
	maxStacks = database_raw["max_stacks"]
	process = database_raw["process"]