extends Sprite

var c_target

func move_to(target):
	#target should only be a battler node
	if target != c_target:
		c_target = target
		if !$Tween.is_active():
			$Tween.interpolate_property(self,"global_position",global_position,target.above.global_position,0.25,Tween.TRANS_LINEAR,Tween.EASE_IN)
			$Tween.start()
		else:
			$Tween.stop_all()
			$Tween.remove_all()



func _on_Tween_tween_completed(object, key):
	$Tween.stop_all()
	$Tween.remove_all()
