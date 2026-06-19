# Dialogue System
# Displays dialogue in a minimal, non-intrusive way.
# No dialogue tree with branching options — dialogue is observed, not chosen.

class_name DialogueSystem
extends CanvasLayer

signal dialogue_started(character: String)
signal dialogue_finished(character: String)

@onready var _panel: PanelContainer = $Panel
@onready var _label: RichTextLabel = $Panel/MarginContainer/Text
@onready var _speaker_label: Label = $Panel/SpeakerName

var _current_lines: Array = []
var _current_index: int = 0
var _current_character: String = ""
var _is_active := false

const CHARS_PER_SECOND := 40.0


func _ready() -> void:
	if _panel:
		_panel.visible = false
	add_to_group("dialogue_system")


func _unhandled_input(event: InputEvent) -> void:
	if not _is_active:
		return
	if event.is_action_pressed("interact") or (
		event is InputEventMouseButton and event.pressed
	):
		_advance()


## Start a dialogue sequence
## lines: Array of {text: String, speaker: String (optional)}
func start(lines: Array, character: String = "") -> void:
	_current_lines = lines
	_current_index = 0
	_current_character = character
	_is_active = true
	_panel.visible = true
	dialogue_started.emit(character)
	_show_current_line()


func _show_current_line() -> void:
	if _current_index >= _current_lines.size():
		_end_dialogue()
		return

	var line: Dictionary = _current_lines[_current_index]
	var text: String = line.get("text", "")
	var speaker: String = line.get("speaker", _current_character)

	_speaker_label.text = speaker
	_speaker_label.visible = speaker != ""
	_label.text = text
	_label.visible_ratio = 0.0

	# Typewriter effect
	var duration := text.length() / CHARS_PER_SECOND
	var tween := create_tween()
	tween.tween_property(_label, "visible_ratio", 1.0, duration)


func _advance() -> void:
	# If still typing, show all
	if _label.visible_ratio < 1.0:
		_label.visible_ratio = 1.0
		return
	# Otherwise next line
	_current_index += 1
	_show_current_line()


func _end_dialogue() -> void:
	_is_active = false
	_panel.visible = false
	dialogue_finished.emit(_current_character)
