extends UnitBase

var animationAttackMelee = "melee"

@onready var rangeHitbox := $RangeHitbox

func _ready():
	super()
	health = 30
	damage = 10

	animationIdle = "walk"
	animationWalk = "walk"
	animationAttack = "melee"
	animationWaitingAttack = "walk"

	if side == 1:
		rangeHitbox.collision_mask = 1 | 2
		collision_layer = 1
		collision_mask = 1 | 2
	else:
		collision_layer = 1
		collision_mask = 1 | 3
		rangeHitbox.collision_mask = 1 | 3


func _physics_process(_delta: float) -> void:
	velocity = Vector2.RIGHT * SPEED * side
	var melee_targets = $Hitbox.get_overlapping_bodies()
	var range_targets = $RangeHitbox.get_overlapping_bodies()

	var enemy_in_melee = null
	var enemy_in_range = null

	for b in melee_targets:
		if b.side != side:
			enemy_in_melee = b
			break

	for b in range_targets:
		if b.side != side:
			enemy_in_range = b
			break

	if enemy_in_melee:
		velocity = Vector2.ZERO 
		if !cooldown:
			melee_attack(enemy_in_melee)
		return
	
	if enemy_in_range:
		if !cooldown:
			range_attack(enemy_in_range)

	if !cooldown:
		$animation.play(animationWalk)
	move_and_slide()

func melee_attack(body):
	attack(body)
	$animation.play(animationAttackMelee)

func range_attack(body):
	attack(body)
	$animation.play(animationAttack)
