extends VBoxContainer

var playerStats = ReferenceStash.playerStats as PlayerStats

onready var coinLabel = $Coins/Label
onready var manaTexture: = $ManaTexture

func _ready():
	playerStats.connect("coins_changed", self, "_on_coins_changed")
	playerStats.connect("mana_changed", self, "_on_mana_changed")

func _on_coins_changed(coins, coins_change):
	coinLabel.text = str(coins)

func _on_mana_changed(mana, mana_change):
	yield(get_tree(), "idle_frame")
	manaTexture.rect_size.x = mana * 9
