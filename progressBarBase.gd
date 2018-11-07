extends TextureProgress

onready var barAmount = get_node("progressBarCurrent")
export(Color) var main_color = Color("29c33d")

onready var barHeal = get_node("progressBarHeal")
export(Color) var gain_color = Color("2735c6")

onready var barHurt = get_node("progressBarHurt")
export(Color) var lose_color = Color("ff0000")

var currentAmount = 10
var blueAmount
var bar_speed = 2

var barUpdate = false

func _ready():
	barAmount.modulate = main_color
	barHeal.modulate = gain_color
	barHurt.modulate = lose_color
	
	barHeal.rect_size = self.rect_size
	barHurt.rect_size = self.rect_size
	barAmount.rect_size = self.rect_size
	#TODO: MAKE SUB BARS ADJUST TO SIZE OF BASE BAR

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		addAmount(20)
#	if Input.is_action_just_pressed("ui_down"):
#		removeAmount(20)
	
	if barUpdate:
		if barHurt.value > currentAmount:
			barHurt.value -= bar_speed
		elif barAmount.value < currentAmount:
			barAmount.value += bar_speed
			barHurt.value = barAmount.value
		else:
			barUpdate = false

func addAmount(amount):
	
	var newVal = barAmount.value + amount
	if newVal > barAmount.max_value:
		newVal = barAmount.max_value
	
	currentAmount = newVal
	barUpdate = true

func removeAmount(amount):
	
	var newVal = barAmount.value - amount
	if newVal < barAmount.min_value:
		newVal = barAmount.min_value
	
	currentAmount = newVal
	barAmount.value = newVal
#	barHeal.value = newVal
	barUpdate = true

func changeBlue(amount):
	# add blue health
	# bar would be barAmount + blue amount
	
	blueAmount += amount 
	barHeal.value = blueAmount + barAmount.value

func changeMax(newMax):
	barHurt.max_value = newMax
	barHeal.max_value = newMax
	barAmount.max_value = newMax