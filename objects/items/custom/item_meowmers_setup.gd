extends ItemCharSetup

const MEOWMERS_PRANK_PATH := "res://objects/items/resources/active/big_foghorn.tres"

func first_time_setup(player : Player) -> void:
	var stats := player.stats
	player.stats.gags_unlocked['Sound'] = 2
	player.stats.gags_unlocked['Throw'] = 1
	player.stats.gag_effectiveness['Squirt'] = 1.0
	player.stats.doodlechest = true
	player.stats.luck = 1.5
	player.stats.crit_mult = 1.5
	if player.stats.current_active_item:
		player.stats.current_active_item = null
	player.stats.current_active_item = GameLoader.load(MEOWMERS_PRANK_PATH).duplicate()
