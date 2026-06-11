class_name NarrativeRenderer
extends Node

## Receives narrative events and decides HOW to display them.
## Separates content logic from UI rendering.
## Future: supports distortion effects, multiple languages, animation.

# === SIGNALS (UI listens to these) ===
signal display_text(text: String, style: String)
signal display_echo(text: String, speaker: String, tone: String)
signal clear_echo()
signal visual_event(event_type: String, params: Dictionary)

# === NARRATIVE EVENT TYPES ===
# The game generates these, the renderer interprets them

enum EventType {
	NARRATION,         # World description, atmosphere
	DILEMMA,           # Choice presentation
	CHOICE_RESPONSE,   # Reaction to player's choice
	VOICE_LINE,        # A voice speaking
	FUTURE_SELF,       # The echo speaks
	PHASE_TRANSITION,  # Day phase changed
	ENDING,            # Final identity text
}


# === CORE: RENDER A NARRATIVE EVENT ===

func render(event: Dictionary) -> void:
	var type = event.get("type", EventType.NARRATION)
	var content = event.get("content", "")
	var tone = event.get("tone", "neutral")
	var speaker = event.get("speaker", "")
	
	match type:
		EventType.NARRATION:
			_render_narration(content, tone)
		EventType.DILEMMA:
			_render_dilemma(content)
		EventType.CHOICE_RESPONSE:
			_render_choice_response(content, tone)
		EventType.VOICE_LINE:
			_render_voice_line(content, speaker, tone)
		EventType.FUTURE_SELF:
			_render_future_self(content, tone)
		EventType.PHASE_TRANSITION:
			_render_phase_transition(content, tone)
		EventType.ENDING:
			_render_ending(content, tone)


# === RENDERING METHODS ===

func _render_narration(content: String, tone: String) -> void:
	display_text.emit(content, "narration_" + tone)
	
	# Visual events based on tone
	match tone:
		"awakening":
			visual_event.emit("brighten", {"amount": 0.05, "speed": 0.5})
		"settling":
			visual_event.emit("darken", {"amount": 0.03, "speed": 0.3})
		"heavy":
			visual_event.emit("darken", {"amount": 0.08, "speed": 0.2})


func _render_dilemma(content: String) -> void:
	display_text.emit(content, "dilemma")
	visual_event.emit("seed_pulse", {"speed": 1.5})


func _render_choice_response(content: String, tone: String) -> void:
	display_text.emit(content, "response_" + tone)
	
	match tone:
		"expansive":
			visual_event.emit("seed_grow", {"amount": 15.0})
			visual_event.emit("fog_lift", {"amount": 0.1})
		"gentle":
			visual_event.emit("seed_grow", {"amount": 12.0})
			visual_event.emit("warmth", {"amount": 0.05})
		"grounded":
			visual_event.emit("seed_grow", {"amount": 10.0})
			visual_event.emit("steady", {})


func _render_voice_line(content: String, speaker: String, tone: String) -> void:
	# For now, just print. Later: animated text, positioned per voice
	print("    %s: \"%s\"" % [speaker, content])


func _render_future_self(content: String, tone: String) -> void:
	display_echo.emit(content, "future_self", tone)
	visual_event.emit("future_self_appear", {"tone": tone})


func _render_phase_transition(content: String, tone: String) -> void:
	display_text.emit(content, "transition")
	
	match tone:
		"morning":
			visual_event.emit("phase_morning", {})
		"afternoon":
			visual_event.emit("phase_afternoon", {})
		"evening":
			visual_event.emit("phase_evening", {})
		"night":
			visual_event.emit("phase_night", {})


func _render_ending(content: String, tone: String) -> void:
	display_text.emit(content, "ending_" + tone)
	visual_event.emit("ending", {"tone": tone})
	clear_echo.emit()


# === UTILITY: BUILD NARRATIVE EVENTS ===
# Helper functions to create properly structured events

static func narration(content: String, tone: String = "neutral") -> Dictionary:
	return {"type": EventType.NARRATION, "content": content, "tone": tone}

static func dilemma(content: String) -> Dictionary:
	return {"type": EventType.DILEMMA, "content": content}

static func choice_response(content: String, tone: String) -> Dictionary:
	return {"type": EventType.CHOICE_RESPONSE, "content": content, "tone": tone}

static func voice_line(content: String, speaker: String, tone: String = "neutral") -> Dictionary:
	return {"type": EventType.VOICE_LINE, "content": content, "speaker": speaker, "tone": tone}

static func future_self(content: String, tone: String = "haunting") -> Dictionary:
	return {"type": EventType.FUTURE_SELF, "content": content, "tone": tone}

static func phase_transition(content: String, tone: String) -> Dictionary:
	return {"type": EventType.PHASE_TRANSITION, "content": content, "tone": tone}

static func ending(content: String, tone: String) -> Dictionary:
	return {"type": EventType.ENDING, "content": content, "tone": tone}
