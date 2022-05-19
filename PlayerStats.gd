extends Stats
class_name PlayerStats

export(int) var max_mana = 5 setget set_max_mana

var mana = 1
var coins = 0 setget set_coins

signal coins_changed(coins, coins_change)

func set_max_mana(value):
	max_mana = value
	mana = max_mana

func set_coins(value):
	var previous_coins = coins
	coins = value
	if coins != previous_coins: emit_signal("coins_changed", coins, coins-previous_coins)


