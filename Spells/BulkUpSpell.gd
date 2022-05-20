extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if not is_instance_valid(body): continue
		
		body.animationPlayer.play("Buff")
		body.stats.health *= 1.25
		if CreatureStats.TAGS.SMALL in body.stats.tags:
			body.stats.health += 100
		
	if not bodies.empty(): set_physics_process(false)


func _on_Timer_timeout():
	queue_free()
