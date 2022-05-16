extends Tower
class_name Base

var starting_alliance

func set_alliance(value):
	.set_alliance(value)
	if starting_alliance and starting_alliance != alliance:
		queue_free()

func _ready():
	starting_alliance = alliance
