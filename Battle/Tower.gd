extends Unit
class_name Tower

const MAX_ALLIANCE_METER = 1000

var alliance_meter = MAX_ALLIANCE_METER/2 setget set_alliance_meter

onready var progressBar = $ProgressBar

func set_alliance_meter(value):
	alliance_meter = clamp(value, 0, MAX_ALLIANCE_METER)
	var progressBar = find_node("ProgressBar")
	if progressBar:
		progressBar.value = alliance_meter
	if alliance_meter >= MAX_ALLIANCE_METER:
		alliance = ALLIANCE.FRIEND
		self.modulate = Color.aqua
	if alliance_meter <= 0:
		alliance = ALLIANCE.FOE
		self.modulate = Color.orange

func _ready():
	progressBar.max_value = MAX_ALLIANCE_METER
