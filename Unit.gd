extends RigidBody2D
class_name Unit

enum ALLIANCE {
	FRIEND,
	NEUTRAL,
	FOE,
}

export(ALLIANCE) var alliance = ALLIANCE.NEUTRAL setget set_alliance
export(Resource) var stats setget set_stats

func set_alliance(value):
	alliance = value

func set_stats(value):
	stats = value
