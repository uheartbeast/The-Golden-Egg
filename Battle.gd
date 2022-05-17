extends YSort

const Rat = preload("res://Creatures/Creature.tscn")

onready var playerBase: = $Base
onready var enemyBase: = $Base2
onready var baseOutline: = $Base/BaseOutline

func _physics_process(delta):
	baseOutline.visible = (ReferenceStash.selectedCard is Card)

func create_creature(Creature, alliance, stats):
	var base = playerBase
	if alliance == Unit.ALLIANCE.FOE: base = enemyBase
	if not base: return null
	var creature = Creature.instance()
	creature.alliance = alliance
	creature.stats = stats.duplicate()
	add_child(creature)
	creature.global_position = base.global_position + Vector2(rand_range(-2, 2), rand_range(-2, 2))
	return creature

func _on_EnemyTimer_timeout():
	create_creature(Rat, Unit.ALLIANCE.FOE, load("res://Creatures/RatStats.tres"))

func _on_Base_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left"):
		var card = ReferenceStash.selectedCard
		if card is Card:
			var unit = create_creature(Rat, Unit.ALLIANCE.FRIEND, card.creatureStats.duplicate())
			card.queue_free()
			ReferenceStash.selectedCard = null

func _on_Base2_tree_exited():
	if get_tree(): get_tree().change_scene("res://Screens/VictoryScreen.tscn")
