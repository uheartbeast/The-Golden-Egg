extends YSort

const EnemyCreature = preload("res://Creatures/EnemyCreature.tscn")

var EnemyStatsList = [
	preload("res://Creatures/WolfStats.tres"),
	preload("res://Creatures/RatStats.tres"),
]

var discardPile = ReferenceStash.discardPile

onready var hand: Hand = find_node("Hand")
onready var cardStack: CardStack = find_node("CardStack")

func _ready():
	ReferenceStash.enemyTargetsStash.connect("empty", self, "_on_enemyTargetsStash_empty")
	call_deferred("start_round")

func start_round():
	for i in 20:
		EnemyStatsList.shuffle()
		var EnemyStats = EnemyStatsList.front()
		create_creature(EnemyCreature, EnemyStats)
	
	draw_cards(5)

func draw_cards(amount: int):
	for i in amount:
		var CardScene = cardStack.draw_card()
		if not CardScene is PackedScene:
			discardPile.shuffle()
			cardStack.deck.cards = discardPile.cards.duplicate()
			discardPile.clear()
		hand.add_card(CardScene)

func create_creature(CreatureScene, stats):
	var creature = CreatureScene.instance()
	creature.stats = stats.duplicate()
	add_child(creature)
	creature.global_position = $Position2D.global_position + Vector2(rand_range(-16, 16), rand_range(-16, 16))
	return creature

func _on_enemyTargetsStash_empty():
	call_deferred("start_round")

func _input(event):
	if event.is_action_pressed("mouse_right"):
		ReferenceStash.selectedCard = null
	
	if event.is_action_pressed("mouse_left"):
		var card = ReferenceStash.selectedCard
		if not card is Card: return
		if not card.spell is PackedScene: return
		var spell = card.spell.instance()
		spell.position = event.position
		add_child(spell)
		hand.remove_child(card)
		discardPile.add_card(card)
		ReferenceStash.selectedCard = null

func end_game():
	get_tree().change_scene("res://Screens/DefeatScreen.tscn")

func _on_Creature10_tree_exited():
	call_deferred("end_game")
	
