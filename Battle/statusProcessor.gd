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
					print("Status " + eff.name + " would process right now!")
					print(battler.character.getMight())
					