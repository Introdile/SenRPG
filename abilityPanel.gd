extends Panel

onready var abilityIcon = get_node("abilityHBox/abilityIcon")

onready var abilityName = get_node("abilityHBox/abilityVBox/abilityName")
onready var abilityDesc = get_node("abilityHBox/abilityVBox/abilityDesc")
onready var abilityCooldown = get_node("abilityHBox/abilityVBox/abilityCooldown")

func updateIcon(newIcon):
	#newIcon should be a resource path string
	var nID = int(newIcon)
	
	var number_of_columns = 16
	var size_of_grid = 24
	
	var y_pos = floor(nID/number_of_columns)
	var x_pos = nID - (y_pos*number_of_columns)
	
	abilityIcon.texture.region = Rect2(x_pos * size_of_grid ,y_pos * size_of_grid ,size_of_grid,size_of_grid)
#	if ResourceLoader.has(newIcon):
#		abilityIcon.texture = load(newIcon)
#	else:
#		print("Icon not found, please enter a valid resource path.")

func updateName(newName):
	abilityName.text = newName

func updateDesc(newDesc):
	abilityDesc.bbcode_text = newDesc

func updateCooldown(newCD):
	abilityCooldown.text = "Cooldown: " + newCD


"""

########
########
#0######
########

id of 0 would be the far upper right corner
0, 0
id of 8 would be the far upper left corner.
8, 0

var size_of_icons = 24
var number_of_columns = 8

var y_pos = floor(id/number_of_columns)
var x_pos = id - (y_pos * number_of_columns)

pos_of_icon = Vector2( (y_pos * number_of_columns) - id , y_pos) * size_of_icons

if im looking for the position of ID 18
y_pos = floor( 18 / 8 ) = 2
x_pos = 18 - ( 2 * 8 ) - 1 = 1

position of ID 18 would be (1,2) which is accurate to the grid

"""