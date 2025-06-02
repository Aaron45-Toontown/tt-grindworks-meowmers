@tool
extends StatusEffect

const SQUIRT_RESOURCE := preload("res://objects/battle/battle_resources/status_effects/resources/auto_squirt_meowmers.tres")

func apply() -> void:
	manager.s_participant_joined.connect(participant_joined)
	
	for cog in manager.cogs:
		apply_to_cog(cog)

func cleanup() -> void:
	if manager.s_participant_joined.is_connected(participant_joined):
		manager.s_participant_joined.disconnect(participant_joined)

func participant_joined(who: Node3D) -> void:
	if who is Cog:
		apply_to_cog(who)

func apply_to_cog(cog: Cog) -> void:
	var new_boost := create_boost(cog)
	manager.add_status_effect(new_boost)

func create_boost(who: Cog) -> StatusAutoStorm:
	var status_effect := SQUIRT_RESOURCE.duplicate()
	status_effect.target = who
	status_effect.rounds = 0
	return status_effect
