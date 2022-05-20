extends Node

const EnemyCreature = preload("res://Creatures/EnemyCreature.tscn")

export(Array, Resource) var EnemyGroups = []

func spawn_group(level, front_location, back_location):
	assert(not EnemyGroups.empty())
	var group = EnemyGroups[min(level, EnemyGroups.size()-1)] as EnemyGroup
	for i in group.front_enemies_count:
		var enemyStats = group.FrontEnemies[rand_range(0, group.FrontEnemies.size())]
		var enemy = EnemyCreature.instance()
		enemy.stats = enemyStats.duplicate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = front_location + Vector2(rand_range(-i, i), rand_range(-i, i))
	
	for i in group.back_enemies_count:
		var enemyStats = group.BackEnemies[rand_range(0, group.BackEnemies.size())]
		var enemy = EnemyCreature.instance()
		enemy.stats = enemyStats.duplicate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = back_location + Vector2(rand_range(-i, i), rand_range(-i, i))
