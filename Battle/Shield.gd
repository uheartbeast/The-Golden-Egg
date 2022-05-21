extends Area2D
class_name Shield

const MAX_HEALTH = 200

var health = MAX_HEALTH setget set_health

onready var healthBar: = $HealthBar
onready var animationPlayer: = $AnimationPlayer

func set_health(value):
	health = value
	update_healthbar()
	if health <= 0:
		queue_free()

func _ready():
	update_healthbar()

func update_healthbar():
	healthBar.max_value = MAX_HEALTH
	healthBar.value = health

func _on_Shield_body_entered(body):
	if body is EnemyCreature:
		body.queue_free()
		self.health -= 1
		animationPlayer.play("Blink")
