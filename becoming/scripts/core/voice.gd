
class_name Voice
extends Resource

## A single voice within the Psyche System.
## Represents one aspect of the player's internal dialogue.

# === IDENTITY ===
@export var voice_name: String = ""

# === CORE STATS ===
@export var level: float = 40.0          # 0-100: how dominant this voice is
@export var attention: float = 50.0      # 0-100: how actively this voice participates
@export var integrity: float = 100.0     # 0-100: health of the voice (low = distorted)

# === STATUS ===
enum Status { HEALTHY, WEAKENED, DISTORTED }
var status: Status = Status.HEALTHY

# === THRESHOLDS ===
const WEAKENED_THRESHOLD: float = 30.0
const DISTORTION_THRESHOLD: float = 15.0
const MAX_LEVEL: float = 100.0
const MIN_LEVEL: float = 0.0


# === CORE METHODS ===

## Reinforce this voice (player chose it)
func reinforce(amount: float) -> void:
	level = clamp(level + amount, MIN_LEVEL, MAX_LEVEL)
	attention = clamp(attention + amount * 0.5, 0.0, 100.0)
	integrity = clamp(integrity + amount * 0.2, 0.0, 100.0)
	_update_status()


## Weaken this voice (player rejected it)
func weaken(amount: float) -> void:
	level = clamp(level - amount, MIN_LEVEL, MAX_LEVEL)
	integrity = clamp(integrity - amount * 2.0, 0.0, 100.0)
	_update_status()


## Natural decay over time (end of cycle)
func decay() -> void:
	# Attention decays toward neutral
	attention = lerp(attention, 50.0, 0.1)
	# Level decays slightly toward center
	level = lerp(level, 40.0, 0.02)


## Can this voice speak?
func can_speak() -> bool:
	return status != Status.DISTORTED or integrity > 5.0


## Get expression tier based on level
func get_expression_tier() -> String:
	if level >= 75.0:
		return "dominant"
	elif level >= 55.0:
		return "strong"
	elif level >= 35.0:
		return "neutral"
	elif level >= 20.0:
		return "fading"
	else:
		return "silent"


# === INTERNAL ===

func _update_status() -> void:
	if integrity <= DISTORTION_THRESHOLD:
		status = Status.DISTORTED
	elif integrity <= WEAKENED_THRESHOLD or level <= 20.0:
		status = Status.WEAKENED
	else:
		status = Status.HEALTHY
