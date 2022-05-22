extends CenterContainer

onready var scoreLabel = $VBoxContainer/Score

func _ready():
	scoreLabel.text = "You made it to round "+str(ReferenceStash.playerStats.visible_round)+"."
