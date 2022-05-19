extends Node2D

var creatureStats

func _ready():
	for i in 4:
		create_creature(load("res://Creatures/PlayerCreature.tscn"), load("res://Creatures/WolfStats.tres"))

func create_creature(CreatureScene, stats):
	var creature = CreatureScene.instance()
	creature.stats = stats.duplicate()
	add_child(creature)
	creature.global_position = global_position + Vector2(rand_range(-16, 16), rand_range(-16, 16))
	return creature
	queue_free()
