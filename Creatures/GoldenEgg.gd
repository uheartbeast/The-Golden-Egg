extends StaticBody2D
class_name GoldenEgg

func _ready():
	ReferenceStash.playerTargetsStash.add_target(self)

func crack():
	ReferenceStash.playerTargetsStash.remove_target(self)
	queue_free()

func _on_EggHurtbox_body_entered(body):
	if body is EnemyCreature:
		crack()
