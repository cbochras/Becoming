# Scene Manager
# Handles transitions between location scenes with fade effects.

extends Node

signal scene_transition_started(from: String, to: String)
signal scene_transition_finished(scene_name: String)

var _current_scene: Node = null
var _transition_overlay: ColorRect = null
var _is_transitioning := false

const FADE_DURATION := 0.8


func _ready() -> void:
	# Create the fade overlay (covers entire screen)
	_transition_overlay = ColorRect.new()
	_transition_overlay.color = Color(0.1, 0.12, 0.13, 0.0)  # Deep charcoal, transparent
	_transition_overlay.anchors_preset = Control.PRESET_FULL_RECT
	_transition_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_transition_overlay.z_index = 100

	# Add to the scene tree at root level
	var canvas := CanvasLayer.new()
	canvas.layer = 100
	canvas.name = "TransitionLayer"
	canvas.add_child(_transition_overlay)
	add_child(canvas)


## Transition to a new location scene
func go_to(scene_path: String, entry_point: String = "default") -> void:
	if _is_transitioning:
		return
	_is_transitioning = true

	var old_scene := GameState.current_scene
	scene_transition_started.emit(old_scene, scene_path)

	# Fade out
	var tween := create_tween()
	tween.tween_property(_transition_overlay, "color:a", 1.0, FADE_DURATION)
	await tween.finished

	# Remove current scene (the main scene or previous location)
	var root := get_tree().root
	if _current_scene and is_instance_valid(_current_scene):
		_current_scene.queue_free()
		await _current_scene.tree_exited
	else:
		# First transition — remove the main scene
		var main := root.get_node_or_null("Main")
		if main:
			main.queue_free()
			await main.tree_exited

	# Load new scene
	var packed: PackedScene = load(scene_path)
	_current_scene = packed.instantiate()
	root.add_child(_current_scene)

	# Position player at entry point
	_position_player_at_entry(entry_point)

	GameState.current_scene = scene_path

	# Fade in
	var tween_in := create_tween()
	tween_in.tween_property(_transition_overlay, "color:a", 0.0, FADE_DURATION)
	await tween_in.finished

	_is_transitioning = false
	scene_transition_finished.emit(scene_path)


func _position_player_at_entry(entry_point: String) -> void:
	if not _current_scene:
		return
	var marker := _current_scene.get_node_or_null("EntryPoints/" + entry_point)
	var player := _current_scene.get_node_or_null("Player")
	if marker and player:
		player.global_position = marker.global_position
