extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if not is_instance_valid(body): continue
		body.stats.attack *= 2
		if CreatureStats.TAGS.SLOW in body.stats.tags: body.stats.attacks_per_second += 2
	if not bodies.empty(): set_physics_process(false)

func _on_Timer_timeout():
	queue_free()
