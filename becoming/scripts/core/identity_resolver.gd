class_name IdentityResolver
extends Node

## The Single Source of Truth per moment.
## Takes psyche + memory → produces ONE resolved identity state.
## Everything downstream (renderer, future self, endings) reads ONLY from here.

# === THE RESOLVED STATE (one authority, one truth per tick) ===
var resolved_state: Dictionary = {}

# === SIGNALS ===
signal state_resolved(state: Dictionary)


## Call this after every meaningful change (choice, phase change, day end)
func resolve(psyche: PsycheSystem, memory: IdentityMemory, current_day: int, current_phase: int) -> Dictionary:
	var identity_vector = psyche.get_identity_vector()
	
	# === STEP 1: Determine dominant voice ===
	var dominant_voice = _resolve_dominant(identity_vector)
	
	# === STEP 2: Determine dominant expression ===
	var dominant_expression = memory.get_dominant_expression(dominant_voice)
	if dominant_expression == "":
		dominant_expression = "general"
	
	# === STEP 3: Determine character (the interpretive layer) ===
	# Character = how the dominance FEELS — not just what it IS
	var character = _resolve_character(identity_vector, memory)
	
	# === STEP 4: Determine narrative tension ===
	# What is the system "worried about" for this player?
	var tension = _resolve_tension(identity_vector, memory, current_day)
	
	# === STEP 5: Determine voice health ===
	var voice_health = {}
	for voice in psyche.voices:
		voice_health[voice.voice_name.to_lower()] = {
			"status": Voice.Status.keys()[voice.status],
			"level": voice.level,
			"integrity": voice.integrity,
		}
	
	# === STEP 6: Build valence dimensions (replaces sub-expression explosion) ===
	var valence = _resolve_valence(memory)
	
	# === ASSEMBLE RESOLVED STATE ===
	resolved_state = {
		# Core identity
		"dominant_voice": dominant_voice,
		"dominant_expression": dominant_expression,
		"identity_vector": identity_vector,
		
		# Interpretive layers (derived, not source)
		"character": character,
		"tension": tension,
		"valence": valence,
		
		# Voice health
		"voice_health": voice_health,
		
		# Context
		"day": current_day,
		"phase": current_phase,
		"total_choices": memory.choice_history.size(),
		
		# Pattern (singular — the MOST relevant pattern right now)
		"active_pattern": _resolve_primary_pattern(memory),
	}
	
	state_resolved.emit(resolved_state)
	
	print("[Resolver] State: %s (%s) | Character: %s | Tension: %s | Pattern: %s" % [
		dominant_voice, dominant_expression, character, tension, resolved_state["active_pattern"]
	])
	
	return resolved_state


# === GET CURRENT STATE (no recomputation) ===
func get_state() -> Dictionary:
	return resolved_state


# === RESOLUTION LOGIC ===

func _resolve_dominant(identity_vector: Dictionary) -> String:
	var max_val = 0.0
	var dominant = "balanced"
	var second_val = 0.0
	
	for voice in identity_vector:
		if identity_vector[voice] > max_val:
			second_val = max_val
			max_val = identity_vector[voice]
			dominant = voice
		elif identity_vector[voice] > second_val:
			second_val = identity_vector[voice]
	
	# If the gap is too small, it's actually balanced
	if max_val - second_val < 5.0:
		return "balanced"
	
	return dominant


func _resolve_character(identity_vector: Dictionary, memory: IdentityMemory) -> String:
	## Character = the qualitative feel of the player's identity
	## Not "what voice" but "what kind of person"
	
	var dominant = _resolve_dominant(identity_vector)
	var choices = memory.choice_history.size()
	
	# Early game — character hasn't formed yet
	if choices <= 1:
		return "forming"
	
	# Check for consistency vs. contradiction
	var is_consistent = memory.is_pattern("consistent_chooser")
	var is_oscillating = memory.is_pattern("oscillator")
	var shifted_late = memory.is_pattern("late_shift")
	
	if shifted_late:
		return "turning"       # Someone in the process of changing
	elif is_oscillating:
		return "searching"     # Hasn't found their shape yet
	elif is_consistent:
		# Consistent — but what flavor?
		match dominant:
			"curiosity": return "seeker"
			"compassion": return "tender"
			"stability": return "steady"
			_: return "settled"
	else:
		return "becoming"      # Default — still in motion


func _resolve_tension(identity_vector: Dictionary, memory: IdentityMemory, current_day: int) -> String:
	## Tension = what the system is "worried about" — what could go wrong
	## This drives the Future Self's tone and the narrative's edge
	
	var dominant = _resolve_dominant(identity_vector)
	
	# Check for voice health issues
	var rejected_curiosity = memory.get_rejected_count("curiosity")
	var rejected_compassion = memory.get_rejected_count("compassion")
	var rejected_stability = memory.get_rejected_count("stability")
	
	# Something is being heavily suppressed
	if rejected_curiosity >= 2:
		return "closing"           # Shutting down openness
	elif rejected_compassion >= 2:
		return "hardening"         # Losing tenderness
	elif rejected_stability >= 2:
		return "ungrounding"       # Losing foundation
	
	# Dominance getting extreme
	if identity_vector.get(dominant, 0) > 65.0 and current_day >= 2:
		return "narrowing"         # Becoming too one-dimensional
	
	# Balanced but day 3 — tension of finality
	if current_day >= 3:
		return "ending"            # The weight of last choices
	
	# Default — healthy tension of becoming
	return "open"


func _resolve_valence(memory: IdentityMemory) -> Dictionary:
	## Valence dimensions — replaces sub-expression explosion
	## 4 axes that describe HOW the player is being, not WHAT they chose
	
	var inward_score: float = 0.0
	var outward_score: float = 0.0
	var holding_score: float = 0.0
	var releasing_score: float = 0.0
	
	for entry in memory.choice_history:
		match entry.get("sub_expression", ""):
			"self_inquiry", "detachment", "control":
				inward_score += 1.0
			"exploration", "care", "sacrifice", "attunement":
				outward_score += 1.0
			"care", "patience", "control", "attunement":
				holding_score += 1.0
			"exploration", "confrontation", "detachment", "sacrifice":
				releasing_score += 1.0
	
	var total = max(memory.choice_history.size(), 1)
	
	return {
		"direction": "inward" if inward_score > outward_score else "outward",
		"grip": "holding" if holding_score > releasing_score else "releasing",
		"direction_strength": abs(inward_score - outward_score) / total,
		"grip_strength": abs(holding_score - releasing_score) / total,
	}


func _resolve_primary_pattern(memory: IdentityMemory) -> String:
	## Returns the SINGLE most relevant pattern — not all patterns
	## Priority: late_shift > oscillator > consistent > none
	
	if memory.is_pattern("late_shift"):
		return "late_shift"
	elif memory.is_pattern("oscillator"):
		return "oscillator"
	elif memory.is_pattern("consistent_chooser"):
		return "consistent"
	else:
		return "none"
