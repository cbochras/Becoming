extends Node


func _ready() -> void:
	GameState.current_scene = "high_street"

	var interactables = get_parent().get_node("Interactables")

	var notice_board = interactables.get_node("NoticeBoard")
	notice_board.interaction_id = "notice_board_read"
	notice_board.framework_tags = {"nihilism": 0.02, "existentialism": 0.01}
	notice_board.readable_text = [
		"COMMUNITY YOGA — Tuesdays 6pm, Scout Hall. All welcome.",
		"LOST CAT — Tabby, answers to Fig. Please call if seen.",
		"COUNCIL NOTICE: Bus route 12 under review. Consultation closed.",
		"ROOM TO RENT — Canal District, single occupancy. No couples.",
		"FOOD BANK — Thursdays 10-12. No referral needed.",
	]
	notice_board.source_name = "Notice Board"

	var bench = interactables.get_node("BenchStranger")
	bench.interaction_id = "bench_sit_stranger"
	bench.framework_tags = {"existentialism": 0.025}
	bench.sit_bonus_tags = {"existentialism": 0.02}

	var shop = interactables.get_node("ShopWindow")
	shop.interaction_id = "shop_window_look"
	shop.framework_tags = {"nihilism": 0.01}
	shop.readable_text = [
		"The window is empty. Dust on the sill.",
		"A faded TO LET sign, sun-bleached to near nothing.",
		"You can see your reflection. Behind it, bare walls.",
	]
	shop.source_name = ""
