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

onready var battlers #= get_tree().get_nodes_in_group("battler")
var foes = []
var ally = []
var actionOrder = []

var currentBattler = 0

func _ready():
	
	#TODO: uhhhhhh get ready bitches
	changeState(battleState.START)
	var allypos = get_tree().get_nodes_in_group("ally")
	var foepos = get_tree().get_nodes_in_group("foe")
	
	for i in Global_GameData.party:
		
		# loads the character battler scene 
		# TODO: battler scene should construct animations on the fly
		var nbi = load(i.char_battler_scene)
		var n = nbi.instance()
		
		# set the reference character (from the gamedata) and the position of the battler
		n.character = i
		n.global_position = allypos[0].global_position
		n.name = n.character.char_name
		# add it to the scene,,,
		$Battlers.add_child(n)
		
		# this sets up the ui
		var nui = charUI.instance()
		nui.attachedChar = n
		nui.rect_position = Vector2(652,452) #TODO: add it to a container that'll handle this automatically
		ui.add_child(nui)
		
		if n.global_position.x > get_viewport().size.x / 2:
			n.flip_battler()
		
		ally.append(n)
		n.connect("deal_damage",battleFunc,"_deal_damage")
		n.connect("cleared_animation_stack",self,"_on_battler_clearanimstacks")
	
	for i in Global_GameData.foeparty:
		# pretty much as above but for enemies
		# except without setting up a ui for them
		var nbi = load(i.char_battler_scene)
		var n = nbi.instance()
		n.character = i
		n.global_position = foepos[0].global_position
		n.name = n.character.char_name
		$Battlers.add_child(n)
		
		foes.append(n)
		n.connect("deal_damage",battleFunc,"_deal_damage")
		n.connect("cleared_animation_stack",self,"_on_battler_clearanimstacks")
	
	battlers = get_tree().get_nodes_in_group("battler")
	battlers.sort_custom(battleFunc,"isSpeedGreater")

func _process(delta):
	
	match state:
		battleState.START:
			sl = "Setting things up..."
			# SET UP THE BATTLERS
			for i in battlers:
				i.character.current_health = i.character.base_health
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
			if actionOrder.empty():
				for i in battlers:
					actionOrder.append(i)
					print(i.name)
				print(str(actionOrder.size()))
			
			if !actionOrder.front().animating:
				sl = actionOrder.front().name + " currently acting..."
				actionOrder.front().performAction()
	
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

func _on_ability_chosen(ab,ch):
	ch.action = ab
	ch.target.append(foes[0])

func _on_attackButton_pressed():
	ally[0].action = Global_DatabaseReader.get_from_database(0,"ability")
	ally[0].target.append(foes[0])

func _on_proceedButton_pressed():
	if state == battleState.PLAN:
		changeState(battleState.ACTION)