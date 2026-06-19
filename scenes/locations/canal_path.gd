extends Node


func _ready() -> void:
	GameState.current_scene = "canal_path"

	var interactables = get_parent().get_node("Interactables")

	var bench = interactables.get_node("CanalBench")
	bench.interaction_id = "bench_sit_canal"
	bench.framework_tags = {"vairagya": 0.03, "existentialism": 0.015}
	bench.sit_bonus_tags = {"vairagya": 0.02}

	var water = interactables.get_node("Water")
	water.interaction_id = "water_look"
	water.framework_tags = {"vairagya": 0.02}
	water.readable_text = [
		"The water is still. Green. Reflecting the sky in long bands.",
		"Something moves beneath the surface — a shadow, gone.",
		"You watch. The water watches back. Unblinking.",
	]
	water.source_name = ""

	# Ruth — EXISTENTIALISM ONLY
	var ruth = interactables.get_node("Ruth")
	ruth.character_id = "ruth"
	ruth.character_name = "Ruth"
	ruth.dialogue_file = "ruth_canal"
	ruth.interaction_id = "ruth_approach"
	ruth.framework_tags = {"existentialism": 0.03}
