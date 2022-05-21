extends YSort

var discardPile = ReferenceStash.discardPile as Deck
var playerStats = ReferenceStash.playerStats as PlayerStats

onready var hand: Hand = find_node("Hand")
onready var cardStack: CardStack = find_node("CardStack")
onready var startRoundButton: Button = find_node("StartRoundButton")
onready var cardShop: Control = find_node("CardShop")
onready var enemySpawner: = $EnemySpawner
onready var spawnLocation1: = $SpawnLocation1
onready var spawnLocation2: = $SpawnLocation2
onready var spawnLocation3: = $SpawnLocation3
onready var spawn_location_list = [spawnLocation1, spawnLocation2, spawnLocation3]

func _ready():
	randomize()
	playerStats.connect("coins_dropped", self, "drop_coins")
	ReferenceStash.enemyTargetsStash.connect("empty", self, "_on_enemyTargetsStash_empty")
	playerStats.refresh_mana()

func start_round():
	var spawn_locations = 1
	spawn_location_list.shuffle()
	for i in min(spawn_locations, 3):
		var spawnLocation = spawn_location_list[i]
		enemySpawner.spawn_group(playerStats.battle_round, spawnLocation.global_position, spawnLocation.global_position+Vector2(32, 0))
	draw_cards(5)
	Engine.time_scale = 0.2

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
		call_deferred("drop_coin", location)
		yield(get_tree().create_timer(0.1), "timeout")

func drop_coin(location):
	var coin = load("res://Battle/Coin.tscn").instance()
	add_child(coin)
	coin.global_position = location + Vector2(rand_range(-8, 8), rand_range(-8, 8))

func collect_coins():
	var coins = get_tree().get_nodes_in_group("Coins")
	for coin in coins:
		coin.queue_free()
		playerStats.coins += 1

func discard_hand():
	ReferenceStash.selectedCard = null
	for card in hand.get_children():
		discardPile.add_card(load(card.filename))
		hand.remove_child(card)

func kill_units():
	var playerCreatures = get_tree().get_nodes_in_group("PlayerCreatures")
	for playerCreature in playerCreatures:
		playerCreature.queue_free()

func _on_enemyTargetsStash_empty():
	playerStats.battle_round += 1
	discard_hand()
	playerStats.refresh_mana()
	kill_units()
	yield(get_tree().create_timer(0.5), "timeout")
	collect_coins()
	yield(get_tree().create_timer(0.5), "timeout")
	cardShop.fill_shop()
	yield(get_tree(), "idle_frame")
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
		if not card.SpellScene is PackedScene: return
		card.play(event.position)
		hand.remove_child(card)
		discardPile.add_card(load(card.filename))
	
	if event.is_action_pressed("ui_accept"):
		playerStats.mana -= 1

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

func _on_CardShop_skipped():
	cardShop.hide()
	startRoundButton.show()
