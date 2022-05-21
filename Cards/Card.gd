extends Control
class_name Card

var playerStats = ReferenceStash.playerStats as PlayerStats

export(int) var cost = 2
export(int) var mana_cost = 1 setget set_mana_cost
export(int) var radius = 16
export(PackedScene) var SpellScene

var hover = false setget set_hover
var disabled = true setget set_disabled

onready var cardImage: = $CardImage
onready var manaLabel: = find_node("ManaLabel")
onready var infoOne: = find_node("InfoOne")
onready var infoTwo: = find_node("InfoTwo")
onready var coinDrop: = $CoinDrop
onready var tag: = find_node("Tag")
onready var tagLabel: = find_node("TagLabel")

func set_hover(value):
	if disabled: return
	hover = value
	if hover:
		Engine.time_scale = 0.2
		cardImage.self_modulate = Color.darkgray
	else:
		Engine.time_scale = 1.0
		cardImage.self_modulate = Color.black

func set_disabled(value):
	disabled = value
	if disabled: modulate = Color.dimgray
	else: modulate = Color.white

func set_tag(cost):
	tag.show()
	tagLabel.text = str(cost)

func hide_tag():
	tag.hide()

func set_mana_cost(value):
	mana_cost = value
	var manaLabel = find_node("ManaLabel")
	if manaLabel: manaLabel.text = str(mana_cost)

func _ready():
	if not Events.is_connected("enable_cards", self, "_on_cards_enabled"):
		Events.connect("enable_cards", self, "_on_cards_enabled")
	if not Events.is_connected("disable_cards", self, "_on_cards_disabled"):
		Events.connect("disable_cards", self, "_on_cards_disabled")

func _on_Card_gui_input(event):
	if disabled: return
	if event.is_action_pressed("mouse_left"):# and playerStats.mana >= mana_cost:
		var previousSelection = ReferenceStash.selectedCard
		if previousSelection is Control:
			previousSelection.set_hover(false)
		ReferenceStash.selectedCard = self
		self.hover = true
		get_tree().set_input_as_handled()
		if not tag.visible:
			Events.emit_signal("set_area_of_effect", true, radius, Color.white)

func play(target_position):
	var spell = SpellScene.instance()
	spell.position = target_position
	get_tree().current_scene.add_child(spell)
	ReferenceStash.selectedCard = null
	Events.emit_signal("set_area_of_effect", false, 0, Color.white)
#	playerStats.mana -= mana_cost
	return spell

func _exit_tree():
	Engine.time_scale = 1.0

func _on_cards_enabled():
	self.disabled = false

func _on_cards_disabled():
	self.disabled = true

func _on_Card_mouse_entered():
	if disabled: return
	cardImage.rect_position.y = -16

func _on_Card_mouse_exited():
	if disabled: return
	cardImage.rect_position.y = 0
