extends StaticBody2D

@export var side = 1
const max_health = 100.0
var health = 100.0

signal base_dead

func get_hurt(damage):
	health -= damage
	$ProgressBar.value = float(health / max_health * 100)
	if health <= 0:
		emit_signal("base_dead")
