extends Node2D
class_name Creature

enum ALLIANCE {
	FRIEND,
	FOE
}

export(ALLIANCE) var alliance = ALLIANCE.FRIEND setget set_alliance
export(Resource) var stats setget set_stats

var targets = []

onready var sprite: = $Sprite
onready var targetFinder: = $TargetFinder
onready var defaultTarget: = $DefaultTarget
onready var attackTimer: = $AttackTimer
onready var healthBar: = $HealthBar

func set_alliance(value):
	alliance = value
	match alliance:
		ALLIANCE.FRIEND: update_direction_facing(1)
		ALLIANCE.FOE: update_direction_facing(-1)

func set_stats(value):
	stats = value
	if not stats is CreatureStats: return
	var sprite = find_node("Sprite")
	if sprite: sprite.texture = stats.sprite

func update_direction_facing(direction):
	var sprite = find_node("Sprite")
	if sprite is Sprite: sprite.scale.x = direction
	var defaultTarget = find_node("DefaultTarget")
	if defaultTarget is Position2D: defaultTarget.position.x = direction * 32

func _ready():
	self.stats = stats.duplicate()
	if stats is CreatureStats:
		stats.connect("no_health", self, "queue_free")
		stats.connect("health_changed", self, "update_health_bar")

func _physics_process(delta):
	var target = prioritize_target()
	var target_direction = target.global_position - global_position
	var target_distance = target_direction.length()
	if target_distance > stats.attack_range * 16 or target is Position2D:
		var velocity = Vector2.ZERO.move_toward(target_direction, stats.speed * delta)
		translate(velocity)
	else:
		set_physics_process(false)
		target.stats.health -= stats.attack
		attackTimer.start(1.0 / float(stats.attacks_per_second))
		yield(attackTimer, "timeout")
		set_physics_process(true)

func prioritize_target():
	if targets.empty(): return defaultTarget
	return targets.front()

func update_health_bar(health, health_change):
	healthBar.max_value = stats.max_health
	healthBar.value = stats.health

func _on_TargetFinder_area_entered(area):
	if area == self: return
	targets.append(area)

func _on_TargetFinder_area_exited(area):
	if area == self: return
	targets.erase(area)
