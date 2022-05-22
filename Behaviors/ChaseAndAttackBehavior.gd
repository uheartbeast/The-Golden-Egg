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
	
	if target is GoldenEgg:
		chase(target)
		return
	
	if target_distance > creature.stats.attack_range * 24 or target is Position2D:
		chase(target)
	else:
		creature.mass = 400
		creature.linear_velocity = Vector2.ZERO
		creature.set_physics_process(false)
		timer.start((1.0 / float(creature.stats.attacks_per_second))/2)
		yield(timer, "timeout")
		creature.set_physics_process(true)
		
		creature.set_physics_process(false)
		creature.attack(target)
		timer.start((1.0 / float(creature.stats.attacks_per_second))/2)
		yield(timer, "timeout")
		creature.set_physics_process(true)
		creature.mass = creature.stats.size

func chase(target):
	var target_direction = target.global_position - creature.global_position
	var velocity = Vector2.ZERO.move_toward(target_direction, creature.stats.speed)
	if velocity.x != 0: creature.update_direction_facing(sign(velocity.x))
	creature.linear_velocity = velocity

func prioritize_target():
	match creature.alliance:
		creature.ALLIANCE.FRIEND: return ReferenceStash.enemyTargetsStash.get_nearestTarget(creature.global_position)
		creature.ALLIANCE.FOE: return ReferenceStash.playerTargetsStash.get_nearestTarget(creature.global_position)
