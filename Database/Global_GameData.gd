extends Node

var party = []

onready var characterScript = preload("res://Scripts/character.gd")

func _ready():
	var n = characterScript.new()
	n.load_info_from_database("character",0)
	party.append(n)
	print(party[0].char_name)