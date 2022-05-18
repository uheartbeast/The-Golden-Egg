extends Behavior
class_name ChaseAndAttackBehavior

var timer

func _ready():
	timer = Timer.new()
	add_child(timer)

func execute():
	if not creature is Creature: return
	var target = prioritize_target()
	if not is_instance_valid(target):
		creature.linear_velocity = Vector2.ZERO
		return
	var target_direction = target.global_position - creature.global_position
	var target_distance = target_direction.length()
	if target_distance > creature.stats.attack_range * 24 or target is Position2D:
		var velocity = Vector2.ZERO.move_toward(target_direction, creature.stats.speed)
		if velocity.x != 0: creature.update_direction_facing(sign(velocity.x))
		creature.linear_velocity = creature.linear_velocity.move_toward(velocity, creature.stats.speed)
	else:
		creature.linear_velocity = creature.linear_velocity.move_toward(Vector2.ZERO, 20)
		creature.set_physics_process(false)
		target.stats.health -= creature.stats.attack
		timer.start(1.0 / float(creature.stats.attacks_per_second))
		yield(timer, "timeout")
		creature.set_physics_process(true)

func prioritize_target():
	match creature.alliance:
		creature.ALLIANCE.FRIEND: return ReferenceStash.enemyTargetsStash.get_nearestTarget(creature.global_position)
		creature.ALLIANCE.FOE: return ReferenceStash.playerTargetsStash.get_nearestTarget(creature.global_position)
