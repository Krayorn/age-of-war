extends UnitBase

func _ready():
	super()
	health = 30
	damage = 10

	animationIdle = "idle"
	animationWalk = "walk"
	animationAttack = "slash"
	animationWaitingAttack = "waiting_attack"
