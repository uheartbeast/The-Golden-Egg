extends CenterContainer

var startingDeck = ReferenceStash.startingDeck as Deck

onready var buyButton: = find_node("BuyButton")

signal card_purchased(CardScene)

func _ready():
	ReferenceStash.selectedCard = null

func _physics_process(delta):
	buyButton.visible = (ReferenceStash.selectedCard is Card)

func _on_BuyButton_pressed():
	var selectedCard = ReferenceStash.selectedCard
	if not selectedCard is Card: return
	print("buy card")
	emit_signal("card_purchased", load(selectedCard.filename))
	selectedCard.set_hover(false)
	ReferenceStash.selectedCard = null
