extends Control

var attachedChar

onready var portrait = get_node("Panel/mainContainer/characterPortrait")
onready var hpBar = get_node("Panel/mainContainer/infoContainer/hpBar")
onready var adrBar = get_node("Panel/mainContainer/infoContainer/adrBar")

onready var abilityGrid = get_node("Panel/mainContainer/infoContainer/abilityContainer")
onready var abilityButton = preload("res://Battle/UI/uiAbilityButton.tscn")

func _ready():
	hpBar.addAmount(1000)
	if attachedChar == null:
		print("I don't have any character attached!")
		self.queue_free()
		return
	
	update_abilities(attachedChar.character.ability_list)
	attachedChar.character.connect("hp_changed",self,"updateHP")
	
	update_icon(null)

func update_icon(icon,id=0,gsz=64,noc=4):
	# icon takes a texture
	# id indicates which image in the texture it will display
	# gsz is the grid size
	# noc is the number of columns
	
	var y_pos = floor(id/noc)
	var x_pos = id - (y_pos*noc)
	
	if icon != null:
		var n = AtlasTexture.new()
		n.texture = icon
		
		n.texture.region = Rect2(x_pos * gsz, y_pos * gsz, gsz, gsz)
		portrait.texture = n
	else:
		portrait.texture.region = Rect2(x_pos * gsz, y_pos * gsz,gsz,gsz)

func update_abilities(ability_list):
	var n = 0
	for i in ability_list:
		if n < 6:
			var nab = abilityButton.instance()
			nab.attach_ability(i)
			print("Created button for ability " + i["name"])
			abilityGrid.add_child(nab)
			n += 1
		else: pass

func updateHP(amount,uod):
	# amount should be the raw amount of hp lost/gained
	# uod is up or down
	match uod:
		"up": 
			hpBar.addAmount(amount)
		"down": 
			hpBar.removeAmount(amount)
	
#	var change = (amount / attachedChar.max_hp) * 100
#
#	if change >= 0:
#		hpBar.addAmount(change)
#	elif change < 0:
#		hpBar.removeAmount(-change)
	
#	var change = float(last_hp - hp)
#			change = (change / max_hp) * 100
#			hpBar.removeAmount(change)
#			createDamageLabel(last_hp - hp)
#			last_hp = hp
#		if last_hp < hp:
#			var change = float(hp - last_hp)
#			change = (change / max_hp) * 100
#			hpBar.addAmount(change)
#			createDamageLabel(hp - last_hp)