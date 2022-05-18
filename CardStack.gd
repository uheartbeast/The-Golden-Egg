extends TextureRect
class_name CardStack

export(Resource) var deck

func _ready():
	deck.shuffle()

func empty() -> bool:
	return deck.empty()

func draw_card() -> PackedScene:
	var card = deck.draw_card()
	if empty(): hide()
	else: show()
	return card
