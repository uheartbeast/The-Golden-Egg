extends Card

export(Resource) var creatureStats
export(int) var amount
export(PackedScene) var CreatureScene = load("res://Creatures/PlayerCreature.tscn")

func play(target_position):
	var spell = .play(target_position)
	if not spell is SummonSpell: return
	spell.creatureStats = creatureStats
	spell.amount = amount
	spell.CreatureScene = CreatureScene
	spell.cast()
