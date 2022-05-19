extends YSort

const EnemyCreature = preload("res://Creatures/EnemyCreature.tscn")

var EnemyStatsList = [
	preload("res://Creatures/WolfStats.tres"),
	preload("res://Creatures/RatStats.tres"),
]

var discardPile = ReferenceStash.discardPile as Deck
var playerStats = ReferenceStash.playerStats as PlayerStats

onready var hand: Hand = find_node("Hand")
onready var cardStack: CardStack = find_node("CardStack")
onready var startRoundButton: Button = find_node("StartRoundButton")
onready var cardShop: Control = find_node("CardShop")

func _ready():
	randomize()
	ReferenceStash.playerStats.connect("coins_dropped", self, "drop_coins")
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

func drop_coins(amount, location):
	for i in amount:
		var coin = load("res://Coin.tscn").instance()
		add_child(coin)
		coin.global_position = location + Vector2(rand_range(-8, 8), rand_range(-8, 8))
		yield(get_tree().create_timer(0.1), "timeout")

func collect_coins():
	var coins = get_tree().get_nodes_in_group("Coins")
	for coin in coins:
		coin.queue_free()
		playerStats.coins += 1

func _on_enemyTargetsStash_empty():
	discard_hand()
	collect_coins()
	yield(get_tree().create_timer(0.5), "timeout")
	cardShop.show()

func _unhandled_input(event):
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

func discard_hand():
	ReferenceStash.selectedCard = null
	for card in hand.get_children():
		discardPile.add_card(load(card.filename))
		hand.remove_child(card)

func end_game():
	get_tree().change_scene("res://Screens/DefeatScreen.tscn")

func _on_Creature10_tree_exited():
	call_deferred("end_game")

func _on_StartRoundButton_pressed():
	startRoundButton.hide()
	call_deferred("start_round")

func _on_CardShop_card_purchased(CardScene):
	cardStack.deck.add_card(CardScene)
	cardStack.deck.shuffle()
	cardShop.hide()
	startRoundButton.show()
