# Bus Departure — The "You Left" Ending
# An Area2D in the bus depot that, when entered while the bus is here,
# triggers the early ending.

extends Area2D

var _ending_triggered := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	BusSystem.depot_closed.connect(_on_depot_closed)


func _on_body_entered(body: Node2D) -> void:
	if _ending_triggered:
		return
	if body is PlayerController and BusSystem.can_board():
		_trigger_ending()


func _on_depot_closed() -> void:
	queue_free()


func _trigger_ending() -> void:
	_ending_triggered = true

	# Create full-screen canvas layer for the ending
	var canvas := CanvasLayer.new()
	canvas.layer = 200
	get_tree().root.add_child(canvas)

	# Black overlay
	var overlay := ColorRect.new()
	overlay.anchor_left = 0.0
	overlay.anchor_top = 0.0
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.offset_right = 0.0
	overlay.offset_bottom = 0.0
	overlay.color = Color(0, 0, 0, 0)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	canvas.add_child(overlay)

	# "You left." text centered
	var label := Label.new()
	label.text = "You left."
	label.anchor_left = 0.5
	label.anchor_top = 0.5
	label.anchor_right = 0.5
	label.anchor_bottom = 0.5
	label.offset_left = -150.0
	label.offset_top = -20.0
	label.offset_right = 150.0
	label.offset_bottom = 20.0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", Color(0.9, 0.88, 0.84, 0.0))
	canvas.add_child(label)

	# Fade to black then show text
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(overlay, "color:a", 1.0, 2.0)
	tween.tween_interval(1.5)
	tween.tween_property(label, "theme_override_colors/font_color:a", 1.0, 2.0)

	# Pause the game after fade starts
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = true
