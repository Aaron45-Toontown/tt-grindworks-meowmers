extends ItemScriptActive

const BUBBLE := preload('res://objects/battle/effects/shield/shield.tscn')
const SFX := preload("res://audio/sfx/items/laff_boost_pickup.ogg")
const SFX_PRESS := preload("res://audio/sfx/items/laff_boost_pickup.ogg")
var shield_used := false
var player: Player
var battlemanager := BattleManager
var do_damage = battlemanager.battle_do_damage
var stat: String = 'defense'

func do_battle_text_shield(text: String) -> void:
	var battle_manager: BattleManager = BattleService.ongoing_battle
	if is_instance_valid(battle_manager):
		battle_manager.battle_text(Util.get_player(), text, Color('FFCB30'), Color('7F6518'))

func use() -> void:
	super()
	var manager := BattleService.ongoing_battle
	if manager is not BattleManager:
		return
	BattleService.ongoing_battle.s_round_ended.connect(on_round_end)
	AudioManager.play_sound(SFX_PRESS)
	do_battle_text_shield("SHIELD UP!")
	shield_apply()

func shield_apply():
	do_damage = false

func shield_expire():
	do_damage = true

func on_round_end(_actions) -> void:
	shield_used = true
	do_battle_text_shield("SHIELD DOWN!")
	shield_expire()
