extends TextureButton

signal ability_pressed

onready var ab_icon = get_node("uiAbilityIcon")
var attachedAbility
var IDregion = Rect2()

func _ready():
	set_region()

func attach_ability(newAbility):
	attachedAbility = newAbility
	if typeof(attachedAbility["icon"]) != TYPE_STRING:
		update_icon(attachedAbility["icon"])

func update_icon(id,gs=32,noc=8):
	IDregion = cf.id_to_grid(id,gs,noc)

func set_region():
	ab_icon.texture.region = IDregion

func _on_uiAbilityButton_pressed():
	emit_signal("ability_pressed",attachedAbility)
