extends Resource
class_name Deck

export(Array, PackedScene) var cards = []

func empty() -> bool:
	return cards.empty()

func draw_card() -> PackedScene:
	return cards.pop_front()

func add_card(card: PackedScene):
	cards.append(card)

func shuffle():
	cards.shuffle()

func clear():
	cards = []
