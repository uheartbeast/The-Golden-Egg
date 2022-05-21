extends Node2D

onready var tagLabel: = find_node("TagLabel")

func set_price(value):
	tagLabel.text = str(value)
