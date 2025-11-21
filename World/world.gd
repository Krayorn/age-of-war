extends Node2D

var gold = 50

func _ready() -> void:
	ai_strategy()

func _on_spawn_melee_spawn_unit() -> void:
	var unit = preload("res://Units/Pirate.tscn").instantiate()
	unit.side = 1
	spawn(unit)

func _on_spawn_range_spawn_unit() -> void:
	var unit = preload("res://Units/PirateGun.tscn").instantiate()
	unit.side = 1
	spawn(unit)
	
func spawn(unit):
	if unit.side == 1:
		unit.global_position = Vector2($PlayerBase.global_position.x + 20, 460.0)
	else: 
		unit.global_position = Vector2($AIBase.global_position.x - 30, 460.0)
	add_child(unit)

func _on_player_base_base_dead() -> void:
	print("Game over")
	get_tree().paused = true

func _on_ai_base_base_dead() -> void:
	print("Congrats")
	get_tree().paused = true

func ai_strategy():
	$AISpawnTimer.start()
	var unit = preload("res://Units/Pirate.tscn").instantiate()
	unit.side = -1
	spawn(unit)

func _on_ai_spawn_timer_timeout() -> void:
	ai_strategy()
