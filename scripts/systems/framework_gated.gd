# Framework Gated
# Replaces FrameworkVisible. Characters are always present and visible,
# but can only be INTERACTED with when the framework threshold is met.
# Below threshold: character is busy/unavailable/turned away.
# At threshold: character is open to connection.
# Flicker equivalent: occasional glance (eye contact moment).

class_name FrameworkGated
extends Node

@export var required_framework: String = "existentialism"
@export var interaction_threshold: float = 0.35
@export var glance_threshold: float = 0.28

## Text shown when player tries to interact but threshold not met
@export var unavailable_text: String = "They don't look up."

var _parent: Node2D
var _is_available := false
var _glance_timer := 0.0
var _glance_cooldown := 0.0

const GLANCE_CHANCE := 0.02  # Per-second chance of a glance when in range
const GLANCE_COOLDOWN := 60.0  # Minimum seconds between glances


func _ready() -> void:
	_parent = get_parent() as Node2D
	if not _parent:
		return
	_update_state()


func _process(delta: float) -> void:
	_update_state()
	if _glance_cooldown > 0.0:
		_glance_cooldown -= delta


## Called by player controller when trying to interact
func can_interact() -> bool:
	return _is_available


## Get the "unavailable" response text
func get_unavailable_response() -> String:
	return unavailable_text


## Check if a glance should happen (called when player is nearby)
func try_glance(delta: float) -> bool:
	if _is_available:
		return false  # Already open, no need for glance
	if _glance_cooldown > 0.0:
		return false

	var val := FrameworkManager.get_world_value(required_framework)
	if val < glance_threshold:
		return false

	# Random chance of a glance
	if randf() < GLANCE_CHANCE * delta:
		_glance_cooldown = GLANCE_COOLDOWN
		return true
	return false


func _update_state() -> void:
	var val := FrameworkManager.get_world_value(required_framework)
	_is_available = val >= interaction_threshold
