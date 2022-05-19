extends VBoxContainer

var playerStats = ReferenceStash.playerStats

onready var coinLabel = $Coins/Label

func _ready():
	playerStats.connect("coins_changed", self, "_on_coins_changed")

func _on_coins_changed(coins, coins_change):
	coinLabel.text = str(coins)
