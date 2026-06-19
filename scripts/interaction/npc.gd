# NPC
# A character in the world. May be framework-conditional.
# Handles proximity detection, dialogue triggering.

class_name NPC
extends Node2D

signal spoke_to(character_id: String)

var character_id: String = ""
var character_name: String = ""
var dialogue_file: String = ""
var interaction_id: String = ""
var framework_tags: Dictionary = {}

var _has_spoken := false
var _player_nearby := false


func _ready() -> void:
	var area = get_node_or_null("ProximityArea")
	if area:
		area.area_entered.connect(_on_player_entered)
		area.area_exited.connect(_on_player_exited)


func interact() -> void:
	if dialogue_file.is_empty():
		return

	# Apply framework tags
	if not framework_tags.is_empty() and not _has_spoken:
		FrameworkManager.apply_interaction(framework_tags)
		GameState.record_interaction(interaction_id, framework_tags)
		_has_spoken = true

	GameState.meet_character(character_id)
	spoke_to.emit(character_id)

	# Load dialogue based on current framework
	var lines := _load_dialogue()
	if lines.is_empty():
		return

	var dialogue_ui = get_tree().get_first_node_in_group("dialogue_system")
	if dialogue_ui and dialogue_ui.has_method("start"):
		dialogue_ui.start(lines, character_name)


func show_hint() -> void:
	modulate = Color(1.05, 1.02, 1.0, 1.0)


func hide_hint() -> void:
	modulate = Color.WHITE


func _load_dialogue() -> Array:
	var path := "res://data/dialogue/" + dialogue_file + ".json"
	if not FileAccess.file_exists(path):
		return []

	var file := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	if err != OK:
		return []

	var data: Dictionary = json.data
	var dominant := FrameworkManager.get_world_dominant()

	# Get framework-specific dialogue, fallback to default
	if dominant in data:
		return data[dominant]
	elif "default" in data:
		return data["default"]
	return []


func _on_player_entered(_area: Area2D) -> void:
	_player_nearby = true


func _on_player_exited(_area: Area2D) -> void:
	_player_nearby = false
