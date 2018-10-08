extends Node2D

export(bool) var flip = false

export(int) var max_hp = 20
var hp
var last_hp

export(int) var _attack = 10
var attack

export(int) var _defense = 5
var defense

export(int) var _speed = 2
var speed

var abilityList = [0,1]

# battle variables
var action
var target = []

# animation variables
var animationStack = []
var activetween
var processingStack = false
var animating = false
var start_pos
var animation

signal deal_damage
signal cleared_animation_stack
signal hp_changed

# animation variables 
onready var sprite = get_node("battlerSprite")
onready var battlerAnim = get_node("battlerAnim")

# bar variables
onready var hpBar = get_node("battlerInfo/healthBar")
onready var adBar = get_node("battlerInfo/adrenalineBar")
onready var damLabel = preload("res://Prefabs/floatLabel.tscn")

# positions
onready var front = get_node("positions/front")
onready var back = get_node("positions/back")

var character

func _ready():
	randomize()
	
	start_pos = sprite.global_position
	
	hp = max_hp
	last_hp = hp
	
	attack = _attack
	defense = _defense
	speed = _speed
	
	hpBar.addAmount(1000)
	
	if flip:
		flip_battler()

func _process(delta):
	if character == null:
		print("I don't have a character!")
		self.queue_free()
	
	$Label.text = "position: " + str(sprite.global_position) + "\nstart_pos: " + str(start_pos)
	$Label.text += "\nanimating: " + str(animating)
	if last_hp != hp:
		if last_hp > hp:
			if battlerAnim.current_animation != "hurt": battlerAnim.play("hurt")
			var change = float(last_hp - hp)
			change = (change / max_hp) * 100
			emit_signal("hp_changed",change,"down")
			hpBar.removeAmount(change)
			createDamageLabel(last_hp - hp)
			last_hp = hp
		if last_hp < hp:
			var change = float(hp - last_hp)
			change = (change / max_hp) * 100
			emit_signal("hp_changed",change,"up")
			hpBar.addAmount(change)
			createDamageLabel(hp - last_hp)
			last_hp = hp
	
	if Input.is_action_just_pressed("ui_up"):
		adBar.addAmount(10)
	if Input.is_action_just_pressed("ui_down"):
		adBar.removeAmount(10)
	
	## ANIMATION HANDLING ##
	
	if animating:
		if !animationStack.empty():
			if !processingStack:
				match animationStack.front()["key"]:
					"move":
						
						move_sprite(animationStack.front()["pos"],animationStack.front()["speed"])
						processingStack = true
						
					"animation":
						
						if battlerAnim.has_animation(animationStack.front()["animation"]):
							battlerAnim.play(animationStack.front()["animation"])
							processingStack = true
						else:
							print("Animation not found: " + animationStack.front()["animation"])
							animationStack.pop_front()
						
		else:
			if !processingStack:
				move_sprite("START",0.5)
				processingStack = true
	

func set_from_reference():
	if character == null:
		print("No reference set! :(")
		self.queue_free()
		return
	

func flip_battler():
	if $battlerSprite.flip_h: $battlerSprite.flip_h = false
	else: $battlerSprite.flip_h = true
	$battleAction.position = Vector2(-$battleAction.position.x,$battleAction.position.y)
	
	front.position = Vector2(-front.position.x, 0)
	back.position = Vector2(-back.position.x, 0)

## ANIMATION HANDLING ##

# the animationStack variable should hold all the information on each action in the animation
# it should give which animation you wish to play and where the sprite must move to play the animation
# after completing the animation, it should pop_front() to get rid of the animation it just played,
# look at the new animation in the front and run that. once animationStack is empty(), it should return the
# sprite back to its original position and emit_signal animation_complete

func performAction():
	# fail safe in case an action wasn't selected
	if action == null:
		print("I have no action! :'(")
		return false
	
	# loads up the animation stack
	for i in action["animation"]:
		animationStack.append(i)
	
	print(name + " performing animation for ability " + action["name"] + ". Anim stack size = " + str(animationStack.size()))
	
	animating = true

func move_sprite(pos_key,tween_speed):
	# pos_key accepts a string that indicates the position
	# details on what pos_key can be in the match statement below
	
	var newTween = Tween.new()
	add_child(newTween)
	activetween = newTween
	
	# add to a group (just in case) and connect the completed signal
	newTween.connect("tween_completed",self,"_on_tween_complete")
	
	# get the position based on the pos key given
	var mpos
	match pos_key:
		"START": # the sprite's starting position
			mpos = start_pos
		"SELF_FRONT": # the front position of themself
			mpos = front.global_position
		"SELF_BACK": # the back position of themself
			mpos = back.global_position	
		"TARGET_FRONT": # the front of the target
			mpos = target[0].front.global_position
		"TARGET_BACK": # the back of the target
			mpos = target[0].back.global_position
		_: # in case the pos key is mistyped
			print("I'm not sure... stepping back...")
			mpos = back.global_position
	
	# start the interpolation
	newTween.interpolate_property(sprite, "global_position", sprite.global_position, mpos, tween_speed,Tween.TRANS_LINEAR,Tween.EASE_IN)
	newTween.start()

func createDamageLabel(val):
	var n = damLabel.instance()
	n.get_node("Label").text = str(val)
	var nx = (randi() % 32) - 16
	var ny = (randi() % 32) - 16
#	print(str(nx) + ", " + str(ny))
	n.translate(Vector2(nx,ny))
#	print(str(n.position))
	add_child(n)

func _on_tween_complete(object, key):
	activetween.queue_free()
	if !animationStack.empty():
		animationStack.pop_front()
	else:
		emit_signal("cleared_animation_stack")
		battlerAnim.play("idle")
		animating = false
	processingStack = false

func _on_battlerAnim_animation_finished(anim_name):
	if !animationStack.empty():
		animationStack.pop_front()
		processingStack = false
	if anim_name == "hurt":
		battlerAnim.play("idle")

func emit_damage():
	emit_signal("deal_damage", self, target[0], action)