# Ambient Audio Controller
# Manages layered ambient sound that shifts subtly with framework state.

class_name AmbientAudio
extends Node

@export var base_sounds: Array[AudioStream] = []  # Always playing (wind, distant traffic)
@export var vairagya_layer: AudioStream    # Reverb, distance, space
@export var nihilism_layer: AudioStream     # Mechanical, hum, systems
@export var absurdism_layer: AudioStream    # Human, laughter, music scraps
@export var existentialism_layer: AudioStream  # Close, breath, fabric

var _base_players: Array[AudioStreamPlayer] = []
var _framework_players: Dictionary = {}

const CROSSFADE_DURATION := 3.0
const MAX_FRAMEWORK_VOLUME := -6.0  # dB
const MIN_FRAMEWORK_VOLUME := -40.0  # dB (effectively silent)


func _ready() -> void:
	# Create base ambient players
	for stream in base_sounds:
		var player := AudioStreamPlayer.new()
		player.stream = stream
		player.volume_db = -12.0
		player.bus = "Ambient"
		add_child(player)
		player.play()
		_base_players.append(player)

	# Create framework layer players
	_create_framework_player("vairagya", vairagya_layer)
	_create_framework_player("nihilism", nihilism_layer)
	_create_framework_player("absurdism", absurdism_layer)
	_create_framework_player("existentialism", existentialism_layer)

	FrameworkManager.framework_changed.connect(_on_framework_changed)


func _on_framework_changed(dominant: String, values: Dictionary) -> void:
	# Crossfade framework layers based on values
	for axis in _framework_players.keys():
		var player: AudioStreamPlayer = _framework_players[axis]
		var target_vol: float
		if axis == dominant:
			target_vol = MAX_FRAMEWORK_VOLUME
		else:
			target_vol = lerpf(MIN_FRAMEWORK_VOLUME, MAX_FRAMEWORK_VOLUME,
				values.get(axis, 0.0))

		var tween := create_tween()
		tween.tween_property(player, "volume_db", target_vol, CROSSFADE_DURATION)


func _create_framework_player(axis: String, stream: AudioStream) -> void:
	if not stream:
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = MIN_FRAMEWORK_VOLUME
	player.bus = "Ambient"
	add_child(player)
	player.play()
	_framework_players[axis] = player
