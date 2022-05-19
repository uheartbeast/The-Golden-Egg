extends CenterContainer

var startingDeck = ReferenceStash.startingDeck as Deck
var playerStats = ReferenceStash.playerStats as PlayerStats

onready var buyButton: = find_node("BuyButton")
onready var cards: = find_node("Cards")
onready var cardCosts: = find_node("CardCosts")
onready var notEnough: = find_node("NotEnough")

signal card_purchased(CardScene)
signal skipped

func _ready():
	ReferenceStash.selectedCard = null
	var cardCostContainers = cardCosts.get_children()
	var cardNodes = cards.get_children()
	for i in cards.get_child_count():
		var card = cardNodes[i]
		var cardCost = cardCostContainers[i].get_child(1)
		cardCost.text = str(card.cost)

func _physics_process(delta):
	var selectedCard = ReferenceStash.selectedCard
	buyButton.visible = (ReferenceStash.selectedCard is Card) and (playerStats.coins >= selectedCard.cost)
	notEnough.visible = (ReferenceStash.selectedCard is Card) and (playerStats.coins < selectedCard.cost)

func _on_BuyButton_pressed():
	var selectedCard = ReferenceStash.selectedCard
	if not selectedCard is Card: return
	if playerStats.coins <= selectedCard.cost:
		emit_signal("card_purchased", load(selectedCard.filename))
		playerStats.coins -= selectedCard.cost
	selectedCard.set_hover(false)
	ReferenceStash.selectedCard = null

func _on_PassButton_pressed():
	emit_signal("skipped")