extends Node2D

var gold = 0: set = _set_gold

func _set_gold(value) -> void:
	gold=value
	$CanvasLayer/Inventory/GoldLabel.text="Gold: " + str(value)

var melee_cost = 15
var range_cost = 25

var opponent: AIStrategy

func _ready():
	gold = 50
	opponent = AIStrategy.new(self)

func _on_spawn_melee_spawn_unit() -> void:
	if gold < melee_cost:
		return
	gold -= melee_cost
	var unit = preload("res://Units/Pirate.tscn").instantiate()
	unit.side = 1
	spawn(unit)

func _on_spawn_range_spawn_unit() -> void:
	if gold < range_cost:
		return
	gold -= range_cost
	var unit = preload("res://Units/PirateGun.tscn").instantiate()
	unit.side = 1
	spawn(unit)
	
func spawn(unit):
	if unit.side == 1:
		unit.global_position = Vector2($PlayerBase.global_position.x + 30, $PlayerBase.global_position.y - 5)
	else: 
		unit.global_position = Vector2($AIBase.global_position.x - 20, $AIBase.global_position.y - 5)
		
	unit.add_to_group("units")
	add_child(unit)

func _on_player_base_base_dead() -> void:
	print("Game over")
	get_tree().paused = true

func _on_ai_base_base_dead() -> void:
	print("Congrats")
	get_tree().paused = true

func _on_ai_spawn_timer_timeout() -> void:
	var countPlayer := 0
	var countAI := 0
	for u in get_tree().get_nodes_in_group("units"):
		if u.side == -1:
			countAI += 1
		else:
			countPlayer += 1
	
	var game_state = {
		"player_strength": countPlayer,
		"enemy_strength": countAI,
		"ai_health": $AIBase.health
	}
	
	var unit = await opponent.execute(game_state)
	
	$AISpawnTimer.start()
	if unit == null:
		return
	
	unit.side = -1
	unit.on_death.connect(_on_enemy_death)
	spawn(unit)

func _on_enemy_death(reward, enemy_position):
	gold += reward
	var coin = preload("res://Misc/Coin.tscn").instantiate()
	coin.amount = reward
	coin.global_position = enemy_position
	coin.global_position.y -= 80
	add_child(coin)


func _on_ai_cash_timer_timeout() -> void:
	opponent.earn()
