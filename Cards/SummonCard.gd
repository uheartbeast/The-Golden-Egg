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
		var new_tag = creatureStats.tag_strings[creatureStats.tags[i]]
		if (string+new_tag).length() >= 15: string += "\n"
		string += creatureStats.tag_strings[creatureStats.tags[i]]
		if i != creatureStats.tags.size(): string += " "
	infoTwo.text = string

func play(target_position):
	var spell = .play(target_position)
	if not spell is SummonSpell: return
	spell.creatureStats = creatureStats
	spell.amount = amount
	spell.CreatureScene = CreatureScene
	spell.cast()
