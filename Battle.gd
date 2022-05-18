extends YSort

const Creature = preload("res://Creatures/Creature.tscn")
const Blast = preload("res://Spells/Blast.tscn")

func _ready():
	for i in 20:
		create_creature(Creature, Unit.ALLIANCE.FOE, preload("res://Creatures/WolfStats.tres"))

func create_creature(Creature, alliance, stats):
	var creature = Creature.instance()
	creature.alliance = alliance
	
	creature.stats = stats.duplicate()
	add_child(creature)
	creature.global_position = $Position2D.global_position + Vector2(rand_range(-16, 16), rand_range(-16, 16))
	return creature

func _on_EnemyTimer_timeout():
	pass
#	create_creature(Rat, Unit.ALLIANCE.FOE, load("res://Creatures/RatStats.tres"))

func _input(event):
	if event.is_action_pressed("mouse_left"):
		var blast = Blast.instance()
		
		blast.position = event.position
		add_child(blast)
		print("hi")

func end_game():
	get_tree().change_scene("res://Screens/DefeatScreen.tscn")

func _on_Creature10_tree_exited():
	call_deferred("end_game")
	
