extends Creature
class_name EnemyCreature

var playerStats = ReferenceStash.playerStats as PlayerStats

func _ready():
	if stats is Stats:
		stats.connect("no_health", self, "killed")

func killed():
	playerStats.calculate_coin_drop(stats.max_health, global_position)
	
