extends ItemCharSetup

const MEGASNOOP_PRANK_PATH := "res://objects/items/resources/active/gag_button.tres"

func first_time_setup(player : Player) -> void:
	var stats := player.stats
	player.stats.gags_unlocked['Sound'] = 2
	player.stats.funny_dance = true
	if player.stats.current_active_item:
		player.stats.current_active_item = null
	player.stats.current_active_item = GameLoader.load(MEGASNOOP_PRANK_PATH).duplicate()
