
class_name Voice
extends Resource

# === IDENTITY ===
@export var voice_name: String = ""
@export var role_phrase: String = ""  # e.g. "Go through the door."

# === STATE MODEL ===
@export var level: float = 40.0        # 0-100: sophistication & frequency
@export var attention: float = 50.0    # 0-100: how much player has listened recently
@export var integrity: float = 80.0    # 0-100: health (drops when ignored while relevant)

# === DERIVED STATUS ===
enum Status { HEALTHY, WEAKENED, DISTORTED, SILENT }
var status: Status = Status.HEALTHY

# === THRESHOLDS (from GDD Section 5.3) ===
const DISTORTION_INTEGRITY_THRESHOLD: float = 20.0
const DISTORTION_LEVEL_THRESHOLD: float = 50.0
const SILENCE_THRESHOLD: float = 10.0
const DOMINANCE_THRESHOLD: float = 85.0

# === ATTENTION DECAY ===
const ATTENTION_DECAY_PER_CYCLE: float = 5.0

# === SIGNALS ===
signal status_changed(voice: Voice, new_status: Status)
signal voice_spoke(voice: Voice, message: String)


func _init(p_name: String = "", p_role: String = "") -> void:
	voice_name = p_name
	role_phrase = p_role


# === CORE METHODS ===

## Called when player makes a choice aligned with this voice
func engage(significance: float = 5.0) -> void:
	level = clamp(level + significance, 0.0, 100.0)  # +3 to +8
	attention = clamp(attention + 10.0, 0.0, 100.0)
	_update_status()


## Called when player explicitly rejects this voice's perspective
func reject() -> void:
	attention = clamp(attention - 10.0, 0.0, 100.0)
	integrity = clamp(integrity - 5.0, 0.0, 100.0)
	_update_status()


## Called when another voice is engaged (passive loss)
func passive_fade(amount: float = 4.0) -> void:
	attention = clamp(attention - amount, 0.0, 100.0)
	_update_status()


## Called once per day cycle — attention naturally decays
func cycle_decay() -> void:
	attention = clamp(attention - ATTENTION_DECAY_PER_CYCLE, 0.0, 100.0)
	_update_status()


# === STATUS EVALUATION ===

func _update_status() -> void:
	var old_status = status
	
	# Silent: both level and attention below 10
	if level < SILENCE_THRESHOLD and attention < SILENCE_THRESHOLD:
		status = Status.SILENT
	# Distorted: strong but neglected (high level, low integrity)
	elif integrity < DISTORTION_INTEGRITY_THRESHOLD and level > DISTORTION_LEVEL_THRESHOLD:
		status = Status.DISTORTED
	# Weakened: low level OR low attention
	elif level < 20.0 or attention < 15.0:
		status = Status.WEAKENED
	else:
		status = Status.HEALTHY
	
	if status != old_status:
		status_changed.emit(self, status)


# === QUERY METHODS ===

## Returns the voice's expression tier (determines dialogue sophistication)
func get_expression_tier() -> String:
	if level <= 20.0:
		return "minimal"      # Barely speaks, simple phrases
	elif level <= 50.0:
		return "active"       # Participates, offers insights
	elif level <= 80.0:
		return "eloquent"     # Persuasive, reveals deeper truths
	else:
		return "dominant"     # Beautiful and dangerous


## Should this voice speak right now? (relevance check simplified)
func can_speak() -> bool:
	return status != Status.SILENT


## Is this voice in danger of distortion?
func is_distortion_risk() -> bool:
	return integrity < 35.0 and level > 40.0


## Is this voice dominating the psyche?
func is_dominant() -> bool:
	return level > DOMINANCE_THRESHOLD


## Get a summary of current state (for debugging)
func get_state_summary() -> Dictionary:
	return {
		"name": voice_name,
		"level": level,
		"attention": attention,
		"integrity": integrity,
		"status": Status.keys()[status],
		"expression_tier": get_expression_tier(),
		"dominant": is_dominant(),
		"distortion_risk": is_distortion_risk()
	}
