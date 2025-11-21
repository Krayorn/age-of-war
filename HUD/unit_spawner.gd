extends Button

signal spawn_unit

func _on_pressed() -> void:
	emit_signal("spawn_unit")
	
