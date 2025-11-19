extends CharacterBody2D

@export var side := 1.0

var health = 30
var damage = 10
var cooldown = false

@onready var hitbox := $Hitbox
const SPEED = 60.0

func _ready():
	if side == -1:
		$animation.flip_h = true
		hitbox.position.x = -26

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT * SPEED * side

	var overlapping_bodies = $Hitbox.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		for body in overlapping_bodies:
			if body.side != side && !cooldown:
				attack(body)
				return
		
		if !cooldown:
			$animation.play("idle")
		return 
	
	$animation.play("walk")
	move_and_slide()
	
	
func get_hurt(damage):
	health -= damage
	if health <= 0:
		queue_free() # send money if side == -1

func attack(body):
	cooldown = true
	
	$animation.play("slash")
	
	if body.has_method("get_hurt"):
		body.get_hurt(damage)
		
	$AttackTimer.start()

func _on_attack_timer_timeout() -> void:
	cooldown = false
