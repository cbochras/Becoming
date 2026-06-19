# Interactable
# Base class for anything the player can engage with.
# Tracks whether the player engaged or passed by (for framework reading).

class_name Interactable
extends Node2D

signal interacted
signal player_passed

## Unique ID for this interaction (for history tracking)
@export var interaction_id: String = ""
## Framework tags applied when the player interacts
@export var framework_tags: Dictionary = {}
## How close the player needs to be to interact
@export var interaction_radius: float = 50.0
## Whether this has been interacted with already
var has_been_interacted := false

var _player_was_nearby := false
var _player_nearby_time := 0.0
var _area: Area2D


func _ready() -> void:
	if has_node("Area2D"):
		_area = $Area2D
	else:
		_create_default_area()
	_area.area_entered.connect(_on_player_entered_vicinity)
	_area.area_exited.connect(_on_player_left_vicinity)


func interact() -> void:
	if has_been_interacted:
		return
	has_been_interacted = true

	# Apply framework shift
	if not framework_tags.is_empty():
		FrameworkManager.apply_interaction(framework_tags)

	# Record in game state
	GameState.record_interaction(interaction_id, framework_tags)

	interacted.emit()
	_on_interact()


## Override in subclasses for specific behavior
func _on_interact() -> void:
	pass


## Visual hint when player is nearby (override for custom)
func show_hint() -> void:
	# Subtle warmth shift — not a glowing outline
	modulate = Color(1.05, 1.02, 1.0, 1.0)


func hide_hint() -> void:
	modulate = Color.WHITE


func _on_player_entered_vicinity(_area_that_entered: Area2D) -> void:
	_player_was_nearby = true


func _on_player_left_vicinity(_area_that_left: Area2D) -> void:
	if not has_been_interacted and _player_was_nearby:
		# Player was near but didn't interact — record as missed
		GameState.record_missed(interaction_id, framework_tags)
		GameState.metrics["objects_passed"] += 1
		player_passed.emit()
	_player_was_nearby = false


func _create_default_area() -> void:
	_area = Area2D.new()
	_area.name = "Area2D"
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = interaction_radius
	collision.shape = shape
	_area.add_child(collision)
	add_child(_area)
