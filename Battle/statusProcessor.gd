extends Node

# this complicated script will perform actions based on information written in the status json

static func processStatus(battler, time_key):
	# pop out those effects
	var effects = battler.character.active_effects
	
	for eff in effects:
		# we're going to cycle through each effect on the selected character
		for st in eff.process:
			if st.has("time"):
				if st["time"] == time_key:
					
					checkProcessStack(st, eff)
#					print("Status " + eff.name + " would process right now!")
					

static func checkProcessStack(process, status):
	match process["type"]:
		"REDUCE": _REDUCE(process, status)
		"INTERRUPT": _INTERRUPT(process, status)

static func _REDUCE(process, status):
	var psTarget = status.attached
	var psSource = status.source
	
	match process["stat"]:
		"CURRENT_HEALTH":
			if process["reduce"] == "FLAT":
				psTarget.character.removeHP(process["power"])
			elif process["reduce"] == "PERCENT":
				var htr = psTarget.character.base_health * (0.01 * process["power"])
				psTarget.character.removeHP(htr)
		_:
			# this is the generic stat
			var n
			if process["reduce"] == "PERCENT":
				n = -(0.01 * process["power"])
			else:
				n = process["power"]
			var newMod = { "MOD_TYPE":process["reduce"], "MOD":n, "SOURCE":psSource }
			psTarget.character.addStatModifier(process["stat"],newMod)

static func _INTERRUPT(process,status):
	var psTarget = status.attached
	var psSource = status.source
	print("Interrupt!")
	psTarget.action = null