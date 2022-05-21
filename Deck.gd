extends Resource
class_name Deck

export(Array, PackedScene) var cards = [] setget set_cards

signal cards_amount_changed(cards_amount)

func set_cards(value):
	cards = value
	emit_signal("cards_amount_changed", cards.size())

func empty() -> bool:
	return cards.empty()

func draw_card() -> PackedScene:
	var card = cards.pop_front()
	emit_signal("cards_amount_changed", cards.size())
	return card

func add_card(card: PackedScene):
	cards.append(card)
	emit_signal("cards_amount_changed", cards.size())

func shuffle():
	cards.shuffle()

func clear():
	cards = []
	emit_signal("cards_amount_changed", cards.size())
