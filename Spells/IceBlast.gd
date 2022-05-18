extends Area2D

const FrozenBehaviorScript = preload("res://Behaviors/FrozenBehavior.gd")

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if not is_instance_valid(body): continue
		body.apply_impulse(body.global_position, (body.global_position - global_position).normalized() * 200)
		body.stats.health -= 10
		body.change_behavior(FrozenBehaviorScript)
	if not bodies.empty(): set_physics_process(false)


func _on_Timer_timeout():
	queue_free()
