extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if not is_instance_valid(body): continue
		body.apply_impulse(body.global_position, (body.global_position - global_position).normalized() * 300)
		body.stats.health -= 100
	if not bodies.empty(): set_physics_process(false)


func _on_Timer_timeout():
	queue_free()
