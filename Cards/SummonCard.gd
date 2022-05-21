extends Card

export(Resource) var creatureStats
export(int) var amount = 1
export(PackedScene) var CreatureScene = load("res://Creatures/PlayerCreature.tscn")

func _ready():
	._ready()
	infoOne.text = str(creatureStats.health)+" health\n"
	infoOne.text += str(creatureStats.attack*creatureStats.attacks_per_second)+" dps"
	var string = ""
	for i in creatureStats.tags.size():
		string += creatureStats.tag_strings[creatureStats.tags[i]]
		if i != creatureStats.tags.size(): string += " "
		if string.length() >= 12: string += "\n"
	infoTwo.text = string

func play(target_position):
	var spell = .play(target_position)
	if not spell is SummonSpell: return
	spell.creatureStats = creatureStats
	spell.amount = amount
	spell.CreatureScene = CreatureScene
	spell.cast()
