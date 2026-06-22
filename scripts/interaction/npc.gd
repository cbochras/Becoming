# NPC
# A character in the world. Always visible. May be framework-gated
# (present but not interactable until threshold met).

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
var _gate: FrameworkGated = null


func _ready() -> void:
	# Check if this NPC is framework-gated
	_gate = get_node_or_null("FrameworkGated") as FrameworkGated

	var area = get_node_or_null("ProximityArea")
	if area:
		area.area_entered.connect(_on_player_entered)
		area.area_exited.connect(_on_player_exited)


func _process(delta: float) -> void:
	# Handle glances when player is nearby but can't interact yet
	if _player_nearby and _gate and not _gate.can_interact():
		if _gate.try_glance(delta):
			_do_glance()


func interact() -> void:
	# Check gate
	if _gate and not _gate.can_interact():
		_show_unavailable()
		return

	if dialogue_file.is_empty():
		return

	# Apply framework tags
	if not framework_tags.is_empty() and not _has_spoken:
		FrameworkManager.apply_interaction(framework_tags)
		GameState.record_interaction(interaction_id, framework_tags)
		_has_spoken = true

	GameState.meet_character(character_id)
	spoke_to.emit(character_id)

	var lines := _load_dialogue()
	if lines.is_empty():
		return

	var dialogue_ui = get_tree().get_first_node_in_group("dialogue_system")
	if dialogue_ui and dialogue_ui.has_method("start"):
		dialogue_ui.start(lines, character_name)


func show_hint() -> void:
	if _gate and not _gate.can_interact():
		return  # No hint if unavailable
	modulate = Color(1.05, 1.02, 1.0, 1.0)


func hide_hint() -> void:
	modulate = Color.WHITE


func _show_unavailable() -> void:
	var text: String = _gate.get_unavailable_response() if _gate else "..."
	var dialogue_ui = get_tree().get_first_node_in_group("dialogue_system")
	if dialogue_ui and dialogue_ui.has_method("start"):
		dialogue_ui.start([{"text": text, "speaker": ""}], "")


func _do_glance() -> void:
	# Brief visual indication — a subtle nod/shift
	var tween := create_tween()
	tween.tween_property(self, "position:y", position.y - 2.0, 0.2)
	tween.tween_interval(0.3)
	tween.tween_property(self, "position:y", position.y, 0.2)


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

	if dominant in data:
		return data[dominant]
	elif "default" in data:
		return data["default"]
	return []


func _on_player_entered(_area: Area2D) -> void:
	_player_nearby = true


func _on_player_exited(_area: Area2D) -> void:
	_player_nearby = false
