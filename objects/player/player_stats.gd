extends BattleStats
class_name PlayerStats

## For all stats that are specific to the player

## Money
@export var money := 0:
	set(x):
		if x > money:
			s_gained_money.emit()
		money = x
		if money < 0:
			money = 0
		s_money_changed.emit(x)
		if money > 100:
			Globals.s_hundred_jellybeans.emit()
signal s_money_changed(value: int)
signal s_gained_money

@export var items: Array[Item] = []

## Gag Dicts
@export var gags_unlocked: Dictionary[String, int] = {}
@export var gag_balance: Dictionary[String, int] = {}
var debug_gag_points := false
@export var gag_effectiveness: Dictionary[String, float] = {}
@export var gag_regeneration: Dictionary[String, int] = {}
@export var gag_vouchers: Dictionary[String, int] = {}
@export var gag_battle_start_point_boost: Dictionary[String, int] = {}
@export var global_battle_start_point_boost := 0
@export var toonups: Dictionary[int, int] = {0: 1, 1: 1, 2: 1, 3: 1, 4: 1, 5: 1, 6: 0}
@export var treasures: Dictionary[int, int] = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0}

@export var gag_cap := 10
@export var gag_discount := -1
@export var character: PlayerCharacter
@export var quests: Array[Quest]
@export var quest_rerolls := 3
@export var pink_slips := 0
@export var luck := 1.0:
	set(x):
		luck = x
		s_luck_changed.emit(x)
		print("Luck set to %.2f" % x)

@export var crit_mult := 1.25
@export var mod_cog_dmg_mult := 1.0
@export var shop_discount := 0
@export var healing_effectiveness := 1.0

# Gag specific boosts
@export var throw_heal_boost := 0.15
@export var squirt_defense_boost := 0.8
@export var drop_aftershock_round_boost := 0
@export var trap_knockback_percent := 0.0

@export var anomaly_boost := 0
# Extra value on laff boosts
@export var laff_boost_boost := 0
@export var extra_lives := 0:
	set(x):
		extra_lives = x
		s_extra_lives_changed.emit(x)
signal s_extra_lives_changed(value: int)
signal s_luck_changed(new_luck: float)

@export var toonup_boost := 0.0

@export var sellbot_boost := 1.0
@export var cashbot_boost := 1.0
@export var lawbot_boost := 1.0
@export var bossbot_boost := 1.0

@export var proxy_chance_boost := 0.0

# How low do cogs HP need to be to die?
@export var cog_hp_death_threshold := 0.0

## Currently held active item
@export var current_active_item : ItemActive:
	set(x):
		current_active_item = x
		s_active_item_changed.emit(x)
signal s_active_item_changed(new_item : ItemActive)

@export var battle_timers : Array[int] = []

## For pause screen display
var prev_stats : Dictionary[String, float] = {}


## Sets the player's base gag loadout
func set_loadout(loadout: GagLoadout) -> void:
	var gag_dicts := [gags_unlocked, gag_balance, gag_effectiveness, gag_regeneration, gag_vouchers, gag_battle_start_point_boost]
	for dict in gag_dicts:
		dict.clear()
		var value 
		match gag_dicts.find(dict):
			0, 5: value = 0
			1: value = 10
			2: value = 1.0
			3: value = 1
			_: value = 1
		for track in loadout.loadout:
			dict[track.track_name] = value

func first_time_setup() -> void:
	if character:
		character = character.duplicate()
		set_loadout(character.gag_loadout)
		if character.base_stats:
			damage = character.base_stats.damage
			defense = character.base_stats.defense
			evasiveness = character.base_stats.evasiveness
			accuracy = character.base_stats.accuracy
			speed = character.base_stats.speed
			turns = character.base_stats.turns
			max_turns = character.base_stats.max_turns
	# Quest setup
	if quests.is_empty():
		for i in 4:
			var new_quest := QuestCog.new()
			new_quest.goal_dept = i as CogDNA.CogDept
			new_quest.setup()
			quests.append(new_quest)

	initialize()

func initialize() -> void:
	hp_changed.connect(attempt_revive)
	start_stat_monitors()

func start_stat_monitors() -> void:
	var stat_monitors := ['damage', 'defense', 'evasiveness', 'speed', 'luck']
	for stat in stat_monitors:
		prev_stats[stat] = get_stat(stat)

func max_out() -> void:
	if character:
		max_hp = 100
		hp = 100
		turns = character.base_stats.max_turns
	for track in gags_unlocked:
		gags_unlocked[track] = 7
		gag_balance[track] = 10
	for key in toonups.keys():
		toonups[key] = 0
	for key in gag_vouchers.keys():
		gag_vouchers[key] = 0

func get_highest_gag_level() -> int:
	return gags_unlocked.values().max()

func on_round_end(_battle: BattleManager) -> void:
	for track in gag_balance.keys():
		if not gags_unlocked[track] > 0: continue
		if gag_regeneration.has(track):
			restock(track, gag_regeneration[track])

func on_battle_started(_battle: BattleManager) -> void:
	for track in gag_balance.keys():
		if not gags_unlocked[track] > 0: continue
		var value: int = gag_battle_start_point_boost.get(track, 0) + global_battle_start_point_boost
		if value != 0:
			restock(track, value)

func restock(track: String, add: int) -> void:
	if debug_gag_points:
		gag_balance[track] = gag_cap
	else:
		gag_balance[track] = min(gag_cap, gag_balance[track] + add)

func attempt_revive(_hp: int) -> void:
	if _hp > 0 or extra_lives <= 0:
		return
	
	extra_lives -= 1
	var revive_amount := maxi(1, Util.get_player().stats.max_hp / 2)
	Util.get_player().quick_heal(revive_amount)
	
	# Create the unite effect
	var unite: GPUParticles3D = load('res://objects/battle/effects/unite/unite.tscn').instantiate()
	Util.get_player().add_child(unite)
	Util.get_player().toon.speak("Toons of the world, Toon-Up!")
	AudioManager.play_sound(load("res://audio/sfx/misc/Holy_Mackerel.ogg"))

	print('Revived!')

func add_money(amount: int) -> void:
	money += amount
	SaveFileService.progress_file.jellybeans_collected += amount

func charge_active_item(amount := 1) -> void:
	if current_active_item:
		current_active_item.current_charge += amount

func has_item(item_name : String) -> bool:
	for item in items:
		if item.item_name == item_name:
			return true
	return false

func get_battle_time() -> int:
	if battle_timers.is_empty():
		return -1
	else:
		return battle_timers.min()
