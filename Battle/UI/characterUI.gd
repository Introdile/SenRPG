extends Control

var attachedChar

onready var portrait = get_node("mainCont/left/portrait")
onready var hpBar = get_node("mainCont/left/hpBar")
onready var adrBar = get_node("mainCont/left/adrBar")

onready var abilityGrid = get_node("mainCont/right/skillGrid")
onready var passiveAct = get_node("mainCont/right/passiveAction")

onready var passiveActionSide = []
onready var passiveActionMain = get_node("mainCont/right/passiveAction/passiveMain")

## passive actions
var passiveAction = "ATTACK"

onready var pA_attack_left = preload("res://Assets/UI/passive_action_attack_side_temp.png")
onready var pA_attack_right = preload("res://Assets/UI/passive_action_attack_right_temp.png")

onready var pA_defend_left = preload("res://Assets/UI/passive_action_defend_side_temp.png")
onready var pA_defend_right = preload("res://Assets/UI/passive_action_defend_right_temp.png")

onready var pA_defend_main = preload("res://Assets/UI/passive_action_defend_temp.png")
onready var pA_attack_main = preload("res://Assets/UI/passive_action_attack_temp.png")


onready var abilityButton = preload("res://Battle/UI/uiAbilityButton.tscn")



func _ready():
	passiveActionSide.append(get_node("mainCont/right/passiveAction/passiveRight"))
	passiveActionSide.append(get_node("mainCont/right/passiveAction/passiveLeft"))
	
	hpBar.addAmount(1000)
	if attachedChar == null:
		print("I don't have any character attached!")
		self.queue_free()
		return
	update_abilities(attachedChar.character.ability_list)
	attachedChar.character.connect("hp_changed",self,"updateHP")
	
	#update_icon(null)

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
	for i in abilityGrid.get_children():
		i.queue_free()
	
	for i in range(6):
		if i < ability_list.size():
			var nab = abilityButton.instance()
			nab.attach_ability(ability_list[i])
			nab.uiParent = self
			if !nab.is_connected("ability_pressed",get_parent().get_parent().get_parent().get_parent(),"_on_ability_chosen"):
				nab.connect("ability_pressed",get_parent().get_parent().get_parent().get_parent(),"_on_ability_chosen")
			abilityGrid.add_child(nab)
		else:
			var nab = abilityButton.instance()
			nab.uiParent = self
			abilityGrid.add_child(nab)
#	for i in ability_list:
#		if n < 6:
#			var nab = abilityButton.instance()
#			nab.attach_ability(i)
#			nab.uiParent = self
#			if !nab.is_connected("ability_pressed",get_parent().get_parent().get_parent().get_parent(),"_on_ability_chosen"):
#				nab.connect("ability_pressed",get_parent().get_parent().get_parent().get_parent(),"_on_ability_chosen")
#			abilityGrid.add_child(nab)
#			n += 1
#		else: pass

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

func _on_passiveSide_pressed():
	match passiveAction:
		"ATTACK":
			passiveAction = "DEFEND"
			passiveActionSide[0].texture_normal = pA_attack_right
			passiveActionSide[1].texture_normal = pA_attack_left
			passiveActionMain.texture_normal = pA_defend_main
		"DEFEND":
			passiveAction = "ATTACK"
			passiveActionSide[0].texture_normal = pA_defend_right
			passiveActionSide[1].texture_normal = pA_defend_left
			passiveActionMain.texture_normal = pA_attack_main
	pass # replace with function body
