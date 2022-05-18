extends RigidBody2D
class_name Creature

enum ALLIANCE {
	FRIEND,
	FOE,
}

var targets = []

export(ALLIANCE) var alliance = ALLIANCE.FRIEND
export(Resource) var stats setget set_stats

onready var sprite: = $Sprite
onready var targetFinder: = $TargetFinder
onready var attackTimer: = $AttackTimer
onready var healthBar: = $HealthBar

func set_stats(value):
	stats = value
	if not stats is CreatureStats: return
	var sprite = find_node("Sprite")
	if sprite: sprite.texture = stats.sprite

func update_direction_facing(direction):
	var sprite = find_node("Sprite")
	if sprite is Sprite: sprite.scale.x = direction

func _ready():
	match alliance:
		ALLIANCE.FRIEND: ReferenceStash.playerTargetsStash.add_target(self)
		ALLIANCE.FOE: ReferenceStash.enemyTargetsStash.add_target(self)
	self.stats = stats.duplicate()
	if stats is Stats:
		stats.connect("no_health", self, "queue_free")
		stats.connect("health_changed", self, "update_health_bar")

func _physics_process(delta):
	var target = prioritize_target()
	if not is_instance_valid(target):
		linear_velocity = Vector2.ZERO
		return
	var target_direction = target.global_position - global_position
	var target_distance = target_direction.length()
	if target_distance > stats.attack_range * 24 or target is Position2D:
		var velocity = Vector2.ZERO.move_toward(target_direction, stats.speed)
		if velocity.x != 0: update_direction_facing(sign(velocity.x))
		linear_velocity = linear_velocity.move_toward(velocity, stats.speed)
	else:
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, 20)
		set_physics_process(false)
		target.stats.health -= stats.attack
		attackTimer.start(1.0 / float(stats.attacks_per_second))
		yield(attackTimer, "timeout")
		set_physics_process(true)

func prioritize_target():
	match alliance:
		ALLIANCE.FRIEND: return ReferenceStash.enemyTargetsStash.get_nearestTarget(global_position)
		ALLIANCE.FOE: return ReferenceStash.playerTargetsStash.get_nearestTarget(global_position)

func update_health_bar(health, health_change):
	healthBar.max_value = stats.max_health
	healthBar.value = stats.health

func _on_TargetFinder_area_entered(area):
	if area == self: return
	targets.append(area)

func _on_TargetFinder_area_exited(area):
	if area == self: return
	targets.erase(area)

func _on_Creature_tree_exiting():
	match alliance:
		ALLIANCE.FRIEND:
			ReferenceStash.playerTargetsStash.remove_target(self)
		ALLIANCE.FOE:
			ReferenceStash.enemyTargetsStash.remove_target(self)
