extends HBoxContainer
class_name Hand

const Card = preload("res://Cards/Card.tscn")

signal empty()

func _ready():
	ReferenceStash.hand = self

func remove_child(node) -> void:
	.remove_child(node)
	if get_child_count() == 0:
		emit_signal("empty")

func add_card(creatureStats):
	var card = Card.instance()
	add_child(card)
