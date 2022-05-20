extends Control
class_name Card

var playerStats = ReferenceStash.playerStats as PlayerStats

export(int) var cost = 2
export(int) var mana_cost = 1 setget set_mana_cost
export(PackedScene) var SpellScene

var hover = false setget set_hover

onready var cardImage: = $CardImage
onready var manaLabel: = find_node("ManaLabel")

func set_hover(value):
	hover = value
	if hover: cardImage.self_modulate = Color.darkgray
	else: cardImage.self_modulate = Color.black

func set_mana_cost(value):
	mana_cost = value
	var manaLabel = find_node("ManaLabel")
	if manaLabel: manaLabel.text = "-"+str(mana_cost)

func _on_Card_gui_input(event):
	if event.is_action_pressed("mouse_left") and playerStats.mana >= mana_cost:
		var previousSelection = ReferenceStash.selectedCard
		if previousSelection is Control:
			previousSelection.set_hover(false)
		ReferenceStash.selectedCard = self
		self.hover = true
		Engine.time_scale = 0.25
		get_tree().set_input_as_handled()

func play(target_position):
	Engine.time_scale = 1.0
	var spell = SpellScene.instance()
	spell.position = target_position
	get_tree().current_scene.add_child(spell)
	ReferenceStash.selectedCard = null
	playerStats.mana -= mana_cost
	return spell

func _on_Card_mouse_entered():
	cardImage.rect_position.y = -16

func _on_Card_mouse_exited():
	cardImage.rect_position.y = 0
