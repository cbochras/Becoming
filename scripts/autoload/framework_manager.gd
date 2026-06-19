# Framework Manager
# Tracks the player's philosophical framework state across four axes.
# Each axis is a float 0.0 to 1.0. The dominant axis determines perception.

extends Node

signal framework_changed(dominant: String, values: Dictionary)
signal drift_occurred(axis: String, old_value: float, new_value: float)

enum Axis { VAIRAGYA, NIHILISM, ABSURDISM, EXISTENTIALISM }

const AXIS_NAMES := {
	Axis.VAIRAGYA: "vairagya",
	Axis.NIHILISM: "nihilism",
	Axis.ABSURDISM: "absurdism",
	Axis.EXISTENTIALISM: "existentialism",
}

# Current framework values
var values := {
	"vairagya": 0.25,
	"nihilism": 0.25,
	"absurdism": 0.25,
	"existentialism": 0.25,
}

# The world's perception state lags behind the player's actual state
var world_values := {
	"vairagya": 0.25,
	"nihilism": 0.25,
	"absurdism": 0.25,
	"existentialism": 0.25,
}

# How fast the world catches up to the player (per second)
const WORLD_LAG_SPEED := 0.001

var _dominant: String = ""
var _world_dominant: String = ""


func _ready() -> void:
	_dominant = _get_dominant(values)
	_world_dominant = _dominant


func _process(delta: float) -> void:
	# World slowly catches up to player's actual framework state
	for axis in values.keys():
		var diff: float = float(values[axis]) - float(world_values[axis])
		if abs(diff) > 0.001:
			world_values[axis] = float(world_values[axis]) + sign(diff) * WORLD_LAG_SPEED * delta

	var new_world_dominant := _get_dominant(world_values)
	if new_world_dominant != _world_dominant:
		_world_dominant = new_world_dominant
		framework_changed.emit(_world_dominant, world_values)


## Apply a framework shift from an interaction.
## tags is a Dictionary like {"vairagya": 0.02, "nihilism": -0.01}
func apply_interaction(tags: Dictionary) -> void:
	for axis in tags.keys():
		if axis in values:
			var old_val: float = float(values[axis])
			values[axis] = clampf(float(values[axis]) + float(tags[axis]), 0.0, 1.0)
			if abs(float(values[axis]) - old_val) > 0.001:
				drift_occurred.emit(axis, old_val, float(values[axis]))

	var new_dominant := _get_dominant(values)
	if new_dominant != _dominant:
		_dominant = new_dominant


## Get the current dominant framework (player's real state)
func get_dominant() -> String:
	return _dominant


## Get the world's dominant framework (lagged state — use for visibility)
func get_world_dominant() -> String:
	return _world_dominant


## Get raw value for an axis
func get_value(axis: String) -> float:
	return values.get(axis, 0.0)


## Get the world's perceived value for an axis (lagged)
func get_world_value(axis: String) -> float:
	return world_values.get(axis, 0.0)


## Check if a visibility condition is met based on world state
func check_visibility(conditions: Dictionary) -> bool:
	for axis in conditions.keys():
		var required: float = float(conditions[axis])
		if float(world_values.get(axis, 0.0)) < required:
			return false
	return true


## Check if something is in flicker range (close but not visible)
func check_flicker(requires: Dictionary, flicker_min: Dictionary) -> bool:
	for axis in requires.keys():
		var val: float = float(world_values.get(axis, 0.0))
		var req: float = float(requires[axis])
		var fmin: float = float(flicker_min.get(axis, 0.0))
		if val >= req:
			return false  # Fully visible, not flicker
		if val < fmin:
			return false  # Too far away, not even flicker
	return true


func _get_dominant(vals: Dictionary) -> String:
	var max_val: float = 0.0
	var max_axis: String = "vairagya"
	for axis in vals.keys():
		if float(vals[axis]) > max_val:
			max_val = float(vals[axis])
			max_axis = axis
	return max_axis
