extends Area2D
class_name Unit

enum ALLIANCE {
	FRIEND,
	NEUTRAL,
	FOE,
}

export(ALLIANCE) var alliance = ALLIANCE.FRIEND setget set_alliance
export(Resource) var stats setget set_stats

onready var healthBar: = $HealthBar

func set_alliance(value):
	alliance = value

func set_stats(value):
	stats = value

func _ready():
	self.stats = stats.duplicate()
	if stats is CreatureStats:
		stats.connect("no_health", self, "queue_free")
		stats.connect("health_changed", self, "update_health_bar")

func update_health_bar(health, health_change):
	healthBar.max_value = stats.max_health
	healthBar.value = stats.health
