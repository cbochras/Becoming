extends Node2D

var psyche: PsycheSystem
var dialogue: DialogueManager

# Visual nodes (created in code)
var background: ColorRect
var seed_visual: ColorRect
var label: Label

# Colors
var color_void = Color("#1a1e2e")
var color_curiosity = Color("#1a3a6e")
var color_compassion = Color("#5e1a3e")
var color_stability = Color("#1a4e2e")

# Current and target background color
var current_color: Color
var target_color: Color

# Seed animation
var seed_current_size: float = 40.0
var seed_target_size: float = 40.0

# Day cycle
var current_phase: int = 0
var phase_timer: float = 0.0
var phase_durations: Array[float] = [5.0, 60.0, 5.0, 5.0]
var day_active: bool = false
var choice_made: bool = false


func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	
	# Background - full screen
	background = ColorRect.new()
	background.color = color_void
	background.position = Vector2.ZERO
	background.size = viewport_size
	add_child(background)
	
	current_color = color_void
	target_color = color_void
	
	# Memory Seed - golden square below center
	seed_visual = ColorRect.new()
	seed_visual.color = Color("#c4a86e")
	seed_visual.size = Vector2(40, 40)
	seed_visual.position = Vector2(viewport_size.x / 2 - 20, viewport_size.y * 0.7)
	add_child(seed_visual)
	
	# Label - centered text (upper half of screen)
	label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position = Vector2(viewport_size.x / 2 - 350, viewport_size.y * 0.15)
	label.size = Vector2(700, 250)
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color("#c8cad0"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	add_child(label)
	
	# === CREATE SYSTEMS ===
	psyche = PsycheSystem.new()
	add_child(psyche)
	dialogue = DialogueManager.new(psyche)
	add_child(dialogue)
	
	# Connect signals
	psyche.psyche_changed.connect(_on_psyche_changed)
	psyche.voice_distorted.connect(_on_voice_distorted)
	psyche.convergence_approaching.connect(_on_convergence_approaching)
	
	# Start
	_start_day()


func _process(delta: float) -> void:
	# Smoothly transition background color
	current_color = current_color.lerp(target_color, delta * 0.8)
	background.color = current_color
	
	# Smoothly grow/shrink seed
	seed_current_size = lerp(seed_current_size, seed_target_size, delta * 1.5)
	seed_visual.size = Vector2(seed_current_size, seed_current_size)
	seed_visual.position = Vector2(
		get_viewport_rect().size.x / 2 - seed_current_size / 2,
		get_viewport_rect().size.y * 0.7
	)
	
	# Day cycle
	if not day_active:
		return
	
	if current_phase == 1 and not choice_made:
		return
	
	phase_timer += delta
	
	if phase_timer >= phase_durations[current_phase]:
		_advance_phase()


func _input(event: InputEvent) -> void:
	if current_phase == 1 and not choice_made:
		if event is InputEventKey and event.pressed:
			match event.keycode:
				KEY_1:
					_make_player_choice("curiosity", 7.0, "Chose to preserve fully — embrace the unknown")
				KEY_2:
					_make_player_choice("compassion", 7.0, "Chose to nurture gently — hold with care")
				KEY_3:
					_make_player_choice("stability", 7.0, "Chose to release the pain — preserve what's safe")


func _start_day() -> void:
	day_active = true
	current_phase = 0
	phase_timer = 0.0
	choice_made = false
	_enter_phase(0)


func _advance_phase() -> void:
	current_phase += 1
	phase_timer = 0.0
	
	if current_phase > 3:
		_end_day()
		return
	
	_enter_phase(current_phase)


func _enter_phase(phase: int) -> void:
	dialogue.set_phase(phase as DialogueManager.DayPhase)
	
	match phase:
		0:  # MORNING
			print("\n━━━━━━ ☀️  MORNING ━━━━━━")
			label.text = "You awaken in the Garden.\nThe light is uncertain. The voices stir."
			var lines = dialogue.trigger_voices(2)
			_print_voice_lines(lines)
			
		1:  # AFTERNOON
			print("\n━━━━━━ 🌤️  AFTERNOON — DILEMMA ━━━━━━")
			label.text = "A memory-seed pulses before you.\nIt holds wonder and pain together.\n\nPress 1 - Explore fully (Curiosity)\nPress 2 - Tend gently (Compassion)\nPress 3 - Release pain (Stability)"
			print("    Press 1, 2, or 3 to choose...")
			var lines = dialogue.trigger_debate()
			_print_voice_lines(lines)
			
		2:  # EVENING
			print("\n━━━━━━ 🌅  EVENING ━━━━━━")
			label.text = "The voices settle.\nThe garden breathes with what you've chosen."
			var lines = dialogue.trigger_voices(3)
			_print_voice_lines(lines)
			
		3:  # NIGHT
			print("\n━━━━━━ 🌙  NIGHT ━━━━━━")
			label.text = "Time folds.\n\nA figure appears — shaped like you, but heavier.\n\n\"I am what your choices become.\nIs this what you wanted?\""
			var lines = dialogue.trigger_voices(1)
			_print_voice_lines(lines)


func _end_day() -> void:
	day_active = false
	psyche.end_cycle()
	
	print("\n━━━━━━ ✦ END ━━━━━━")
	label.text = "\"This is who you are becoming.\""
	_print_final_state()


func _make_player_choice(voice_name: String, significance: float, context: String) -> void:
	choice_made = true
	phase_timer = 0.0
	
	# Make the choice
	psyche.make_choice(voice_name, significance, context)
	
	# Reject opposing voice
	match voice_name:
		"curiosity":
			psyche.reject_voice("stability", "Rejected caution")
		"compassion":
			psyche.reject_voice("stability", "Chose care over control")
		"stability":
			psyche.reject_voice("curiosity", "Rejected the unknown")
	
	print("\n    ► CHOSE: %s" % voice_name.to_upper())
	print("    \"%s\"" % context)
	
	label.text = "You chose.\nThe garden shifts.\nThe voices remember."
	
	# Grow the seed smoothly
	seed_target_size = 70.0
	
	phase_durations[1] = 3.0


# === SIGNALS ===

func _on_psyche_changed(identity_vector: Dictionary) -> void:
	var curiosity = identity_vector.get("curiosity", 40.0)
	var compassion = identity_vector.get("compassion", 40.0)
	var stability = identity_vector.get("stability", 40.0)
	
	var total = curiosity + compassion + stability
	if total == 0:
		return
	
	target_color = (
		color_curiosity * (curiosity / total) +
		color_compassion * (compassion / total) +
		color_stability * (stability / total)
	)
	
	var max_level = max(curiosity, max(compassion, stability))
	var boost = remap(max_level, 40.0, 85.0, 0.0, 0.2)
	target_color = target_color.lightened(clamp(boost, 0.0, 0.2))
	
	print("    [World responds — color shifting]")


func _on_voice_distorted(voice: Voice) -> void:
	print("  ⚠️  %s has become DISTORTED" % voice.voice_name)


func _on_convergence_approaching(voice_name: String, level: float) -> void:
	print("  ⚡ CONVERGENCE: %s at %.1f" % [voice_name, level])


func _print_voice_lines(lines: Array) -> void:
	for entry in lines:
		print("    %s: \"%s\"" % [entry["voice"], entry["line"]])


func _print_final_state() -> void:
	var state = psyche.get_system_state()
	for voice_data in state["voices"]:
		var bar_filled = int(voice_data["level"] / 5.0)
		var bar_empty = 20 - bar_filled
		var bar = "█".repeat(bar_filled) + "░".repeat(bar_empty)
		print("    %s [%s] %s (%.0f)" % [voice_data["name"], bar, voice_data["status"], voice_data["level"]])
