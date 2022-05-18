extends Behavior
class_name FrozenBehavior

func execute():
	var timer = Timer.new()
	add_child(timer)
	creature.linear_velocity = creature.linear_velocity.move_toward(Vector2.ZERO, 20)
	var previous_mass = creature.mass
	creature.mass = 500
	creature.modulate = Color.aqua
	timer.start(4.0)
	yield(timer, "timeout")
	creature.mass = previous_mass
	creature.modulate = Color.white
	creature.change_behavior(creature.defaultBehaviorScript)
