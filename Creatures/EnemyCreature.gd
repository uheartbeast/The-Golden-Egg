extends Creature
class_name EnemyCreature

var playerStats = ReferenceStash.playerStats as PlayerStats

func killed():
	playerStats.calculate_coin_drop(stats.max_health, global_position)

func _exit_tree():
	killed()
