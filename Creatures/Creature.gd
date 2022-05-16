extends Unit
class_name Creature

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
	if stats is Stats:
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
		if target is Tower:
			target.alliance_meter -= stats.attack * (alliance-1)
		else:
			target.stats.health -= stats.attack
		attackTimer.start(1.0 / float(stats.attacks_per_second))
		yield(attackTimer, "timeout")
		set_physics_process(true)

func prioritize_target():
	var enemy_distance = 1000
	var nearest_enemy
	var tower
	for target in targets:
		if target.alliance == alliance: continue
		if target is Tower:
			tower = target
			continue
		var distance = global_position.distance_to(target.global_position)
		if distance < enemy_distance:
			enemy_distance = distance
			nearest_enemy = target
	if nearest_enemy: return nearest_enemy
	if tower: return tower
	return defaultTarget

func update_health_bar(health, health_change):
	healthBar.max_value = stats.max_health
	healthBar.value = stats.health

func _on_TargetFinder_area_entered(area):
	if area == self: return
	targets.append(area)

func _on_TargetFinder_area_exited(area):
	if area == self: return
	targets.erase(area)
