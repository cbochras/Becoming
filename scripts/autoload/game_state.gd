# Game State
# Persistent state tracking: interactions performed, time, player history.

extends Node

signal time_advanced(new_time: float, period: String)

# Game clock (0.0 = dawn, 0.25 = noon, 0.5 = evening, 0.75 = night, 1.0 = next dawn)
var game_time := 0.0

# How fast time advances (game seconds per real second)
const TIME_SCALE := 0.002

# All interactions the player has performed (for Shadow knowledge)
var interaction_history: Array[Dictionary] = []

# Interactions the player DIDN'T take (passed by, ignored) — Shadow material
var missed_interactions: Array[Dictionary] = []

# Characters the player has met
var met_characters: Array[String] = []

# Current location
var current_scene: String = ""

# Player behavioral metrics (for framework reading)
var metrics := {
	"time_spent_still": 0.0,       # Seconds spent not moving
	"time_spent_moving": 0.0,      # Seconds spent in motion
	"interactions_initiated": 0,    # How many things you engaged with
	"interactions_available": 0,    # How many were available (tracks ratio)
	"people_approached": 0,
	"people_ignored": 0,
	"time_near_water": 0.0,
	"time_indoors": 0.0,
	"time_outdoors": 0.0,
	"objects_examined": 0,
	"objects_passed": 0,
	"backtrack_count": 0,
}


func _process(delta: float) -> void:
	game_time += TIME_SCALE * delta
	if game_time >= 1.0:
		game_time -= 1.0


## Get current time period name
func get_time_period() -> String:
	if game_time < 0.2:
		return "morning"
	elif game_time < 0.45:
		return "afternoon"
	elif game_time < 0.7:
		return "evening"
	else:
		return "night"


## Record an interaction the player performed
func record_interaction(interaction_id: String, tags: Dictionary) -> void:
	interaction_history.append({
		"id": interaction_id,
		"tags": tags,
		"time": game_time,
		"scene": current_scene,
	})
	metrics["interactions_initiated"] += 1


## Record an interaction the player passed without engaging
func record_missed(interaction_id: String, tags: Dictionary) -> void:
	missed_interactions.append({
		"id": interaction_id,
		"tags": tags,
		"time": game_time,
		"scene": current_scene,
	})


## Record meeting a character
func meet_character(character_id: String) -> void:
	if character_id not in met_characters:
		met_characters.append(character_id)


## Track stillness vs movement (called by player controller)
func record_movement(is_moving: bool, delta: float) -> void:
	if is_moving:
		metrics["time_spent_moving"] += delta
	else:
		metrics["time_spent_still"] += delta
