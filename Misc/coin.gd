extends AnimatedSprite2D

@export var amount = 0

func _ready():
	$AmountLabel.text = "+ " + str(amount)

func _on_timer_timeout() -> void:
	queue_free()
