extends Stats
class_name CreatureStats

enum TAGS {
	FAST,
	SMALL,
	PACK
}

export(float) var speed
export(int) var attack
export(int) var attacks_per_second
export(int) var attack_range = 1
export(int) var size = 8
export(Array, TAGS) var tags
export(StreamTexture) var sprite
