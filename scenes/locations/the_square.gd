extends Node


func _ready() -> void:
	GameState.current_scene = "the_square"

	var interactables = get_parent().get_node("Interactables")

	var memorial = interactables.get_node("Memorial")
	memorial.interaction_id = "memorial_read"
	memorial.framework_tags = {"existentialism": 0.02, "nihilism": 0.01}
	memorial.readable_text = [
		"Names. Rows of them. Cut into stone.",
		"Some you can barely read — the rain has softened them.",
		"1914. 1916. 1917. 1918.",
		"Someone left flowers. Weeks ago, by the look of them.",
	]
	memorial.source_name = "Memorial"

	var scarf = interactables.get_node("Scarf")
	scarf.interaction_id = "lost_object_examine"
	scarf.framework_tags = {"existentialism": 0.02}
	scarf.readable_text = [
		"A scarf. Wool. Hand-knitted, maybe.",
		"Draped on the bench arm like someone meant to come back for it.",
		"It's been here a while. The colour has faded on one side.",
		"You leave it where it is.",
	]
	scarf.source_name = ""

	var bird = interactables.get_node("Bird")
	bird.interaction_id = "bird_approach"
	bird.framework_tags = {"absurdism": 0.015}
	bird.readable_text = [
		"You walk toward it. It watches you.",
		"Two more steps. It tilts its head.",
		"One more — gone. A snap of wings and nothing.",
		"You're standing where a bird was. That's all.",
	]
	bird.source_name = ""

	var bench = interactables.get_node("Bench")
	bench.interaction_id = "square_bench_sit"
	bench.framework_tags = {"vairagya": 0.02}
	bench.sit_bonus_tags = {"vairagya": 0.02}
