# Choice System
# Minimal choice UI. Used only for Eli's conversation.
# Not a dialogue tree — just moments where the game asks and you answer.

extends CanvasLayer

var _panel: PanelContainer
var _question_label: Label
var _buttons: Array[Button] = []
var _callback: Callable
var _is_active := false


func _ready() -> void:
	layer = 11
	add_to_group("choice_system")

	_panel = PanelContainer.new()
	_panel.anchor_left = 0.5
	_panel.anchor_top = 0.5
	_panel.anchor_right = 0.5
	_panel.anchor_bottom = 0.5
	_panel.offset_left = -280.0
	_panel.offset_top = -80.0
	_panel.offset_right = 280.0
	_panel.offset_bottom = 80.0
	_panel.visible = false
	add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_panel.add_child(vbox)

	_question_label = Label.new()
	_question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_question_label.add_theme_font_size_override("font_size", 16)
	_question_label.add_theme_color_override("font_color", Color(0.83, 0.66, 0.34, 1))
	_question_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(_question_label)

	# Create 3 option buttons
	for i in range(3):
		var btn := Button.new()
		btn.add_theme_font_size_override("font_size", 14)
		btn.add_theme_color_override("font_color", Color(0.9, 0.88, 0.84, 1))
		btn.flat = true
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		var idx := i
		btn.pressed.connect(func(): _select(idx))
		vbox.add_child(btn)
		_buttons.append(btn)


func show_choice(question: String, options: Array, callback: Callable) -> void:
	_question_label.text = question
	_callback = callback
	_is_active = true

	for i in range(_buttons.size()):
		if i < options.size():
			_buttons[i].text = "  " + options[i]
			_buttons[i].visible = true
		else:
			_buttons[i].visible = false

	_panel.visible = true


func _select(index: int) -> void:
	_panel.visible = false
	_is_active = false
	if _callback.is_valid():
		_callback.call(index)
