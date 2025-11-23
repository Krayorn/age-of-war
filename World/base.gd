extends StaticBody2D

@export var side = 1
const max_health = 100.0
var health = 100.0

signal base_dead

func _ready():
	if side == -1:
		$AnimatedSprite2D.flip_h = true
		$ProgressBar.position.x = 10

func get_hurt(damage):
	health -= damage
	var percentHealth = float(health / max_health * 100)
	$ProgressBar.value = percentHealth
	
	if percentHealth < 75:
		$AnimatedSprite2D.play("damaged")
	
	if percentHealth < 25:
		$AnimatedSprite2D.play("critical")
	
	if health <= 0:
		emit_signal("base_dead")
		
	
