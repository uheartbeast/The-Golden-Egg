extends Control
class_name Card

export(int) var cost = 2
export(PackedScene) var SpellScene

var hover = false setget set_hover

onready var cardImage: = $CardImage

func set_hover(value):
	hover = value
	if hover: cardImage.self_modulate = Color.darkgray
	else: cardImage.self_modulate = Color.black

func _on_Card_gui_input(event):
	if event.is_action_pressed("mouse_left"):
		var previousSelection = ReferenceStash.selectedCard
		if previousSelection is Control:
			previousSelection.set_hover(false)
		ReferenceStash.selectedCard = self
		self.hover = true
		get_tree().set_input_as_handled()

func play(target_position):
	var spell = SpellScene.instance()
	spell.position = target_position
	get_tree().current_scene.add_child(spell)
	ReferenceStash.selectedCard = null
	return spell

func _on_Card_mouse_entered():
	cardImage.rect_position.y = -16

func _on_Card_mouse_exited():
	cardImage.rect_position.y = 0
