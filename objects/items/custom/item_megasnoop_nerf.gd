extends ItemScript

func on_collect(_item : Item, _model : Node3D) -> void:
	setup()

func on_load(_item : Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_started)

func on_battle_started(battle : BattleManager) -> void:
	battle.s_battle_ended.connect(on_battle_end)

func on_battle_end() -> void:
	var player : Player
	if player.stats.max_hp > 30:
		player.stats.max_hp = 30
	
