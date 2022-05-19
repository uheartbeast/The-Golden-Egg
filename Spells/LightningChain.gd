extends Node2D

var chain_amount = 5
var hit_targets = []

onready var timer: = $Timer
onready var line = $Node/Line2D

func _ready():
	line.add_point(global_position)
	while hit_targets.size() < chain_amount:
		var target = find_target()
		if not target: break
		global_position = target.global_position
		rotation_degrees = rand_range(0, 360)
		line.add_point(global_position)
		target.stats.health -= 250
		hit_targets.append(target)
		timer.start()
		yield(timer, "timeout")
	queue_free()

func find_target():
	var enemy_targets = ReferenceStash.enemyTargetsStash.targets
	var reduced_targets = []
	for target in enemy_targets:
		if target in hit_targets: continue
		reduced_targets.append(target)
	return ReferenceStash.get_nearest_node(global_position, reduced_targets)
