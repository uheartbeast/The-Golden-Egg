extends TextureRect

export(Resource) var deck

onready var timer: = $Timer
onready var label: = $Label

func _ready():
	deck.shuffle()

func _physics_process(delta):
	if timer.time_left > 0:
		label.text = str(round(timer.time_left))
	else:
		label.text = "DRAW"

func empty() -> bool:
	return deck.empty()

func draw_card() -> PackedScene:
	var card = deck.draw_card()
	if empty(): hide()
	else: show()
	return card

func _on_CardStack_gui_input(event):
	if timer.time_left > 0: return
	if event.is_action_pressed("mouse_left"):
		pass
#		ReferenceStash.hand.add_card(draw_card())
#		timer.start()
