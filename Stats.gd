extends Resource
class_name Stats

export(int) var max_health setget set_max_health
var health setget set_health

signal no_health
signal health_changed(health, changed_health)

func set_max_health(value):
	max_health = value
	health = max_health

func set_health(value):
	var previous_health = health
	health = value
	if health != previous_health: emit_signal("health_changed", health, health-previous_health)
	if health <= 0: emit_signal("no_health")
