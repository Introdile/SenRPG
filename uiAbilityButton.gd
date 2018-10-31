extends TextureButton

signal ability_pressed

onready var ab_icon = get_node("uiAbilityIcon")
onready var ab_sheet = preload("res://Assets/AbilityIcons/abilityIconSheet.png")

var attachedAbility = {}
var uiParent

func _ready():
	_set_up_bitmap()
	$uiAbilityIcon.texture = $uiAbilityIcon.texture.duplicate()
	if attachedAbility.has("icon"):
		update_icon(attachedAbility["icon"])
	else: ab_icon.queue_free()#self.queue_free()

func attach_ability(newAbility):
	attachedAbility = newAbility
	if typeof(attachedAbility["icon"]) != TYPE_STRING:
		update_icon(attachedAbility["icon"])

func update_icon(id,gs=32,noc=8):
#	print("Icon set for " + attachedAbility["name"])
	$uiAbilityIcon.texture.region = cf.id_to_grid(id,gs,noc)

func _set_up_bitmap():
	var newBitmap = BitMap.new()
	newBitmap.create(Vector2(42,42))
	newBitmap.set_bit_rect(Rect2(0,0,42,42),true)
	texture_click_mask = newBitmap

func _on_uiAbilityButton_pressed():
	if attachedAbility != null:
		emit_signal("ability_pressed",attachedAbility,uiParent.attachedChar)
