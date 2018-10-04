extends Node

var effect_database = "res://Database/effectDatabase.json"

func get_effect(id):
	var effectData = {}
	effectData = Global_JSONParser.load_data(effect_database)
	
	if !effectData.has(str(id)):
		print("Effect does not exist.")
		return
	
	effectData[str(id)]["id"] = int(id)
	return effectData[str(id)]