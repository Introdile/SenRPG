extends Node

var party = []

var foeparty = []

onready var characterScript = preload("res://Scripts/character.gd")

func _ready():
	
	for i in range(3):
		var n = characterScript.new()
		n.load_info_from_database("character",0)
		party.append(n)
	print(str(party))
	for i in range(3):
		var n = characterScript.new()
		n.load_info_from_database("character",1)
		foeparty.append(n)
	print(str(foeparty))