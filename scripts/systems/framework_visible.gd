# Framework Visible
# Attach to any node that should appear/disappear based on framework state.
# Handles full visibility, flickering, and complete hiding.

class_name FrameworkVisible
extends Node

## The framework axis required for visibility
@export var required_framework: String = "nihilism"
## Minimum value on that axis for full visibility
@export var visibility_threshold: float = 0.6
## Minimum value for flicker range (below threshold, above this = flicker)
@export var flicker_threshold: float = 0.4

var _parent: CanvasItem
var _is_visible := false
var _is_flicker := false


func _ready() -> void:
	_parent = get_parent() as CanvasItem
	if not _parent:
		push_warning("FrameworkVisible must be a child of a CanvasItem")
		return

	# Initial state: hidden
	_parent.visible = false
	_update_visibility()

	FrameworkManager.framework_changed.connect(_on_framework_changed)


func _on_framework_changed(_dominant: String, _values: Dictionary) -> void:
	_update_visibility()


func _update_visibility() -> void:
	if not _parent:
		return

	var val := FrameworkManager.get_world_value(required_framework)

	if val >= visibility_threshold:
		# Fully visible
		_parent.visible = true
		_parent.modulate.a = 1.0
		if _is_flicker:
			FlickerSystem.unregister_flicker_node(_parent)
			_is_flicker = false
		_is_visible = true

	elif val >= flicker_threshold:
		# Flicker range — hidden but registered for rare flicker
		_parent.visible = false
		if not _is_flicker:
			FlickerSystem.register_flicker_node(_parent)
			_is_flicker = true
		_is_visible = false

	else:
		# Completely hidden — doesn't exist
		_parent.visible = false
		if _is_flicker:
			FlickerSystem.unregister_flicker_node(_parent)
			_is_flicker = false
		_is_visible = false


func _exit_tree() -> void:
	if _is_flicker and _parent:
		FlickerSystem.unregister_flicker_node(_parent)
