class_name PsycheSystem
extends Node

## The Psyche System — the emotional nervous system of Becoming.
## Manages three voices, their sub-expressions, and identity evolution.

# === VOICES ===
var voices: Array[Voice] = []

# === SUB-EXPRESSION DEFINITIONS ===
# Each voice has 3 possible expressions that color HOW it speaks
const EXPRESSIONS = {
	"curiosity": {
		"exploration": "Driven by wonder — what's out there?",
		"confrontation": "Driven by truth — why are you avoiding this?",
		"self_inquiry": "Driven by introspection — what does this say about you?",
	},
	"compassion": {
		"care": "Driven by love — who needs you?",
		"sacrifice": "Driven by duty — what will you give up?",
		"attunement": "Driven by empathy — what are they feeling?",
	},
	"stability": {
		"patience": "Driven by trust — the answer will come.",
		"control": "Driven by safety — don't let this get away from you.",
		"detachment": "Driven by release — this is not yours to carry.",
	},
}

# === SIGNALS ===
signal psyche_changed(identity_vector: Dictionary)
signal voice_distorted(voice: Voice)
signal voice_weakened(voice: Voice)
signal convergence_approaching(voice_name: String, level: float)
@warning_ignore("unused_signal")
signal expression_shifted(voice_name: String, old_expression: String, new_expression: String)

# === HISTORY ===
var choice_history: Array[Dictionary] = []
var cycle_count: int = 0


func _ready() -> void:
	_create_voices()


func _create_voices() -> void:
	var curiosity = Voice.new()
	curiosity.voice_name = "Curiosity"
	curiosity.level = 40.0
	curiosity.attention = 50.0
	curiosity.integrity = 100.0
	add_child(curiosity)
	voices.append(curiosity)
	
	var compassion = Voice.new()
	compassion.voice_name = "Compassion"
	compassion.level = 40.0
	compassion.attention = 50.0
	compassion.integrity = 100.0
	add_child(compassion)
	voices.append(compassion)
	
	var stability = Voice.new()
	stability.voice_name = "Stability"
	stability.level = 40.0
	stability.attention = 50.0
	stability.integrity = 100.0
	add_child(stability)
	voices.append(stability)


# === CORE ACTIONS ===

func make_choice(voice_name: String, significance: float, context: String, sub_expression: String = "") -> void:
	var voice = _get_voice_by_name(voice_name)
	if voice == null:
		return
	
	# Reinforce the chosen voice
	voice.reinforce(significance)
	
	# Record
	var entry = {
		"voice": voice_name,
		"sub_expression": sub_expression,
		"significance": significance,
		"context": context,
		"cycle": cycle_count,
	}
	choice_history.append(entry)
	
	# Emit change
	_emit_psyche_state()
	
	# Check convergence
	_check_convergence(voice)


func reject_voice(voice_name: String, context: String) -> void:
	var voice = _get_voice_by_name(voice_name)
	if voice == null:
		return
	
	voice.weaken(3.0)
	
	var entry = {
		"voice": "REJECT_" + voice_name,
		"sub_expression": "",
		"significance": -3.0,
		"context": context,
		"cycle": cycle_count,
	}
	choice_history.append(entry)
	
	# Check if voice has become weakened or distorted
	if voice.status == Voice.Status.WEAKENED:
		voice_weakened.emit(voice)
	elif voice.status == Voice.Status.DISTORTED:
		voice_distorted.emit(voice)
	
	_emit_psyche_state()


func end_cycle() -> void:
	cycle_count += 1
	for voice in voices:
		voice.decay()


# === QUERY METHODS ===

func get_active_voices(max_count: int = 2) -> Array[Voice]:
	var active: Array[Voice] = []
	var sorted_voices = voices.duplicate()
	sorted_voices.sort_custom(func(a, b): return a.attention > b.attention)
	
	for voice in sorted_voices:
		if voice.can_speak() and active.size() < max_count:
			active.append(voice)
	return active


func get_system_state() -> Dictionary:
	var voice_states: Array[Dictionary] = []
	for voice in voices:
		voice_states.append({
			"name": voice.voice_name,
			"level": voice.level,
			"attention": voice.attention,
			"integrity": voice.integrity,
			"status": Voice.Status.keys()[voice.status],
		})
	
	return {
		"voices": voice_states,
		"cycle": cycle_count,
		"identity_vector": get_identity_vector(),
	}


func get_identity_vector() -> Dictionary:
	return {
		"curiosity": voices[0].level,
		"compassion": voices[1].level,
		"stability": voices[2].level,
	}


func get_voice_status(voice_name: String) -> String:
	var voice = _get_voice_by_name(voice_name)
	if voice == null:
		return "unknown"
	return Voice.Status.keys()[voice.status]


# === SUB-EXPRESSION QUERIES ===

func get_available_expressions(voice_name: String) -> Dictionary:
	var key = voice_name.to_lower()
	if EXPRESSIONS.has(key):
		return EXPRESSIONS[key]
	return {}


@warning_ignore("unused_parameter")
func get_expression_tone(voice_name: String, sub_expression: String) -> String:
	## Returns a tone modifier based on voice state + expression
	var voice = _get_voice_by_name(voice_name)
	if voice == null:
		return "neutral"
	
	match voice.status:
		Voice.Status.HEALTHY:
			return "clear"
		Voice.Status.WEAKENED:
			return "fragile"
		Voice.Status.DISTORTED:
			return "twisted"
	return "neutral"


# === INTERNAL ===

func _get_voice_by_name(voice_name: String) -> Voice:
	for voice in voices:
		if voice.voice_name.to_lower() == voice_name.to_lower():
			return voice
	return null


func _emit_psyche_state() -> void:
	var identity_vector = get_identity_vector()
	psyche_changed.emit(identity_vector)


func _check_convergence(voice: Voice) -> void:
	if voice.level >= 75.0:
		convergence_approaching.emit(voice.voice_name, voice.level)
