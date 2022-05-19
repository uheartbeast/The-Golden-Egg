extends Node

var selectedCard
var hand

var playerTargetsStash = load("res://PlayerTargetsStash.tres")
var enemyTargetsStash = load("res://EnemyTargetsStash.tres")
var discardPile = load("res://DiscardPile.tres")
var playerStats = load("res://PlayerStats.tres")

static func get_nearest_node(position, node_list):
	if node_list.empty(): return null
	var nearestTarget = node_list.front()
	for i in range(1, node_list.size()):
		var target = node_list[i]
		if position.distance_to(target.global_position) < position.distance_to(nearestTarget.global_position):
			nearestTarget = target
	return nearestTarget
