# Flicker System
# Controls the rare peripheral appearance of near-threshold content.
# Flickers are: rare, peripheral, brief, unreliable.

extends Node

signal flicker_triggered(node_path: NodePath)

# Minimum seconds between any two flickers
const MIN_INTERVAL := 900.0  # 15 minutes minimum
# Maximum seconds between flickers
const MAX_INTERVAL := 1500.0  # 25 minutes maximum
# Duration of a single flicker (seconds)
const FLICKER_DURATION := 0.3
# Chance that a flicker is "real" (framework content) vs noise
const REAL_FLICKER_CHANCE := 0.55

var _time_until_next_flicker: float
var _registered_flicker_nodes: Array[Node] = []


func _ready() -> void:
	_time_until_next_flicker = randf_range(MIN_INTERVAL, MAX_INTERVAL)


func _process(delta: float) -> void:
	_time_until_next_flicker -= delta
	if _time_until_next_flicker <= 0.0:
		_attempt_flicker()
		_time_until_next_flicker = randf_range(MIN_INTERVAL, MAX_INTERVAL)


## Register a node that can flicker (called by FrameworkVisible nodes)
func register_flicker_node(node: Node) -> void:
	if node not in _registered_flicker_nodes:
		_registered_flicker_nodes.append(node)


## Unregister a flicker node (on scene exit)
func unregister_flicker_node(node: Node) -> void:
	_registered_flicker_nodes.erase(node)


func _attempt_flicker() -> void:
	# Clean dead references
	_registered_flicker_nodes = _registered_flicker_nodes.filter(
		func(n): return is_instance_valid(n) and n.is_inside_tree()
	)

	if _registered_flicker_nodes.is_empty():
		return

	# Pick a random flicker-eligible node
	var node: Node = _registered_flicker_nodes.pick_random()

	# Brief visibility pulse
	flicker_triggered.emit(node.get_path())
	_do_flicker(node)


func _do_flicker(node: Node) -> void:
	if not is_instance_valid(node):
		return

	# Only flicker CanvasItems (sprites, etc.)
	if node is CanvasItem:
		var canvas_item := node as CanvasItem
		var original_modulate := canvas_item.modulate

		# Flash: appear at low opacity, then vanish
		canvas_item.visible = true
		canvas_item.modulate.a = 0.0

		var tween := create_tween()
		# Fade in quickly
		tween.tween_property(canvas_item, "modulate:a", 0.3, FLICKER_DURATION * 0.3)
		# Hold briefly
		tween.tween_interval(FLICKER_DURATION * 0.4)
		# Fade out
		tween.tween_property(canvas_item, "modulate:a", 0.0, FLICKER_DURATION * 0.3)
		# Restore
		tween.tween_callback(func():
			canvas_item.visible = false
			canvas_item.modulate = original_modulate
		)
