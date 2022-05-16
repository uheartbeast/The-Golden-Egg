extends Area2D

func get_collision():
	var areas = get_overlapping_areas()
	if areas.empty(): return null
	else: return areas.front()

func _physics_process(delta):
	var collision = get_collision()
	if not collision: return
	if not owner is Node2D: return

	var direction = collision.global_position.direction_to(owner.global_position)
	owner.translate(direction * delta * 4)
	collision.translate(-direction * delta * 4)
