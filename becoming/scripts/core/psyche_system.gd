
class_name PsycheSystem
extends Node

# === THE THREE MVP VOICES ===
var curiosity: Voice
var compassion: Voice
var stability: Voice

# All voices for iteration
var voices: Array[Voice] = []

# === IDENTITY STATE VECTOR ===
# The player's philosophical fingerprint (derived from voice levels)
var identity_vector: Dictionary = {
	"curiosity": 40.0,
	"compassion": 40.0,
	"stability": 40.0
}

# === CHOICE LOG (append-only — the game never forgets) ===
var choice_history: Array[Dictionary] = []

# === SIGNALS ===
signal psyche_changed(identity_vector: Dictionary)
signal voice_distorted(voice: Voice)
signal voice_silenced(voice: Voice)
signal convergence_approaching(voice_name: String, level: float)


func _ready() -> void:
	_initialize_voices()


func _initialize_voices() -> void:
	curiosity = Voice.new("Curiosity", "Go through the door.")
	compassion = Voice.new("Compassion", "You're thinking about yourself again.")
	stability = Voice.new("Stability", "We have enough uncertainty already.")
	
	voices = [curiosity, compassion, stability]
	
	# Connect status change signals
	for voice in voices:
		voice.status_changed.connect(_on_voice_status_changed)


# === PRIMARY INTERACTION: PLAYER MAKES A CHOICE ===

## Called when player makes a choice aligned with a specific voice
func make_choice(chosen_voice_name: String, significance: float = 5.0, context: String = "") -> void:
	var chosen_voice = _get_voice_by_name(chosen_voice_name)
	if chosen_voice == null:
		return
	
	# Engage the chosen voice
	chosen_voice.engage(significance)
	
	# Passive fade for competing voices
	for voice in voices:
		if voice != chosen_voice:
			voice.passive_fade()
	
	# Update identity vector
	_update_identity_vector()
	
	# Log the choice (append-only — game never forgets)
	_log_choice(chosen_voice_name, significance, context)
	
	# Check for convergence states
	_check_convergence()
	
	# Emit signal for world to respond
	psyche_changed.emit(identity_vector)


## Called when player explicitly rejects a voice's perspective
func reject_voice(voice_name: String, context: String = "") -> void:
	var rejected = _get_voice_by_name(voice_name)
	if rejected == null:
		return
	
	rejected.reject()
	_update_identity_vector()
	
	_log_choice("REJECT_" + voice_name, -5.0, context)
	
	psyche_changed.emit(identity_vector)


# === CYCLE MANAGEMENT ===

## Called at the end of each day cycle
func end_cycle() -> void:
	for voice in voices:
		voice.cycle_decay()
	_update_identity_vector()
	psyche_changed.emit(identity_vector)


# === QUERY METHODS ===

## Which voices should speak right now? (max 2-3)
## Determined by: relevance + Level + Attention
func get_active_voices(max_count: int = 2) -> Array[Voice]:
	var speakable: Array[Voice] = []
	
	for voice in voices:
		if voice.can_speak():
			speakable.append(voice)
	
	# Sort by attention (most recently listened to speaks first)
	speakable.sort_custom(func(a, b): return a.attention > b.attention)
	
	# Return top voices up to max_count
	return speakable.slice(0, max_count)


## Get the dominant voice (if any)
func get_dominant_voice() -> Voice:
	for voice in voices:
		if voice.is_dominant():
			return voice
	return null


## Get full system state (for debugging and world response)
func get_system_state() -> Dictionary:
	var state = {
		"identity_vector": identity_vector.duplicate(),
		"voices": [],
		"choice_count": choice_history.size(),
		"dominant": null
	}
	for voice in voices:
		state["voices"].append(voice.get_state_summary())
	
	var dominant = get_dominant_voice()
	if dominant:
		state["dominant"] = dominant.voice_name
	
	return state


# === INTERNAL METHODS ===

func _update_identity_vector() -> void:
	identity_vector["curiosity"] = curiosity.level
	identity_vector["compassion"] = compassion.level
	identity_vector["stability"] = stability.level


func _log_choice(voice_name: String, significance: float, context: String) -> void:
	choice_history.append({
		"voice": voice_name,
		"significance": significance,
		"context": context,
		"timestamp": Time.get_ticks_msec(),
		"identity_snapshot": identity_vector.duplicate()
	})


func _check_convergence() -> void:
	for voice in voices:
		if voice.level > 75.0:  # Early warning before 85 threshold
			convergence_approaching.emit(voice.voice_name, voice.level)


func _on_voice_status_changed(voice: Voice, new_status: Voice.Status) -> void:
	match new_status:
		Voice.Status.DISTORTED:
			voice_distorted.emit(voice)
		Voice.Status.SILENT:
			voice_silenced.emit(voice)


func _get_voice_by_name(voice_name: String) -> Voice:
	match voice_name.to_lower():
		"curiosity":
			return curiosity
		"compassion":
			return compassion
		"stability":
			return stability
	return null
