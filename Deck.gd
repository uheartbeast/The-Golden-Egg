extends Resource
class_name Deck

export(Array, Resource) var cards = []

func empty() -> bool:
	return cards.empty()

func draw_card() -> PackedScene:
	return cards.pop_front()

func shuffle():
	cards.shuffle()
