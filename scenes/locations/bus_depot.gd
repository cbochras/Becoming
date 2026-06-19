extends Node


func _ready() -> void:
	GameState.current_scene = "bus_depot"

	var interactables = get_parent().get_node("Interactables")

	var bench = interactables.get_node("Bench")
	bench.interaction_id = "bench_sit"
	bench.framework_tags = {"vairagya": 0.02, "existentialism": 0.01}
	bench.sit_bonus_tags = {"vairagya": 0.015}

	var timetable = interactables.get_node("Timetable")
	timetable.interaction_id = "timetable_read"
	timetable.framework_tags = {"nihilism": 0.015}
	timetable.readable_text = [
		"Route 7 — Town Centre via Canal District",
		"Mon-Fri: 07:15, 08:40, 10:05, 14:30, 17:15",
		"Sat: 09:00, 13:00",
		"Sun: No service",
		"",
		"Route 12 — The Hill via Hospital",
		"Mon-Fri: 07:45, 12:15, 16:50",
		"Sat-Sun: No service",
		"",
		"(Last updated: March 2019)",
	]
	timetable.source_name = "Timetable"

	var pigeons = interactables.get_node("Pigeons")
	pigeons.interaction_id = "pigeons_watch"
	pigeons.framework_tags = {"vairagya": 0.025}
	pigeons.readable_text = [
		"They shift on the beam. One cocks its head toward you.",
		"A flutter of wings. Then stillness again.",
		"You watch them. They watch you back. Neither of you moves.",
	]
	pigeons.source_name = ""
