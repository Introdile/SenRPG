extends "res://Scripts/character.gd"

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
var animating = false
var moved = false
var start_pos
var animation
var done = false

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
		$battlerSprite.flip_h = flip
		$battleAction.position = Vector2(-$battleAction.position.x,$battleAction.position.y)
		
		front.position = Vector2(-front.position.x, 0)
		back.position = Vector2(-back.position.x, 0)
#	print(self.name + " front: "+ str(front.global_position))
#	print(self.name + " back: "+ str(back.global_position))

func _process(delta):
	$Label.text = "position: " + str(sprite.global_position) + "\nstart_pos: " + str(start_pos)
	$Label.text += "\nanimating: " + str(animating) + "\ndone: " + str(done)
	$Label.text += "\nmoved: " + str(moved) + "\ntween active: " + str($battlerTween.is_active())
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
			if !moved:
				if !$battlerTween.is_active():
					print("moving...")
					var mpos
					
					match animationStack.front()["pos"]:
						"STAY": 
							moved = true
							pass
						"SELF_FRONT": mpos = front.global_position
						"SELF_BACK": mpos = back.global_position
						"ENEMY_FRONT": mpos = target[0].front.global_position
						"ENEMY_BACK": mpos = target[0].back.global_position
						_:
							print("i dunno... stepping back")
							mpos = back.global_position
					
					move_sprite(mpos)
			else: # if moved
				if battlerAnim.current_animation != animationStack.front()["animation"]:
					print("animating...")
					battlerAnim.play(animationStack.front()["animation"])
			
		else: 
			if sprite.global_position != start_pos: move_sprite(start_pos)
		if done:
			emit_signal("cleared_animation_stack")
			sprite.global_position = start_pos
			animating = false
			done = false
	

## ANIMATION HANDLING ##

# the animationStack variable should hold all the information on each action in the animation
# it should give which animation you wish to play and where the sprite must move to play the animation
# after completing the animation, it should pop_front() to get rid of the animation it just played,
# look at the new animation in the front and run that. once animationStack is empty(), it should return the
# sprite back to its original position and emit_signal animation_complete

func performAction():
	if action == null:
		print("I have no action! :'(")
		return false
	
	for i in action["animation"]:
		animationStack.append(i)
	
	print(name + " performing animation for ability " + action["name"] + ". Anim stack size = " + str(animationStack.size()))
	
	animating = true

func createDamageLabel(val):
	var n = damLabel.instance()
	n.get_node("Label").text = str(val)
	var nx = (randi() % 32) - 16
	var ny = (randi() % 32) - 16
#	print(str(nx) + ", " + str(ny))
	n.translate(Vector2(nx,ny))
#	print(str(n.position))
	add_child(n)

func move_sprite(pos,type="run",tween_speed=1,trans_type=Tween.TRANS_LINEAR,ease_type=Tween.EASE_OUT_IN):
	if type == "run":
		$battlerTween.interpolate_property(sprite, "global_position", sprite.global_position, pos, tween_speed, trans_type, ease_type)
		$battlerTween.start()

func resetStat(which):
	#which accepts a string
	match which:
		"attack": attack = _attack
		"defense": defense = _defense
		"speed": speed = _speed
		_: print("didnt catcht that chief, no stat reset")


func _on_battlerTween_tween_completed(object, key):
	print("DONE!! FUCK YOU")
	if animating: 
		moved = true
		$battlerTween.remove_all()
	else:
		battlerAnim.play("idle")
	if animationStack.empty():
		done = true
		moved = false
		battlerAnim.play("idle")

func _on_battlerAnim_animation_finished(anim_name):
	if !animationStack.empty():
		animationStack.pop_front()
		moved = false
		#print("one stack cleared... " + str(animationStack.size()) + " remaining")
#	if anim_name == animation:
#		animating = false
#		animation = null
#		battlerAnim.play("idle")
#		move_sprite(start_pos)
	if anim_name == "hurt":
		battlerAnim.play("idle")

func emit_damage():
	emit_signal("deal_damage", self, target[0], action)