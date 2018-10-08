extends Node

enum battleState {
	START,
	FOE,
	PLAN,
	TARGET,
	ACTION,
	WIN,
	LOSE,
}

var state
var lastState

onready var battleFunc = preload("res://battleFunctions.gd")
onready var charUI = preload("res://Battle/UI/characterUI.tscn")

onready var ui = get_node("UI")
onready var stateLabel = get_node("UI/stateLabel")
var sl = ""

onready var battlers = get_tree().get_nodes_in_group("battler")
var foes = []
var ally = []
var actionOrder = []

var currentBattler = 0

func _ready():
	#TODO: uhhhhhh get ready bitches
	changeState(battleState.START)
	var allypos = get_tree().get_nodes_in_group("ally")
	for i in Global_GameData.party:
		var nbi = load(i.char_battler_scene)
		var n = nbi.instance()
		n.global_position = allypos[0].global_position
		$Battlers.add_child(n)
	for i in battlers:
		if i.name == "Foe":
			i.character = Global_GameData.foeparty[0]
			foes.append(i)
		if i.name == "Ally":
			i.character = Global_GameData.party[0]
			ally.append(i)
			var nui = charUI.instance()
			nui.attachedChar = i
			nui.rect_position = Vector2(652,452)
			ui.add_child(nui)
		i.connect("deal_damage",battleFunc,"_deal_damage")
		i.connect("cleared_animation_stack",self,"_on_battler_clearanimstacks")
	battlers.sort_custom(battleFunc,"isSpeedGreater")

func _process(delta):
	
	match state:
		battleState.START:
			sl = "Setting things up..."
			# SET UP THE BATTLERS
			for i in battlers:
				i.hp = i.max_hp
			changeState(battleState.FOE)
		battleState.FOE:
			sl = "The foe is selecting their action."
			# CHOOSE THE FOE'S ACTION
			for i in foes:
				i.target.append(ally[0])
				i.action = Global_DatabaseReader.get_from_database(1,"ability")
			print("foe has selected action " + foes[0].action["name"])
			changeState(battleState.PLAN)
		battleState.PLAN:
			
			sl = "Please choose an action"
			# LET THE PLAYER CHOOSE THEIR ACTION
			pass	
		battleState.TARGET:
			sl = "Please select a target(s)"
			pass
		battleState.ACTION:
			#sl = "Turn commencing..."
			if actionOrder.empty():
				for i in battlers:
					actionOrder.append(i)
					print(i.name)
				print(str(actionOrder.size()))
			
			if !actionOrder.front().animating:
				sl = actionOrder.front().name + " currently acting..."
				actionOrder.front().performAction()
			
#			if !battlers[currentBattler].animating:
#				sl = battlers[currentBattler].name + " currently acting..."
#				battlers[currentBattler].performAction()
	
	stateLabel.text = sl

func changeState(newState):
	lastState = state
	state = newState

func _on_battler_clearanimstacks():
	if state == battleState.ACTION:
		if actionOrder.size()-1 > 0:
			actionOrder.pop_front()
		else:
			actionOrder.pop_front()
			changeState(battleState.FOE)
#		if currentBattler+1 < battlers.size():
#			currentBattler += 1
#		else:
#			changeState(battleState.FOE)
#			currentBattler = 0

func _on_attackButton_pressed():
	ally[0].action = Global_DatabaseReader.get_from_database(0,"ability")
	ally[0].target.append(foes[0])
	
	#foes[0].performAction()
#	print(ally[0].action["animation"])
#	ally[0].performAction()

func _on_proceedButton_pressed():
	if state == battleState.PLAN:
		changeState(battleState.ACTION)