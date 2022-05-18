extends Resource
class_name TargetStash

var targets = []

signal empty

func add_target(target):
	if target in targets: return
	targets.append(target)

func remove_target(target):
	targets.erase(target)
	if targets.empty(): emit_signal("empty")

func get_nearestTarget(position: Vector2) -> Node2D:
	if targets.empty(): return null
	var nearestTarget = targets.front()
	for i in range(1, targets.size()):
		var target = targets[i]
		if position.distance_to(target.global_position) < position.distance_to(nearestTarget.global_position):
			nearestTarget = target
	return nearestTarget
