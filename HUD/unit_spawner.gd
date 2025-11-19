extends Button

signal spawn_pirate

func _on_pressed() -> void:
	emit_signal("spawn_pirate")
	
