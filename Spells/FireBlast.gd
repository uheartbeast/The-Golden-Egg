extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if not is_instance_valid(body): continue
		var damage = 100
		if CreatureStats.TAGS.ICE in body.stats.tags: damage = damage * 3
		body.apply_impulse(body.global_position, (body.global_position - global_position).normalized() * 800)
		body.stats.health -= damage
	if not bodies.empty(): set_physics_process(false)

func _on_Timer_timeout():
	queue_free()
