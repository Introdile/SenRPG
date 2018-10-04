extends Control

# Should read the data from the JSON file and display the data on the various labels

# get_node variables
onready var abilityPanel = get_node("abilityPanel")

onready var abilityIcon = get_node("abilityPanel/abilityHBox/abilityIcon")

onready var abilityName = get_node("abilityPanel/abilityHBox/abilityVBox/abilityName")
onready var abilityDesc = get_node("abilityPanel/abilityHBox/abilityVBox/abilityDesc")
onready var abilityCooldown = get_node("abilityPanel/abilityHBox/abilityVBox/abilityCooldown")

onready var abilityIDSelector = get_node("abilityIDSelector")

func _ready():
	var vp_size = get_viewport_rect().size
	
	var ab_x = (vp_size.x / 2) - (abilityPanel.rect_size.x / 2)
	var ab_y = (vp_size.y / 2) - (abilityPanel.rect_size.y / 2)
	
	abilityPanel.rect_position = Vector2(ab_x,ab_y)
	
	update_abilityPanel(1)

#This will contain the written [color=yellow]description[/color], the [color=red]power[/color], [color=blue]effects[/color] tied to it, and [color=green]duration[/color] if applicable.

func update_abilityPanel(id):
	# id accepts the id of an ability
	var newAb = Global_DatabaseReader.get_from_database(id,"ability")
	if newAb == null: 
		return
	
	var newAbEffects = []
	
	for i in range(newAb["effects"].size()):
		if int(newAb["effects"][i]["effectID"]) > -1:
			newAbEffects.append(Global_DatabaseReader.get_from_database(newAb["effects"][i]["effectID"],"effect"))
	
	abilityIcon.texture = load(newAb["icon"])
	
	abilityName.text = newAb["name"]
	
	var desc_text = newAb["description"]
	desc_text = desc_text + "\n[color=red]Power:[/color] " + str(newAb["power"])
	if newAbEffects.size() > 0:
		desc_text = desc_text + "\n[color=blue]Effect:[/color] " + newAbEffects[0]["name"] + ": " + newAbEffects[0]["description"] % [newAbEffects[0]["effects"][0]["power"]]
		desc_text = desc_text + "\n\n[color=green]Duration:[/color] " + str(newAbEffects[0]["duration"])
	abilityDesc.bbcode_text = desc_text
	
	abilityCooldown.text = "Cooldown: " + str(newAb["cooldown"])

func _on_abilityIDSelector_value_changed(value):
	update_abilityPanel(value)
