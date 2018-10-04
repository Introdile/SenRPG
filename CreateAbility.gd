extends Control

# ability display panel
onready var panel = get_node("abilityPanel")

# ability edit nodes
onready var editName = get_node("abilityEditPanel/abilityVBox/abilityNameEdit")
onready var editIcon = get_node("abilityEditPanel/abilityVBox/abilityIconEdit")
onready var editDesc = get_node("abilityEditPanel/abilityVBox/abilityDescEdit")

onready var editTargets = get_node("abilityEditPanel/abilityVBox/abilityGridBox/abilityTargetsChoice")
onready var editType = get_node("abilityEditPanel/abilityVBox/abilityGridBox/abilityTypeChoice")
onready var editElement = get_node("abilityEditPanel/abilityVBox/abilityGridBox/abilityElementChoice")

func _ready():
	var vp_size = get_viewport_rect().size
	
	var ab_x = (vp_size.x / 2) - (panel.rect_size.x / 2)
	var ab_y = 32
	
	panel.rect_position = Vector2(ab_x,ab_y)
	
	#set up editTarget selection items
	editTargets.add_item("NONE", 0)
	editTargets.add_item("SELF", 1)
	editTargets.add_item("ONE_FOE", 2)
	editTargets.add_item("ONE_ALLY", 3)
	editTargets.add_item("ALL_FOES", 4)
	editTargets.add_item("ALL_ALLIES", 5)
	editTargets.add_item("ONE_DEAD_ALLY", 6)
	editTargets.add_item("ALL_DEAD_ALLIES", 7)
	editTargets.add_item("FIELD", 8)
	
	#set up editType selection items
	editType.add_item("NONE", 0)
	editType.add_item("DAMAGE", 1)
	editType.add_item("RECOVERY", 2)
	
	#set up editElement selection items
	editElement.add_item("NONE", 0)
	editElement.add_item("PHYSICAL", 1)
	editElement.add_item("ARCANE", 2)
	editElement.add_item("FIRE", 3)
	editElement.add_item("WATER", 4)
	editElement.add_item("WIND", 5)
	editElement.add_item("EARTH", 6)
	editElement.add_item("VOID", 7)
	editElement.add_item("TRUE", 8)

func processOptionSelect(which,id):
	var optStr
	if which == "element":
		match id:
			0: optStr = "NONE"
			1: optStr = "PHYSICAL"
			2: optStr = "ARCANE"
			3: optStr = "FIRE"
			4: optStr = "WATER"
			5: optStr = "WIND"
			6: optStr = "EARTH"
			7: optStr = "VOID"
			8: optStr = "TRUE"
	if which == "type":
		match id:
			0: optStr = "NONE"
			1: optStr = "DAMAGE"
			2: optStr = "RECOVERY"
	if which == "target":
		match id:
			0: optStr = "NONE"
			1: optStr = "SELF"
			2: optStr = "ONE_FOE"
			3: optStr = "ONE_ALLY"
			4: optStr = "ALL_FOES"
			5: optStr = "ALL_ALLIES"
			6: optStr = "ONE_DEAD_ALLY"
			7: optStr = "ALL_DEAD_ALLIES"
			8: optStr = "FIELD"
	return optStr


func _on_addAbilityButton_pressed():
	panel.updateName(editName.text)
	panel.updateIcon(editIcon.text)
	panel.updateDesc(editDesc.text)
