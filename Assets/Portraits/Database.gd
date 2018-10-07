extends Node

var characters = []
var ability = []

var loaded = false

func _load_all_from_database(which):
	if loaded: loaded = false
	
	var i = 0
	while !loaded:
		var n = Global_DatabaseReader