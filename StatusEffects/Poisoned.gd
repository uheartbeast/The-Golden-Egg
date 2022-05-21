extends Node2D

func set_duration(time):
	$Duration.start(time)

func _on_Frequency_timeout():
	var parent = get_parent()
	if not parent is Creature: return
	parent.stats.health -= 20

func _on_Duration_timeout():
	var parent = get_parent()
	if not parent is Creature: return
	parent.poisoned = null
	queue_free()
