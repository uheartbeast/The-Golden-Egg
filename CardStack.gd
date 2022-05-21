extends TextureRect
class_name CardStack

export(Resource) var deck

onready var amountLabel: = find_node("Amount")

func _ready():
	deck.connect("cards_amount_changed", self, "_on_deck_cards_amount_changed")
	deck.shuffle()
	update_amountLabel(deck.cards.size())

func empty() -> bool:
	return deck.empty()

func update_amountLabel(amount):
	amountLabel.text = "Cards\n"+str(amount)

func draw_card() -> PackedScene:
	var card = deck.draw_card()
	if empty(): hide()
	else: show()
	return card

func _on_deck_cards_amount_changed(cards_amount):
	update_amountLabel(cards_amount)
