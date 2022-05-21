extends Node2D

var damage: = 25
var speed = 100
var target = null
onready var target_position = global_position
var knockback = 100
var direction = Vector2.ZERO
export(bool) var venom = false
export(PackedScene) var SpellScene

func _physics_process(delta):
	if not target or not is_instance_valid(target):
		queue_free()
		return
	else:
		target_position = target.global_position
	global_position = global_position.move_toward(target_position, speed*delta)
	if global_position == target.global_position: impact()

func impact():
	if SpellScene is PackedScene:
		var spell = SpellScene.instance()
		spell.position = global_position
		get_tree().current_scene.add_child(spell)
	else:
		if is_instance_valid(target) and target:
			target.stats.health -= damage
			if venom:
				if not target.poisoned:
					var poison = load("res://StatusEffects/Poisoned.tscn").instance()
					target.add_child(poison)
					target.poisoned = poison
				else:
					target.poisoned.set_duration(10)
			target.apply_impulse(target.global_position, direction*knockback)
	queue_free()
