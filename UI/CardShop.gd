extends CenterContainer

var startingDeck = ReferenceStash.startingDeck as Deck
var playerStats = ReferenceStash.playerStats as PlayerStats

export(Array, PackedScene) var card_list

onready var buyButton: = find_node("BuyButton")
onready var cards: = find_node("Cards")
onready var cardCosts: = find_node("CardCosts")
onready var notEnough: = find_node("NotEnough")

signal card_purchased(CardScene)
signal skipped

func _ready():
	fill_shop()

func fill_shop():
	ReferenceStash.selectedCard = null
	for card in cards.get_children():
		card.queue_free()
	
	card_list.shuffle()
	var new_cards = []
	for i in 3:
		var card = card_list[i].instance()
		cards.add_child(card)
		card.set_tag(card.cost)
	Events.emit_signal("enable_cards")

func _physics_process(delta):
	var selectedCard = ReferenceStash.selectedCard
	buyButton.visible = (ReferenceStash.selectedCard is Card) and (playerStats.coins >= selectedCard.cost)
	notEnough.visible = (ReferenceStash.selectedCard is Card) and (playerStats.coins < selectedCard.cost)

func _on_BuyButton_pressed():
	var selectedCard = ReferenceStash.selectedCard
	if not selectedCard is Card: return
	if playerStats.coins >= selectedCard.cost:
		selectedCard.hide_tag()
		emit_signal("card_purchased", load(selectedCard.filename))
		playerStats.coins -= selectedCard.cost
	selectedCard.set_hover(false)
	ReferenceStash.selectedCard = null

func _on_PassButton_pressed():
	var selectedCard = ReferenceStash.selectedCard
	if selectedCard is Card:
		selectedCard.set_hover(false)
		ReferenceStash.selectedCard = null
	emit_signal("skipped")
