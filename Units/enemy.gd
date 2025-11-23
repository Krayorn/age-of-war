extends CharacterBody2D
class_name UnitBase

var health = 0
var damage = 0
var animationIdle = "idle"
var animationWalk = "idle"
var animationAttack = "idle"
var animationWaitingAttack = "idle"

var side := 1.0
var cooldown = false
var attack_target = null

@onready var hitbox := $Hitbox
const SPEED = 260.0

func _ready():
	$animation.animation_finished.connect(_on_animation_finished)
	
	if side == 1:
		@warning_ignore("narrowing_conversion")
		collision_layer = pow(2, 1 - 1)
		$Hitbox.collision_mask = pow(2, 1 - 1) + pow(2, 2 - 1)
		@warning_ignore("narrowing_conversion")
		collision_mask = pow(2, 1 - 1) + pow(2, 2 - 1)
	else:
		@warning_ignore("narrowing_conversion")
		collision_layer = pow(2, 1 - 1)
		@warning_ignore("narrowing_conversion")
		collision_mask = pow(2, 1 - 1) + pow(2, 3 - 1)
		$Hitbox.collision_mask = pow(2, 1 - 1) + pow(2, 3 - 1)

	if side == -1:
		$animation.flip_h = true
		hitbox.position.x *= -1

func _physics_process(_delta: float) -> void:
	velocity = Vector2.RIGHT * SPEED * side

	var overlapping_bodies = $Hitbox.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		for body in overlapping_bodies:
			if body.side != side && !cooldown:
				attack(body)
				return
		
		if !cooldown:
			$animation.play(animationIdle)
		return 
	
	$animation.play(animationWalk)
	move_and_slide()
	
	
func get_hurt(damage_received):
	health -= damage_received
	if health <= 0:
		queue_free() # send money if side == -1

func attack(body):
	cooldown = true
	
	$animation.play(animationAttack)
	attack_target = body
	$AttackTimer.start()

func _on_animation_finished() -> void:
	if $animation.animation == animationAttack and attack_target:
		if is_instance_valid(attack_target) and attack_target.has_method("get_hurt"):
			attack_target.get_hurt(damage)
		attack_target = null
		$animation.play(animationWaitingAttack)

func _on_attack_timer_timeout() -> void:
	cooldown = false
