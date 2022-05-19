extends RigidBody2D
class_name Creature

const Projectile = preload("res://Projectile.tscn")

enum ALLIANCE {
	FRIEND,
	FOE,
}

var targets = []
var defaultBehaviorScript

export(ALLIANCE) var alliance = ALLIANCE.FRIEND
export(Resource) var stats setget set_stats

onready var sprite: = $Sprite
onready var targetFinder: = $TargetFinder
onready var attackTimer: = $AttackTimer
onready var healthBar: = $HealthBar
onready var behavior: = $ChaseAndAttackBehavior

func set_stats(value):
	stats = value
	if not stats is CreatureStats: return
	var sprite = find_node("Sprite")
	if sprite: sprite.texture = stats.sprite

func update_direction_facing(direction):
	var sprite = find_node("Sprite")
	if sprite is Sprite: sprite.scale.x = direction

func _ready():
	defaultBehaviorScript = behavior.get_script()
	match alliance:
		ALLIANCE.FRIEND: ReferenceStash.playerTargetsStash.add_target(self)
		ALLIANCE.FOE: ReferenceStash.enemyTargetsStash.add_target(self)
	self.stats = stats.duplicate()
	if stats is Stats:
		stats.connect("no_health", self, "queue_free")
		stats.connect("health_changed", self, "update_health_bar")

func _physics_process(_delta):
	behavior.execute()

func change_behavior(NewBehaviorScript):
	behavior.queue_free()
	behavior = NewBehaviorScript.new()
	add_child(behavior)
	behavior.creature = self
	set_physics_process(true)

func attack(target):
	if stats.attack_range == 1:
		target.stats.health -= stats.attack
	elif stats.attack_range > 1:
		var projectile = Projectile.instance()
		projectile.damage = stats.attack
		projectile.target = target
		projectile.direction = global_position.direction_to(target.global_position)
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = global_position

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
