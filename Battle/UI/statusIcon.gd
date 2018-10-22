extends TextureRect

var statusRef

func _ready():
	if statusRef == null:
		self.queue_free()
		print("No status info set, I'm outta here!")

func set_icon(id):
	var new_rect = cf.id_to_grid(id,16,16)
	texture.region = new_rect

func _on_Area2D_mouse_entered():
	print(statusRef.name + " | " + statusRef.description + " | " + str(statusRef.duration) + " | " + statusRef.currentStacks)
	pass #print the info of the status referenced
