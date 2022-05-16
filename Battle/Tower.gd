extends Unit
class_name Tower

const MAX_ALLIANCE_METER = 1000

var alliance_meter = MAX_ALLIANCE_METER/2 setget set_alliance_meter

onready var progressBar: = $ProgressBar
onready var sprite: = $Sprite

func set_alliance_meter(value):
	alliance_meter = clamp(value, 0, MAX_ALLIANCE_METER)
	var progressBar = find_node("ProgressBar")
	if progressBar:
		progressBar.value = alliance_meter
	if alliance_meter >= MAX_ALLIANCE_METER:
		self.alliance = ALLIANCE.FRIEND
	if alliance_meter <= 0:
		self.alliance = ALLIANCE.FOE

func set_alliance(value):
	alliance = value
	var progressBar = find_node("ProgressBar")
	if not progressBar: return
	var sprite = find_node("Sprite")
	match alliance:
		ALLIANCE.FRIEND:
			sprite.self_modulate = Color.aqua
			progressBar.value = MAX_ALLIANCE_METER
		
		ALLIANCE.NEUTRAL:
			sprite.self_modulate = Color.gray
			progressBar.value = MAX_ALLIANCE_METER/2
		
		ALLIANCE.FOE:
			sprite.self_modulate = Color.orange
			progressBar.value = 0

func _ready():
	progressBar.max_value = MAX_ALLIANCE_METER
