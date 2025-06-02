extends ItemScript

const SQUIRT_GAGS := preload("res://objects/battle/battle_resources/gag_loadouts/gag_tracks/squirt.tres")
const AUTO_SQUIRT := preload("res://objects/battle/battle_resources/status_effects/resources/auto_squirt_allcogs.tres")

var player: Player


func on_collect(_item: Item, _object: Node3D) -> void:
	var _player: Player
	if not Util.get_player():
		_player = await Util.s_player_assigned
	else:
		_player = Util.get_player()
	setup(_player)

func on_load(item: Item) -> void:
	on_collect(item, null)

func setup(_player: Player) -> void:
	player = _player
	BattleService.s_battle_started.connect(try_apply_squirt)
	BattleService.s_round_ended.connect(try_apply_squirt)

func try_apply_squirt(manager: BattleManager) -> void:
	# Pick a random cog in the battle and apply the auto-squirt status onto them.
	if manager.cogs:
		var cog: Cog = RandomService.array_pick_random('true_random', manager.cogs)
		var new_status := AUTO_SQUIRT.duplicate()
		new_status.target = cog
		manager.add_status_effect(new_status)

func get_random_squirt_resource() -> GagSquirt:
	var idx: int = 0
	# Min squirt level works as follows:
	# 1 (flowerpot) on floors 0-2
	# 2 (sandbag) on floor 3
	# 3 (anvil) on floor 4
	# 4 (big weight) on floor 5 and directors
	var min_squirt_level: int = max(0, Util.floor_number - 2)
	# Prevent range errors by making sure the max squirt level is at least 1 higher than the min squirt level
	var max_squirt_level: int = max(min_squirt_level, player.stats.get_highest_gag_level() - 1)
	idx = RandomService.randi_range_channel('true_random', min_squirt_level, max_squirt_level)
	return SQUIRT_GAGS.gags[idx].duplicate()
