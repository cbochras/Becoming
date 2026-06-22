# Debug Overlay
# Press F3 to toggle. Shows framework values in real-time.
# Invisible to players — dev tool only.

extends CanvasLayer

var _label: Label
var _visible := false


func _ready() -> void:
	layer = 99
	_label = Label.new()
	_label.position = Vector2(10, 10)
	_label.add_theme_font_size_override("font_size", 14)
	_label.add_theme_color_override("font_color", Color(0.0, 1.0, 0.4, 0.9))
	_label.visible = false
	add_child(_label)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_QUOTELEFT:
		_visible = not _visible
		_label.visible = _visible


func _process(_delta: float) -> void:
	if not _visible:
		return

	var v = FrameworkManager.values
	var wv = FrameworkManager.world_values
	var dominant = FrameworkManager.get_dominant()
	var world_dominant = FrameworkManager.get_world_dominant()

	_label.text = "=== FRAMEWORK DEBUG ===\n"
	_label.text += "Dominant: %s (world: %s)\n\n" % [dominant, world_dominant]
	_label.text += "          Player → World\n"
	_label.text += "VAI: %.3f → %.3f\n" % [float(v["vairagya"]), float(wv["vairagya"])]
	_label.text += "NIH: %.3f → %.3f\n" % [float(v["nihilism"]), float(wv["nihilism"])]
	_label.text += "ABS: %.3f → %.3f\n" % [float(v["absurdism"]), float(wv["absurdism"])]
	_label.text += "EXI: %.3f → %.3f\n" % [float(v["existentialism"]), float(wv["existentialism"])]
	_label.text += "\n--- METRICS ---\n"
	_label.text += "Interactions: %d / %d\n" % [
		GameState.metrics["interactions_initiated"],
		GameState.metrics["interactions_initiated"] + GameState.metrics["objects_passed"]
	]
	_label.text += "Still: %.0fs | Moving: %.0fs\n" % [
		GameState.metrics["time_spent_still"],
		GameState.metrics["time_spent_moving"]
	]
	_label.text += "Scene: %s\n" % GameState.current_scene
	_label.text += "Time: %s (%.2f)\n" % [GameState.get_time_period(), GameState.game_time]
	_label.text += "\n--- BUS ---\n"
	_label.text += "Depot: %s\n" % ("OPEN" if BusSystem.depot_is_open else "CLOSED")
	_label.text += "Bus: %s\n" % ("HERE" if BusSystem.bus_is_here else "gone")
	_label.text += "Next bus: %.1f min\n" % BusSystem.get_minutes_until_bus()
	_label.text += "Missed: %d\n" % BusSystem.get_departure_count()
	_label.text += "Depot closes in: %.0f min" % ((BusSystem.DEPOT_CLOSES_AT - BusSystem.time_elapsed) / 60.0)
