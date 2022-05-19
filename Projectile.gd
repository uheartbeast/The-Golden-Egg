extends Node2D

var damage: = 25
var speed = 10
var target = null
var knockback = 500
var direction = Vector2.ZERO
export(PackedScene) var SpellScene

func _ready():
	if not target: return
	direction = global_position.direction_to(target.global_position)

func _physics_process(delta):
	if not target or not is_instance_valid(target):
		queue_free()
		return
	global_position = global_position.move_toward(target.global_position, speed)
	if global_position == target.global_position: impact()

func impact():
	if SpellScene is PackedScene:
		var spell = SpellScene.instance()
		spell.position = global_position
		get_tree().current_scene.add_child(spell)
	else:
		target.stats.health = damage
		print(direction*knockback)
		target.apply_impulse(target.global_position, direction*knockback)
	queue_free()
