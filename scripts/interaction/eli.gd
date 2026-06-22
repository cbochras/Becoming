# Eli — Pre-Framework Character
# Disappears once any framework axis crosses the threshold.
# The only character who offers explicit choices.
# Gives zero framework drift.

extends Node2D

signal eli_conversation_finished
signal eli_disappeared

const DISAPPEAR_THRESHOLD := 0.35

var _conversation_started := false
var _conversation_finished := false
var _player_nearby := false
var _sit_time := 0.0
var _sit_triggered := false
var _gone := false

var _dialogue_stage := 0
var _choices_made: Array = []


func _ready() -> void:
	var area = $ProximityArea
	area.area_entered.connect(_on_player_entered)
	area.area_exited.connect(_on_player_exited)
	_check_should_exist()


func _process(delta: float) -> void:
	if _gone:
		return

	# Check if any framework crossed threshold — Eli vanishes
	if _should_disappear():
		_disappear()
		return

	# Track player sitting nearby (only if player is still)
	if _player_nearby and not _conversation_started and not _conversation_finished:
		var player = get_tree().get_first_node_in_group("player")
		var is_still = true
		if player and player is CharacterBody2D:
			is_still = player.velocity.length() < 5.0
		if is_still:
			_sit_time += delta
		else:
			_sit_time = 0.0
		if _sit_time >= 10.0 and not _sit_triggered:
			_sit_triggered = true
			_start_conversation()


func interact() -> void:
	if _gone or _conversation_finished:
		return
	if not _conversation_started:
		_start_conversation()


func show_hint() -> void:
	pass  # Eli doesn't glow. He's just there.


func hide_hint() -> void:
	pass


func _start_conversation() -> void:
	_conversation_started = true
	_dialogue_stage = 0
	_show_next_line()


func _show_next_line() -> void:
	var dialogue_ui = get_tree().get_first_node_in_group("dialogue_system")
	if not dialogue_ui:
		return

	match _dialogue_stage:
		0:
			dialogue_ui.start([
				{"speaker": "—", "text": "..."},
				{"speaker": "—", "text": "You fell asleep."},
				{"speaker": "—", "text": "The bus left. About ten minutes ago."},
			], "")
			dialogue_ui.dialogue_finished.connect(_on_dialogue_done, CONNECT_ONE_SHOT)
		1:
			_show_choice("Are you waiting for something?", [
				"I think so.",
				"Aren't we all?",
				"...",
			])
		2:
			dialogue_ui.start([
				{"speaker": "—", "text": "I come here because it's warm. And the sound."},
				{"speaker": "—", "text": "You hear it? The echo. The pigeons."},
				{"speaker": "—", "text": "My mum says I need a plan. Everyone says that."},
			], "")
			dialogue_ui.dialogue_finished.connect(_on_dialogue_done, CONNECT_ONE_SHOT)
		3:
			_show_choice("Do you have a plan?", [
				"I used to.",
				"I'm working on one.",
				"No.",
			])
		4:
			dialogue_ui.start([
				{"speaker": "—", "text": "I tried to have one. But every time I pick one..."},
				{"speaker": "—", "text": "I can feel the other ones leaving."},
				{"speaker": "—", "text": "Like doors closing that I didn't close."},
			], "")
			dialogue_ui.dialogue_finished.connect(_on_dialogue_done, CONNECT_ONE_SHOT)
		5:
			_show_choice("Do you think you have to be something? A type of person. With a word for it.", [
				"That's how the world works.",
				"I don't know.",
				"No.",
			])
		6:
			dialogue_ui.start([
				{"speaker": "—", "text": "My nan used to say — before she got confused —"},
				{"speaker": "—", "text": "She said: 'Don't let them finish you.'"},
				{"speaker": "—", "text": "I didn't know what that meant."},
				{"speaker": "—", "text": "I think I do now."},
				{"speaker": "—", "text": "She meant: don't let them turn you into a complete thing."},
				{"speaker": "—", "text": "Because once you're complete... you're done."},
				{"speaker": "—", "text": "You can't grow anymore. You're a statue."},
			], "")
			dialogue_ui.dialogue_finished.connect(_on_dialogue_done, CONNECT_ONE_SHOT)
		7:
			_show_choice("You seem... finished. Is that okay? Is it good?", [
				"I think it's necessary.",
				"I don't know.",
				"No. It isn't.",
			])
		8:
			dialogue_ui.start([
				{"speaker": "—", "text": "Maybe you don't have to be anything."},
				{"speaker": "—", "text": "Maybe that's allowed."},
			], "")
			dialogue_ui.dialogue_finished.connect(_on_final_done, CONNECT_ONE_SHOT)


func _on_dialogue_done(_character: String) -> void:
	_dialogue_stage += 1
	_show_next_line()


func _on_final_done(_character: String) -> void:
	_conversation_finished = true
	GameState.interaction_history.append({
		"id": "eli_conversation",
		"tags": {},
		"time": GameState.game_time,
		"scene": "bus_depot",
		"choices": _choices_made,
	})
	eli_conversation_finished.emit()


func _show_choice(question: String, options: Array) -> void:
	# Use the choice UI
	var choice_ui = get_tree().get_first_node_in_group("choice_system")
	if choice_ui and choice_ui.has_method("show_choice"):
		choice_ui.show_choice(question, options, _on_choice_made)
	else:
		# Fallback: skip choice, advance dialogue
		_choices_made.append(0)
		_dialogue_stage += 1
		_show_next_line()


func _on_choice_made(index: int) -> void:
	_choices_made.append(index)
	_dialogue_stage += 1
	_show_next_line()


func _should_disappear() -> bool:
	if _conversation_started and not _conversation_finished:
		return false  # Don't vanish mid-conversation
	for axis in FrameworkManager.values.keys():
		if float(FrameworkManager.values[axis]) >= DISAPPEAR_THRESHOLD:
			return true
	return false


func _check_should_exist() -> void:
	if _should_disappear():
		_disappear()


func _disappear() -> void:
	_gone = true
	eli_disappeared.emit()
	# Not hidden. Not flickered. Removed. Gone.
	queue_free()


func _on_player_entered(_area: Area2D) -> void:
	_player_nearby = true


func _on_player_exited(_area: Area2D) -> void:
	_player_nearby = false
	_sit_time = 0.0
