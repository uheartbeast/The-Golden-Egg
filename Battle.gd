extends YSort

const EnemyCreature = preload("res://Creatures/EnemyCreature.tscn")

var EnemyStatsList = [
	preload("res://Creatures/WolfStats.tres"),
	preload("res://Creatures/RatStats.tres"),
]

var discardPile = ReferenceStash.discardPile

onready var hand: Hand = find_node("Hand")
onready var cardStack: CardStack = find_node("CardStack")
onready var startRoundButton: Button = find_node("StartRoundButton")

func _ready():
	ReferenceStash.enemyTargetsStash.connect("empty", self, "_on_enemyTargetsStash_empty")

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
			shuffle_discard_pile_into_deck()
			CardScene = cardStack.draw_card()
		hand.add_card(CardScene)

func shuffle_discard_pile_into_deck():
	discardPile.shuffle()
	cardStack.deck.cards = discardPile.cards.duplicate()
	discardPile.clear()

func create_creature(CreatureScene, stats):
	var creature = CreatureScene.instance()
	creature.stats = stats.duplicate()
	add_child(creature)
	creature.global_position = $Position2D.global_position + Vector2(rand_range(-16, 16), rand_range(-16, 16))
	return creature

func _on_enemyTargetsStash_empty():
	startRoundButton.show()

func _input(event):
	if event.is_action_pressed("mouse_right"):
		var card = ReferenceStash.selectedCard
		if not card is Card: return
		card.set_hover(false)
		ReferenceStash.selectedCard = null
	
	if event.is_action_pressed("mouse_left"):
		var card = ReferenceStash.selectedCard
		if not card is Card: return
		if not card.spell is PackedScene: return
		var spell = card.spell.instance()
		spell.position = event.position
		add_child(spell)
		discardPile.add_card(load(card.filename))
		hand.remove_child(card)
		ReferenceStash.selectedCard = null

func end_game():
	get_tree().change_scene("res://Screens/DefeatScreen.tscn")

func _on_Creature10_tree_exited():
	call_deferred("end_game")

func _on_StartRoundButton_pressed():
	startRoundButton.hide()
	call_deferred("start_round")
