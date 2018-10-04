extends Node

var ability_database = "res://Database/abilityDatabase.json"
var effect_database = "res://Database/effectDatabase.json"
var character_database = ""

func get_from_database(id,database):
	var data = {}
	
	match database:
		"ability": data = Global_JSONParser.load_data(ability_database)
		"effect": data = Global_JSONParser.load_data(effect_database)
		"character": data = Global_JSONParser.load_data(character_database)
		_: print("Invalid database selected. Check spelling?")
	
	if !data.has(str(id)):
		print("No data found for ID " + str(id) + " in database " + database)
		return
	
	data[str(id)]["id"] = int(id)
	return data[str(id)]