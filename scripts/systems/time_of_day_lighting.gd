# Time of Day Lighting
# Manages the visual tinting of a scene based on game clock.
# Attach to a CanvasModulate node in each location scene.

class_name TimeOfDayLighting
extends CanvasModulate

const COLORS := {
	"morning": Color(0.78, 0.82, 0.88, 1.0),    # Cool grey-blue
	"afternoon": Color(1.0, 0.98, 0.95, 1.0),     # Flat bright
	"evening": Color(1.0, 0.85, 0.6, 1.0),        # Amber gold
	"night": Color(0.35, 0.4, 0.55, 1.0),         # Deep blue
}

var _current_period: String = ""


func _process(_delta: float) -> void:
	var period := GameState.get_time_period()
	if period != _current_period:
		_current_period = period
		_transition_to(COLORS[period])


func _transition_to(target: Color) -> void:
	var tween := create_tween()
	tween.tween_property(self, "color", target, 5.0)
