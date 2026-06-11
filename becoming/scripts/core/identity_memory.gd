
class_name IdentityMemory
extends Node

## Separates:
## - choice_history (raw events — what happened)
## - identity_state (aggregated vectors — what it means)
## - narrative_flags (story conditions — what it becomes)


# === CHOICE HISTORY — Raw Events ===
# What happened, when, in what context. Never modified after creation.

var choice_history: Array[Dictionary] = []
# Each entry: {
#   "day": int,
#   "phase": String,
#   "voice": String,           # which voice was chosen
#   "sub_expression": String,  # which expression of that voice
#   "significance": float,
#   "context": String,         # human-readable description
#   "rejected": String,        # which voice was rejected
#   "timestamp": int           # in-game time
# }


# === IDENTITY STATE — Aggregated Meaning ===
# What the choices mean in aggregate. Derived from choice_history + psyche.

var identity_vector: Dictionary = {
	"curiosity": 40.0,
	"compassion": 40.0,
	"stability": 40.0,
}

# Sub-expression weights (which flavor of each voice is dominant)
var expression_weights: Dictionary = {
	"curiosity": {"exploration": 0.0, "confrontation": 0.0, "self_inquiry": 0.0},
	"compassion": {"care": 0.0, "sacrifice": 0.0, "attunement": 0.0},
	"stability": {"patience": 0.0, "control": 0.0, "detachment": 0.0},
}

# Derived traits (emergent from patterns)
var traits: Dictionary = {
	"openness": 0.0,       # High curiosity + low stability
	"tenderness": 0.0,     # High compassion + low control
	"rigidity": 0.0,       # High stability + low curiosity
	"recklessness": 0.0,   # High curiosity + low compassion
	"self_neglect": 0.0,   # High compassion + high sacrifice
	"presence": 0.0,       # Balanced all three
}


# === NARRATIVE FLAGS — Story Conditions ===
# What the choices become in story terms. Used by narrative systems.

var narrative_flags: Dictionary = {
	# Unlocks
	"has_opened_memory": false,
	"has_released_weight": false,
	"has_chosen_others": false,
	"has_waited": false,
	
	# Thresholds
	"voice_weakened": "",          # Which voice first weakened
	"voice_distorted": "",         # Which voice first distorted
	"convergence_triggered": false,
	
	# Patterns
	"consistent_chooser": false,   # Same voice 3+ times
	"oscillator": false,           # Different voice each day
	"late_shift": false,           # Changed pattern on final day
	
	# Relationship to Future Self
	"future_self_encounters": 0,
	"future_self_questioned": false,  # Player engaged with the question
}


# === SIGNALS ===
signal identity_updated(identity_vector: Dictionary)
signal trait_emerged(trait_name: String, value: float)
signal narrative_flag_set(flag_name: String, value: Variant)
signal pattern_detected(pattern_name: String)


# === METHODS: RECORDING ===

func record_choice(day: int, phase: String, voice: String, sub_expression: String,
		significance: float, context: String, rejected: String) -> void:
	var entry = {
		"day": day,
		"phase": phase,
		"voice": voice,
		"sub_expression": sub_expression,
		"significance": significance,
		"context": context,
		"rejected": rejected,
		"timestamp": Time.get_ticks_msec(),
	}
	choice_history.append(entry)
	
	# Update identity state
	_update_identity_from_choice(voice, sub_expression, significance)
	
	# Update narrative flags
	_update_narrative_flags(entry)
	
	# Check for patterns
	_detect_patterns()
	
	print("[IdentityMemory] Recorded: Day %d, %s (%s), rejected %s" % [day, voice, sub_expression, rejected])


# === METHODS: QUERYING ===

func get_dominant_voice() -> String:
	var max_val = 0.0
	var dominant = "balanced"
	for voice in identity_vector:
		if identity_vector[voice] > max_val:
			max_val = identity_vector[voice]
			dominant = voice
	return dominant


func get_dominant_expression(voice: String) -> String:
	if not expression_weights.has(voice):
		return ""
	var expressions = expression_weights[voice]
	var max_val = 0.0
	var dominant = ""
	for expr in expressions:
		if expressions[expr] > max_val:
			max_val = expressions[expr]
			dominant = expr
	return dominant


func get_choice_count(voice: String) -> int:
	var count = 0
	for entry in choice_history:
		if entry["voice"] == voice:
			count += 1
	return count


func get_choices_for_day(day: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for entry in choice_history:
		if entry["day"] == day:
			result.append(entry)
	return result


func get_rejected_count(voice: String) -> int:
	var count = 0
	for entry in choice_history:
		if entry["rejected"] == voice:
			count += 1
	return count


func is_pattern(pattern_name: String) -> bool:
	return narrative_flags.get(pattern_name, false)


func get_trait(trait_name: String) -> float:
	return traits.get(trait_name, 0.0)


# === INTERNAL: UPDATING ===

func _update_identity_from_choice(voice: String, sub_expression: String, significance: float) -> void:
	# Update main vector
	if identity_vector.has(voice):
		identity_vector[voice] += significance * 0.5
	
	# Update sub-expression weight
	if expression_weights.has(voice) and expression_weights[voice].has(sub_expression):
		expression_weights[voice][sub_expression] += significance
	
	# Recalculate derived traits
	_recalculate_traits()
	
	identity_updated.emit(identity_vector)


func _recalculate_traits() -> void:
	var c = identity_vector["curiosity"]
	var comp = identity_vector["compassion"]
	var s = identity_vector["stability"]
	var total = c + comp + s
	
	if total == 0:
		return
	
	# Normalize to 0-1 range for trait calculation
	var c_norm = c / total
	var comp_norm = comp / total
	var s_norm = s / total
	
	# Derived traits
	traits["openness"] = clamp(c_norm - s_norm, 0.0, 1.0)
	traits["tenderness"] = clamp(comp_norm * (1.0 - expression_weights["compassion"].get("sacrifice", 0.0) / max(c + comp + s, 1.0)), 0.0, 1.0)
	traits["rigidity"] = clamp(s_norm - c_norm, 0.0, 1.0)
	traits["recklessness"] = clamp(c_norm - comp_norm, 0.0, 1.0)
	traits["self_neglect"] = clamp(expression_weights["compassion"].get("sacrifice", 0.0) / max(total, 1.0), 0.0, 1.0)
	
	# Presence = how balanced all three are (low variance = high presence)
	var mean = total / 3.0
	var variance = (pow(c - mean, 2) + pow(comp - mean, 2) + pow(s - mean, 2)) / 3.0
	traits["presence"] = clamp(1.0 - (variance / 400.0), 0.0, 1.0)
	
	# Emit if any trait crosses a threshold
	for trait_name in traits:
		if traits[trait_name] > 0.6:
			trait_emerged.emit(trait_name, traits[trait_name])


func _update_narrative_flags(entry: Dictionary) -> void:
	match entry["voice"]:
		"curiosity":
			if entry["sub_expression"] == "exploration":
				narrative_flags["has_opened_memory"] = true
		"stability":
			if entry["sub_expression"] == "detachment":
				narrative_flags["has_released_weight"] = true
		"compassion":
			if entry["sub_expression"] == "sacrifice":
				narrative_flags["has_chosen_others"] = true
	
	if entry["voice"] == "stability" and entry["sub_expression"] == "patience":
		narrative_flags["has_waited"] = true
	
	narrative_flags["future_self_encounters"] += 1


func _detect_patterns() -> void:
	if choice_history.size() < 2:
		return
	
	# Check for consistent chooser
	var voices_chosen: Array[String] = []
	for entry in choice_history:
		voices_chosen.append(entry["voice"])
	
	var c_count = voices_chosen.count("curiosity")
	var comp_count = voices_chosen.count("compassion")
	var s_count = voices_chosen.count("stability")
	
	if c_count >= 3 or comp_count >= 3 or s_count >= 3:
		if not narrative_flags["consistent_chooser"]:
			narrative_flags["consistent_chooser"] = true
			pattern_detected.emit("consistent_chooser")
	
	# Check for oscillator (all different in first 3)
	if voices_chosen.size() >= 3:
		var first_three = voices_chosen.slice(0, 3)
		if first_three[0] != first_three[1] and first_three[1] != first_three[2] and first_three[0] != first_three[2]:
			if not narrative_flags["oscillator"]:
				narrative_flags["oscillator"] = true
				pattern_detected.emit("oscillator")
	
	# Check for late shift
	if voices_chosen.size() >= 3:
		if voices_chosen[-1] != voices_chosen[-2] and voices_chosen[-2] == voices_chosen[-3]:
			if not narrative_flags["late_shift"]:
				narrative_flags["late_shift"] = true
				pattern_detected.emit("late_shift")


# === DEBUG ===

func print_debug_state() -> void:
	print("\n[IdentityMemory] === DEBUG STATE ===")
	print("  Identity Vector: ", identity_vector)
	print("  Expression Weights: ", expression_weights)
	print("  Traits: ", traits)
	print("  Narrative Flags: ", narrative_flags)
	print("  Choice History (%d entries):" % choice_history.size())
	for entry in choice_history:
		print("    Day %d: %s (%s) — rejected %s" % [entry["day"], entry["voice"], entry["sub_expression"], entry["rejected"]])
	print("  Patterns: consistent=%s, oscillator=%s, late_shift=%s" % [
		narrative_flags["consistent_chooser"],
		narrative_flags["oscillator"],
		narrative_flags["late_shift"]
	])
	print("[IdentityMemory] === END ===\n")
