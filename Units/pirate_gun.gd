extends UnitBase

var animationAttackMelee = "melee"
var animationAttackRangeWalk = "walk_and_shoot"
@onready var rangeHitbox := $RangeHitbox

func _ready():
	super()
	health = 30
	damage = 10

	animationIdle = "idle"
	animationWalk = "walk"
	animationAttack = "shoot"
	animationWaitingAttack = "idle"

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
	
	var was_blocked = move_and_slide()
	if enemy_in_range:
		if !cooldown:
			range_attack(enemy_in_range, was_blocked)
			return 
	
	if !cooldown:
		$animation.play(animationWalk)

func melee_attack(body):
	attack(body)
	$animation.play(animationAttackMelee)

func range_attack(body, not_moving):
	attack(body)
	if not_moving:
		$animation.play(animationAttack)
	else:
		$animation.play(animationAttackRangeWalk)
		
func _on_animation_finished() -> void:
	if attack_target:
		if $animation.animation == animationAttack or $animation.animation == animationAttackMelee or $animation.animation == animationAttackRangeWalk:
			if is_instance_valid(attack_target) and attack_target.has_method("get_hurt"):
				print("damage")
				attack_target.get_hurt(damage)
			attack_target = null
			$animation.play(animationWaitingAttack)
