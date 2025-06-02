@tool
extends StatusEffect
class_name StatusAutoStorm

@export var squirt_gag: GagSquirt

func apply() -> void:
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

func round_started(_actions: Array[BattleAction]) -> void:
	var new_squirt: GagSquirt = squirt_gag.duplicate()
	new_squirt.targets = [target]
	new_squirt.user = Util.get_player()
	new_squirt.special_action_exclude = true
	new_squirt.skip_button_movie = true
	new_squirt.do_damage = false
	manager.inject_battle_action(new_squirt, 0)

func get_icon() -> Texture2D:
	return squirt_gag.icon

func get_status_name() -> String:
	return "Oncoming Storm"

func get_description() -> String:
	return "Will be drenched"
