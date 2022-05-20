extends Behavior
class_name IdleBehavior

func _ready():
	Events.connect("activate_units", self, "_on_activate_units")

func execute():
	pass

func _on_activate_units():
	creature.change_behavior(creature.defaultBehaviorScript)
