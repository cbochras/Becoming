class_name DialogueManager
extends Node

# Reference to psyche system
var psyche: PsycheSystem

# Current phase of day determines context
enum DayPhase { MORNING, AFTERNOON, EVENING, NIGHT }
var current_phase: DayPhase = DayPhase.MORNING

# === SIGNALS ===
signal voice_line_delivered(voice_name: String, line: String, status: String)
signal all_voices_spoke(lines: Array)


func _init(psyche_system: PsycheSystem) -> void:
	psyche = psyche_system


# === CORE METHOD: TRIGGER VOICES TO SPEAK ===

## Ask active voices to comment on the current moment
func trigger_voices(max_voices: int = 2) -> Array[Dictionary]:
	var context = _get_context_from_phase()
	var active_voices = psyche.get_active_voices(max_voices)
	var spoken_lines: Array[Dictionary] = []
	
	for voice in active_voices:
		var line = DialogueData.get_line(voice, context)
		if line != "":
			var entry = {
				"voice": voice.voice_name,
				"line": line,
				"status": Voice.Status.keys()[voice.status],
				"tier": voice.get_expression_tier(),
				"level": voice.level,
			}
			spoken_lines.append(entry)
			voice_line_delivered.emit(voice.voice_name, line, entry["status"])
	
	all_voices_spoke.emit(spoken_lines)
	return spoken_lines


## Trigger a specific voice to speak (for dilemma debates)
func trigger_specific_voice(voice_name: String) -> Dictionary:
	var context = _get_context_from_phase()
	var voice = psyche._get_voice_by_name(voice_name)
	
	if voice == null or not voice.can_speak():
		return {}
	
	var line = DialogueData.get_line(voice, context)
	if line == "":
		return {}
	
	var entry = {
		"voice": voice.voice_name,
		"line": line,
		"status": Voice.Status.keys()[voice.status],
		"tier": voice.get_expression_tier(),
		"level": voice.level,
	}
	voice_line_delivered.emit(voice.voice_name, line, entry["status"])
	return entry


## Trigger ALL available voices for a debate moment (dilemma)
func trigger_debate() -> Array[Dictionary]:
	var context = "dilemma"
	var spoken_lines: Array[Dictionary] = []
	
	for voice in psyche.voices:
		if voice.can_speak():
			var line = DialogueData.get_line(voice, context)
			if line != "":
				var entry = {
					"voice": voice.voice_name,
					"line": line,
					"status": Voice.Status.keys()[voice.status],
					"tier": voice.get_expression_tier(),
					"level": voice.level,
				}
				spoken_lines.append(entry)
				voice_line_delivered.emit(voice.voice_name, line, entry["status"])
	
	all_voices_spoke.emit(spoken_lines)
	return spoken_lines


# === PHASE MANAGEMENT ===

func set_phase(phase: DayPhase) -> void:
	current_phase = phase


func advance_phase() -> void:
	current_phase = (current_phase + 1) % 4 as DayPhase


# === INTERNAL ===

func _get_context_from_phase() -> String:
	match current_phase:
		DayPhase.MORNING:
			return "observe"
		DayPhase.AFTERNOON:
			return "dilemma"
		DayPhase.EVENING:
			return "reflect"
		DayPhase.NIGHT:
			return "night"
	return "observe"
