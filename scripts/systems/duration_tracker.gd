# Duration Tracker
# Tracks how long a player remains near/at an interactable.
# Awards bonus framework tags for lingering (contemplation/presence).

class_name DurationTracker
extends Node

## Seconds before bonus kicks in
@export var duration_threshold: float = 15.0
## Bonus tags applied if player stays long enough
@export var bonus_tags: Dictionary = {}
## Whether bonus has already been applied
var _bonus_applied := false
var _time_nearby := 0.0
var _player_present := false


func start_tracking() -> void:
	_player_present = true
	_time_nearby = 0.0
	_bonus_applied = false


func stop_tracking() -> void:
	_player_present = false
	_time_nearby = 0.0


func _process(delta: float) -> void:
	if not _player_present or _bonus_applied:
		return

	_time_nearby += delta

	if _time_nearby >= duration_threshold:
		_bonus_applied = true
		if not bonus_tags.is_empty():
			FrameworkManager.apply_interaction(bonus_tags)
