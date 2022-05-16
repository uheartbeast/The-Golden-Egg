tool
extends Control
class_name Card

export(Resource) var creatureStats setget set_createrStats

var hover = false setget set_hover

onready var cardImage: = $CardImage
onready var icon: = $CardImage/CenterContainer/Icon

func set_createrStats(value):
	creatureStats = value
	if creatureStats is CreatureStats:
		var icon = find_node("Icon")
		if icon: icon.texture = creatureStats.sprite

func set_hover(value):
	hover = value
	if hover: cardImage.self_modulate = Color.darkgray
	else: cardImage.self_modulate = Color.black

func _on_Card_gui_input(event):
	if event.is_action_pressed("mouse_left"):
		ReferenceStash.selectedCard = self
		self.hover = true

func _on_Card_mouse_entered():
	cardImage.rect_position.y = -16

func _on_Card_mouse_exited():
	cardImage.rect_position.y = 0
