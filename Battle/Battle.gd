extends Node

enum battleState {
	START,
	FOE,
	PLAN,
	TARGET,
	ACTION,
	EOT,
	WIN,
	LOSE,
}

var state
var lastState

onready var battleFunc = preload("res://battleFunctions.gd")
onready var stProcessor = preload("res://Battle/statusProcessor.gd")
onready var charUI = preload("res://Battle/UI/characterUI_2.tscn")

onready var ui = get_node("UI")
onready var stateLabel = get_node("UI/stateLabel")
var sl = ""

onready var pip = get_node("selectPip")

onready var battlers
var foes = []
var ally = []
var actionOrder = []

var currentBattler = 0
var currentAction
var currentCharacter

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
		n.global_position = allypos.front().global_position
		allypos.front().queue_free()
		allypos.pop_front()
		n.name = n.character.char_name
		# add it to the scene,,,
		$Battlers.add_child(n)
		
		# this sets up the ui
		var nui = charUI.instance()
		nui.attachedChar = n
		#nui.rect_position = Vector2(652,452) #TODO: add it to a container that'll handle this automatically
		$UI/NPBack/characterUI.add_child(nui)
		
		if n.global_position.x > get_viewport().size.x / 2:
			n.flip_battler()
		
		ally.append(n)
		n.connect("deal_damage",battleFunc,"_deal_damage")
		n.connect("cleared_animation_stack",self,"_on_battler_clearanimstacks")
		n.connect("interacted",self,"_on_battler_hover")
	
	for i in Global_GameData.foeparty:
		# pretty much as above but for enemies
		# except without setting up a ui for them
		var nbi = load(i.char_battler_scene)
		var n = nbi.instance()
		n.character = i
		n.global_position = foepos.front().global_position
		foepos.front().queue_free()
		foepos.pop_front()
		n.name = n.character.char_name
		$Battlers.add_child(n)
		
		foes.append(n)
		n.connect("deal_damage",battleFunc,"_deal_damage")
		n.connect("cleared_animation_stack",self,"_on_battler_clearanimstacks")
		n.connect("interacted",self,"_on_battler_hover")
	
	battlers = get_tree().get_nodes_in_group("battler")
	battlers.sort_custom(battleFunc,"isSpeedGreater")

func _process(delta):
	
	match state:
		battleState.START:
			sl = "Setting things up..."
			# SET UP THE BATTLERS
			for i in battlers:
				i.character.current_health = i.character.base_health
			
			battlers.front().addStatusEffect(1,battlers.back())
			#battlers.front().character.active_effects.append(Global_DatabaseReader.status[1].duplicate())
			changeState(battleState.FOE)
		battleState.FOE:
			sl = "The foe is selecting their action."
			# CHOOSE THE FOE'S ACTION
			for i in foes:
				var foeTarget = battleFunc.getRandomBattler(ally)
				print("Foe has chosen target " + foeTarget.name)
				i.target.append(foeTarget)
				i.action = i.character.ability_list[0]
#				print("foe has selected action " + foes[0].action["name"])
			changeState(battleState.PLAN)
		battleState.PLAN:
			
			sl = "Please choose an action"
			# LET THE PLAYER CHOOSE THEIR ACTION
			pass
		battleState.TARGET:
			sl = "Please select a target(s)"
			if !$selectPip.visible: $selectPip.visible = true
			pass
		battleState.ACTION:
			
			#    set passive actions if no action was previously set
			for i in ally:
				if i.action == null:
					match i.passiveAction:
						"ATTACK":
							i.action = i.character.attack_skill
							i.target.append(battleFunc.getRandomBattler(foes))
			
			#    set up the action order for the turn
			if actionOrder.empty():
				for i in battlers:
					actionOrder.append(i)
			
			#    proceed with the turn
			if !actionOrder.front().animating:
				stProcessor.processStatus(actionOrder.front(),"START_OF_ACTION")
				sl = actionOrder.front().name + " currently acting..."
				if !actionOrder.front().performAction():
					passTurn()
			
		battleState.EOT:
			# end of turn
			
			#    reduce cooldowns and durations
			for i in battlers:
				stProcessor.processStatus(i,"END_OF_TURN")
				i.character.reduceDuration()
				
				i.action = null
				i.target.clear()
			
			changeState(battleState.FOE)
	
	stateLabel.text = sl

func passTurn():
	if state == battleState.ACTION:
		if actionOrder.size()-1 > 0:
			actionOrder.pop_front()
		else:
			actionOrder.pop_front()
			changeState(battleState.EOT)

func changeState(newState):
	lastState = state
	state = newState

func _on_battler_clearanimstacks():
	passTurn()

func _on_battler_hover(object,event):
	if state == battleState.TARGET:
		if event == "hover":
			match currentAction.abTarget:
				"ONE_FOE":
					if foes.has(object):
						pip.move_to(object)
				"ONE_ALLY":
					if ally.has(object):
						pip.move_to(object)
				
		if event == "click":
			var selTarget
			match currentAction.abTarget:
				"ONE_FOE":
					if foes.has(object):
						selTarget = object
				"ONE_ALLY":
					if ally.has(object):
						selTarget = object
			if selTarget != null:
				currentCharacter.target.append(selTarget)
				print(currentCharacter.name + " has targetted " + selTarget.name + " with ability " + currentCharacter.action["name"])
				currentAction = null
				currentCharacter = null
				pip.visible = false
				changeState(battleState.PLAN)

func _on_ability_chosen(ab,ch):
	if !ch.target.empty(): ch.target.clear()
	ch.action = ab
	currentAction = ab
	currentCharacter = ch
	
	match ab.abTarget:
		"ONE_FOE":
			changeState(battleState.TARGET)

func _on_proceedButton_pressed():
	if state == battleState.PLAN:
		changeState(battleState.ACTION)