extends Control
class_name Card

export(PackedScene) var spell

var hover = false setget set_hover

onready var cardImage: = $CardImage

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
