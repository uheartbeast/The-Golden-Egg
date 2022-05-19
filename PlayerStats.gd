extends Stats
class_name PlayerStats

const MAX_COINS_DAMAGE = 1000

export(int) var max_mana = 5 setget set_max_mana

var mana = 1 setget set_mana
var coins = 0 setget set_coins
var coins_damage = 0 setget set_coins_damage
var coins_to_drop = 0

signal coins_changed(coins, coins_change)
signal coins_dropped(amount, position)
signal mana_changed(mana, mana_change)

func set_max_mana(value):
	max_mana = value
	mana = max_mana

func set_mana(value):
	var previous_mana = mana
	mana = max(value, 0)
	emit_signal("mana_changed", mana, mana-previous_mana)

func set_coins(value):
	var previous_coins = coins
	coins = value
	if coins != previous_coins: emit_signal("coins_changed", coins, coins-previous_coins)

func set_coins_damage(value):
	coins_damage =  value
	while coins_damage >= MAX_COINS_DAMAGE:
		coins_damage = coins_damage - MAX_COINS_DAMAGE
		coins_to_drop += 1

func refresh_mana():
	set_mana(max_mana)

func calculate_coin_drop(coins_damage_change, position):
	self.coins_damage += coins_damage_change
	if coins_to_drop > 0:
		emit_signal("coins_dropped", coins_to_drop, position)
		coins_to_drop = 0
