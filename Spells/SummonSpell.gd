extends Node2D
class_name SummonSpell

var creatureStats: Resource
var amount: int
var CreatureScene: Resource

func cast():
	for i in amount:
		create_creature()

func create_creature():
	var creature = CreatureScene.instance()
	creature.stats = creatureStats.duplicate()
	get_tree().current_scene.add_child(creature)
	creature.global_position = global_position + Vector2(rand_range(-amount, amount), rand_range(-amount, amount))
	queue_free()
