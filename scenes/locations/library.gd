extends Node


func _ready() -> void:
	GameState.current_scene = "library"

	var interactables = get_parent().get_node("Interactables")

	var shelves = interactables.get_node("Shelves")
	shelves.interaction_id = "shelves_browse"
	shelves.framework_tags = {"nihilism": 0.02, "vairagya": 0.01}
	shelves.readable_text = [
		"Rows and rows. Spines cracked and uncracked.",
		"Local history. Self-help. Crime fiction. Gardening.",
		"Some gaps where books were returned to the wrong shelf. Or not returned.",
		"You pull one out. Put it back. Pull another. Put it back.",
	]
	shelves.source_name = ""

	var closed_section = interactables.get_node("ClosedSection")
	closed_section.interaction_id = "closed_section_look"
	closed_section.framework_tags = {"nihilism": 0.02}
	closed_section.readable_text = [
		"A rope across the aisle. A laminated sign: SECTION CLOSED.",
		"No reason given. No date for reopening.",
		"Behind the rope: shelves like the others. Books like the others.",
		"Just... roped off. As if deciding not to exist.",
	]
	closed_section.source_name = ""

	var notice = interactables.get_node("NoticeBoard")
	notice.interaction_id = "notice_board_library"
	notice.framework_tags = {"nihilism": 0.015, "existentialism": 0.01}
	notice.readable_text = [
		"NEW HOURS: Mon-Wed 9-4, Thu 9-1, Fri-Sun CLOSED",
		"(Previous hours crossed out beneath. They were longer.)",
		"READING GROUP — First Tuesday. All welcome. Bring your own mug.",
		"COMPUTERS: 30-minute sessions. Please book at desk.",
		"WI-FI PASSWORD: library2019 (unchanged since 2019)",
	]
	notice.source_name = "Notice Board"

	var table = interactables.get_node("ReadingTable")
	table.interaction_id = "reading_table_sit"
	table.framework_tags = {"vairagya": 0.025}
	table.sit_bonus_tags = {"vairagya": 0.02}
