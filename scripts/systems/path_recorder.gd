# Path Recorder
# Records the player's movement path for ghost replay by other players.
# Outputs a JSON file of timestamped positions.

class_name PathRecorder
extends Node

@export var record_interval: float = 0.5  # Seconds between recordings
@export var player_node_path: NodePath

var _recording: Array = []
var _time_elapsed := 0.0
var _interval_accumulator := 0.0
var _is_recording := false
var _player: Node2D


func _ready() -> void:
	if player_node_path:
		_player = get_node_or_null(player_node_path)


func start_recording(player: Node2D = null) -> void:
	if player:
		_player = player
	_recording = []
	_time_elapsed = 0.0
	_interval_accumulator = 0.0
	_is_recording = true


func stop_recording() -> Dictionary:
	_is_recording = false
	return {
		"framework": FrameworkManager.get_dominant(),
		"scene": GameState.current_scene,
		"path": _recording,
	}


func _process(delta: float) -> void:
	if not _is_recording or not _player:
		return

	_time_elapsed += delta
	_interval_accumulator += delta

	if _interval_accumulator >= record_interval:
		_interval_accumulator = 0.0
		_recording.append({
			"t": _time_elapsed,
			"x": _player.global_position.x,
			"y": _player.global_position.y,
		})


## Save recording to file
func save_recording(path: String) -> void:
	var data := stop_recording()
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
