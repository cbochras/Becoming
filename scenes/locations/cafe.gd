extends Node


func _ready() -> void:
	GameState.current_scene = "cafe"

	var interactables = get_parent().get_node("Interactables")

	var mara = interactables.get_node("Mara")
	mara.character_id = "mara"
	mara.character_name = "Mara"
	mara.dialogue_file = "mara_cafe"
	mara.interaction_id = "mara_talk"
	mara.framework_tags = {"existentialism": 0.02, "absurdism": 0.01}

	var table = interactables.get_node("Table")
	table.interaction_id = "table_sit"
	table.framework_tags = {"vairagya": 0.02}
	table.sit_bonus_tags = {"vairagya": 0.015}

	var window = interactables.get_node("Window")
	window.interaction_id = "window_look"
	window.framework_tags = {"vairagya": 0.015}
	window.readable_text = [
		"The street outside. People passing. Not many.",
		"A woman with a bag. A man on a phone.",
		"The light is changing. You notice it more from in here.",
	]
	window.source_name = ""

	var menu = interactables.get_node("Menu")
	menu.interaction_id = "menu_read"
	menu.framework_tags = {"nihilism": 0.01}
	menu.readable_text = [
		"TEA .............. 1.40",
		"COFFEE ........... 1.60",
		"TOAST ............ 1.20",
		"BEANS ON TOAST ... 2.50",
		"SOUP OF THE DAY .. 3.00",
		"",
		"(The menu is laminated. The prices haven't changed.)",
	]
	menu.source_name = "Menu"

	var radio = interactables.get_node("Radio")
	radio.interaction_id = "radio_listen"
	radio.framework_tags = {"absurdism": 0.015, "vairagya": 0.01}
	radio.readable_text = [
		"...partly cloudy with highs of fourteen...",
		"...and later, a phone-in about local transport...",
		"The signal drifts. Static. Then music, faintly.",
	]
	radio.source_name = "Radio"
