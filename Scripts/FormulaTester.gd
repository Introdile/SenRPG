extends Control

onready var spin = get_node("Panel/SpinBox")
onready var label = get_node("Panel/RichTextLabel")

var iterations = 10

func _ready():
	calculateFormula(10)

func calculateFormula(arg):
	label.text += "\n..\nCalculating...\n"
	var level
	var armor = float(arg)
	
	for i in range(iterations):
		if i == 0: level = 1
		else: level = (i) * 10
		
		var res = armor / ((4.5* (1 + level)) + armor)
		#var res = 64 * armor / ( armor + 16 * level )
		label.text += "Lvl: " + str(level) + " | Armor: " + str(armor) + " | Res: " + str(res)
		label.text += " | 1,000 damage would be reduced to: " + str(1000 * (1 - (0.01*res))) + "\n"

func _on_Button_pressed():
	calculateFormula(spin.value)
