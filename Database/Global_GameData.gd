extends Node

var party = []

var foeparty = []

onready var characterScript = preload("res://Scripts/character.gd")

func _ready():
	var n = characterScript.new()
	n.load_info_from_database("character",0)
	party.append(n)
	
	n = characterScript.new()
	n.load_info_from_database("character",1)
	foeparty.append(n)