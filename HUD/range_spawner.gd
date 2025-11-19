extends Button

signal spawn_pirate_gun

func _on_pressed() -> void:
	emit_signal("spawn_pirate_gun")
	
