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
const SPEED = 60.0

func _ready():
	$animation.animation_finished.connect(_on_animation_finished)
	
	if side == 1:
		$Hitbox.collision_mask = 1 | 2
		collision_layer = 1
		collision_mask = 1 | 2
	else:
		collision_layer = 1
		collision_mask = 1 | 3
		$Hitbox.collision_mask = 1 | 3

	
	if side == -1:
		$animation.flip_h = true
		hitbox.position.x = -26

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
