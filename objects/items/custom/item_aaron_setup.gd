extends ItemCharSetup

const AARON_PRANK_PATH := "res://objects/items/resources/active/sandwich.tres"

func first_time_setup(player : Player) -> void:
	var stats := player.stats
	player.stats.gags_unlocked['Sound'] = 2
	player.stats.gags_unlocked['Drop'] = 1
	player.stats.funny_dance = true
	player.stats.luck = 1.25
	player.stats.crit_mult = 1.25
	if player.stats.current_active_item:
		player.stats.current_active_item = null
	player.stats.current_active_item = GameLoader.load(AARON_PRANK_PATH).duplicate()
