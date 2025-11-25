class_name AIStrategy

var world

var ai_gold := 30
var ai_income_rate := 6  

var preloadedMelee = preload("res://Units/Pirate.tscn")
var preloadedGun = preload("res://Units/PirateGun.tscn")

func _init(world_ref):
	world = world_ref

func earn():
	ai_gold += ai_income_rate

func execute(world_state):
	var strategy = get_strategy(world_state)
	
	var choices = []
	match strategy:
		"panic":
			choices = [
				{ "unit": "pirate_melee", "weight": 100 }
			]

		"economy":
			choices = [
				{ "unit": "pirate_melee", "weight": 50 },
				{ "unit": "none", "weight": 50 } 
			]

		_:
			choices = [
				{ "unit": "pirate_melee", "weight": 50 },
				{ "unit": "pirate_gun", "weight": 50 }
			]
	
	var unit = weighted_choice(choices)
	
	if unit == "none":
		return null
	
	var cost = 0
	var preloaded = null
	if unit == "pirate_melee":
		preloaded = preloadedMelee
		cost = 20
	elif unit == "pirate_gun":
		preloaded = preloadedGun
		cost = 30
	else:
		return null
		
	if ai_gold < cost:
		@warning_ignore("integer_division")
		await world.get_tree().create_timer((cost - ai_gold) / ai_income_rate).timeout 

	ai_gold -= cost

	return preloaded.instantiate()

func weighted_choice(list):
	var total = 0
	for item in list:
		total += item.weight

	var r = randf() * total
	for item in list:
		r -= item.weight
		if r <= 0:
			return item.unit
	return list[-1].unit

func get_strategy(world_state) -> String:
	var _ours = world_state.enemy_strength
	var theirs = world_state.player_strength

	if world_state.ai_health < 20:
		return "panic"

	if theirs == 0:
		return "economy"

	return "balanced"
