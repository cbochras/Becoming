# Bench Interactable
# A sittable bench. Tracks duration for contemplation bonus.

extends Interactable

@export var sit_bonus_tags: Dictionary = {"vairagya": 0.015}
@export var sit_duration_threshold: float = 15.0

var _player_sitting := false
var _sit_time := 0.0
var _bonus_applied := false
var _duration_tracker: DurationTracker


func _on_interact() -> void:
	_duration_tracker = get_node_or_null("DurationTracker") as DurationTracker
	_player_sitting = true
	_sit_time = 0.0
	_bonus_applied = false
	if _duration_tracker:
		_duration_tracker.bonus_tags = sit_bonus_tags
		_duration_tracker.duration_threshold = sit_duration_threshold
		_duration_tracker.start_tracking()


func _process(delta: float) -> void:
	if not _player_sitting:
		return
	_sit_time += delta

	# Player can leave by pressing move keys
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_up", "move_down")
	if input_dir != Vector2.ZERO:
		_stand_up()


func _stand_up() -> void:
	_player_sitting = false
	if _duration_tracker:
		_duration_tracker.stop_tracking()
