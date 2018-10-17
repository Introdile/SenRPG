extends Node

var ability_database = "res://Database/abilityDatabase.json"
var status_database = "res://Database/effectDatabase.json"
var character_database = "res://Database/characterDatabase.json"

onready var status_instance = preload("res://Database/statusInstance.gd")

var character = []
var ability = []
var status = []

var loaded = false

func _ready():
	_load_from_database("ability")
	_load_from_database("character")
	_load_from_database("status")

func _load_from_database(which):
	if loaded: loaded = false
	
	var i = 0
	while !loaded:
		var n = get_from_database(i,which)
		if n == null:
			print("Done!")
			loaded = true
			return
		
		match which:
			"ability": ability.append(n)
			"character": 
				character.append(n)
			"status": 
				var loadStatus = status_instance.new()
				loadStatus.load_from_database(i)
				print(loadStatus.name)
				status.append(loadStatus)
		
#		print("Loaded " + which + " of id " + str(i) + " ("+n["name"]+")")
		i += 1

func get_from_database(id,database):
	var data = {}
	
	match database:
		"ability": data = Global_JSONParser.load_data(ability_database)
		"status": data = Global_JSONParser.load_data(status_database)
		"character": data = Global_JSONParser.load_data(character_database)
		_: print("Invalid database selected. Check spelling?")
	
	if !data.has(str(id)):
		print("No data found for ID " + str(id) + " in database " + database)
		return null
	
	data[str(id)]["id"] = int(id)
	return data[str(id)]