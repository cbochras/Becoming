# Ghost Player (The Other)
# Replays a recorded path from another player with a different framework.
# Appears rarely. Moves with intention. Cannot be interacted with.

class_name GhostPlayer
extends Node2D

@export var ghost_data_path: String = ""  # Path to recorded session JSON

var _path_points: Array = []
var _current_index := 0
var _time_accumulator := 0.0
var _is_active := false
var _fade_duration := 2.0

@onready var _sprite: Sprite2D = $Sprite


func _ready() -> void:
	visible = false
	modulate.a = 0.0


## Activate the ghost with recorded path data
func activate(data: Array) -> void:
	_path_points = data
	_current_index = 0
	_time_accumulator = 0.0
	_is_active = true
	visible = true

	# Fade in slowly
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.7, _fade_duration)


func _process(delta: float) -> void:
	if not _is_active or _path_points.is_empty():
		return

	_time_accumulator += delta

	# Move through recorded points based on timing
	while _current_index < _path_points.size():
		var point: Dictionary = _path_points[_current_index]
		if _time_accumulator >= point.get("t", 0.0):
			global_position = Vector2(point.get("x", 0.0), point.get("y", 0.0))
			_current_index += 1
		else:
			break

	# Reached end of recording — fade out
	if _current_index >= _path_points.size():
		_deactivate()


func _deactivate() -> void:
	_is_active = false
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, _fade_duration)
	tween.tween_callback(func(): visible = false)
