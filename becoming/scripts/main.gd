extends Node2D

# === SYSTEMS ===
var psyche: PsycheSystem
var dialogue: DialogueManager
var memory: IdentityMemory
var renderer: NarrativeRenderer
var resolver: IdentityResolver
var archivist: Archivist

# === VISUAL NODES ===
var background: ColorRect
var label: Label
var echo_label: Label
var day_label: Label

# === COLORS ===
var color_void = Color("#1a1e2e")
var color_curiosity = Color("#1a3a6e")
var color_compassion = Color("#5e1a3e")
var color_stability = Color("#1a4e2e")

# Background animation
var current_color: Color
var target_color: Color

# Echo text animation
var echo_opacity: float = 0.0
var echo_target_opacity: float = 0.0

# === MULTI-DAY SYSTEM ===
var current_day: int = 1
var total_days: int = 3

# Day cycle
var current_phase: int = 0
var phase_timer: float = 0.0
var phase_durations: Array[float] = [6.0, 60.0, 6.0, 8.0]
var day_active: bool = false
var choice_made: bool = false
var player_choice: String = ""
var player_sub_expression: String = ""

# Between days
var waiting_for_next_day: bool = false

# === PSYCHE LEAK CONFIG ===
const PSYCHE_LEAK_CHANCE: float = 0.15


func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	
	# === CREATE BACKGROUND ===
	background = ColorRect.new()
	background.color = color_void
	background.position = Vector2.ZERO
	background.size = viewport_size
	add_child(background)
	
	current_color = color_void
	target_color = color_void
	
	# === CREATE ARCHIVIST ===
	archivist = Archivist.new()
	add_child(archivist)
	
	# === CREATE LABELS ===
	label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position = Vector2(viewport_size.x / 2 - 350, viewport_size.y * 0.05)
	label.size = Vector2(700, 280)
	label.add_theme_font_size_override("font_size", 17)
	label.add_theme_color_override("font_color", Color("#c8cad0"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	add_child(label)
	
	echo_label = Label.new()
	echo_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	echo_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	echo_label.position = Vector2(viewport_size.x / 2 - 300, viewport_size.y * 0.38)
	echo_label.size = Vector2(600, 150)
	echo_label.add_theme_font_size_override("font_size", 15)
	echo_label.add_theme_color_override("font_color", Color("#a89060"))
	echo_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	echo_label.modulate.a = 0.0
	add_child(echo_label)
	
	day_label = Label.new()
	day_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	day_label.position = Vector2(viewport_size.x - 150, 15)
	day_label.size = Vector2(130, 30)
	day_label.add_theme_font_size_override("font_size", 14)
	day_label.add_theme_color_override("font_color", Color("#5a5a6a"))
	add_child(day_label)
	
	# === CREATE SYSTEMS ===
	psyche = PsycheSystem.new()
	add_child(psyche)
	
	dialogue = DialogueManager.new(psyche)
	add_child(dialogue)
	
	memory = IdentityMemory.new()
	add_child(memory)
	
	renderer = NarrativeRenderer.new()
	add_child(renderer)
	
	resolver = IdentityResolver.new()
	add_child(resolver)
	
	# === CONNECT SIGNALS ===
	psyche.psyche_changed.connect(_on_psyche_changed)
	psyche.voice_distorted.connect(_on_voice_distorted)
	psyche.convergence_approaching.connect(_on_convergence_approaching)
	
	memory.identity_updated.connect(_on_identity_updated)
	memory.trait_emerged.connect(_on_trait_emerged)
	memory.pattern_detected.connect(_on_pattern_detected)
	
	renderer.display_text.connect(_on_display_text)
	renderer.display_echo.connect(_on_display_echo)
	renderer.clear_echo.connect(_on_clear_echo)
	renderer.visual_event.connect(_on_visual_event)
	
	# Start
	_start_day()


func _process(delta: float) -> void:
	# Background transition
	current_color = current_color.lerp(target_color, delta * 0.8)
	background.color = current_color
	
	# Echo animation
	echo_opacity = lerp(echo_opacity, echo_target_opacity, delta * 0.5)
	echo_label.modulate.a = echo_opacity
	
	# Day cycle
	if not day_active:
		return
	
	if current_phase == 1 and not choice_made:
		return
	
	phase_timer += delta
	
	if phase_timer >= phase_durations[current_phase]:
		_advance_phase()


func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return
	
	# During dilemma
	if current_phase == 1 and not choice_made:
		match event.keycode:
			KEY_1:
				_make_player_choice("curiosity", _get_sub_expression("curiosity"))
			KEY_2:
				_make_player_choice("compassion", _get_sub_expression("compassion"))
			KEY_3:
				_make_player_choice("stability", _get_sub_expression("stability"))
	
	# Between days
	if waiting_for_next_day and event.keycode == KEY_SPACE:
		waiting_for_next_day = false
		_start_day()


# === SUB-EXPRESSION SELECTION ===

func _get_sub_expression(voice: String) -> String:
	match current_day:
		1:
			match voice:
				"curiosity": return "exploration"
				"compassion": return "care"
				"stability": return "detachment"
		2:
			match voice:
				"curiosity": return "confrontation"
				"compassion": return "sacrifice"
				"stability": return "patience"
		3:
			match voice:
				"curiosity": return "self_inquiry"
				"compassion": return "attunement"
				"stability": return "control"
	return ""


# === DAY MANAGEMENT ===

func _start_day() -> void:
	day_active = true
	current_phase = 0
	phase_timer = 0.0
	choice_made = false
	player_choice = ""
	player_sub_expression = ""
	
	echo_target_opacity = 0.0
	
	phase_durations = [6.0, 60.0, 6.0, 8.0]
	
	day_label.text = "Day %d / %d" % [current_day, total_days]
	
	# Tell the Archivist what day it is
	archivist.set_day(current_day)
	
	print("\n╔══════════════════════════════════════════════╗")
	print("║           DAY %d                              ║" % current_day)
	print("╚══════════════════════════════════════════════╝")
	
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
	
	# Resolve identity state at every phase transition
	var state = resolver.resolve(psyche, memory, current_day, phase)
	archivist.update_from_state(state)
	
	match phase:
		0:  # MORNING
			print("\n━━━━━━ ☀️  MORNING ━━━━━━")
			renderer.render(NarrativeRenderer.narration(_get_morning_text(), "awakening"))
			_trigger_voice_lines("observe", 2)
			
		1:  # AFTERNOON — DILEMMA
			print("\n━━━━━━ 🌤️  AFTERNOON — DILEMMA ━━━━━━")
			renderer.render(NarrativeRenderer.dilemma(_get_dilemma_text()))
			_trigger_voice_lines("dilemma", 3)
			
		2:  # EVENING
			print("\n━━━━━━ 🌅  EVENING ━━━━━━")
			renderer.render(NarrativeRenderer.narration("The voices settle.\nThe garden breathes with what you've chosen.", "settling"))
			echo_target_opacity = 0.0
			archivist.exit_night()
			_trigger_voice_lines("reflect", 3)
			
		3:  # NIGHT — ARCHIVIST CLOSEST
			print("\n━━━━━━ 🌙  NIGHT ━━━━━━")
			archivist.enter_night()
			_show_archivist_night_text()
			_trigger_voice_lines("night", 1)


func _end_day() -> void:
	day_active = false
	psyche.end_cycle()
	
	# Resolve identity state at end of day
	var state = resolver.resolve(psyche, memory, current_day, current_phase)
	archivist.update_from_state(state)
	archivist.exit_night()
	
	print("\n━━━━━━ ✦ END OF DAY %d ━━━━━━" % current_day)
	_print_final_state()
	memory.print_debug_state()
	
	current_day += 1
	
	if current_day > total_days:
		_show_ending()
	else:
		waiting_for_next_day = true
		label.text = "The garden holds your shape.\nAnother day will come.\n\n[Press SPACE to continue]"
		print("    Press SPACE to begin Day %d..." % current_day)


# === PLAYER CHOICE ===

func _make_player_choice(voice_name: String, sub_expression: String) -> void:
	choice_made = true
	phase_timer = 0.0
	player_choice = voice_name
	player_sub_expression = sub_expression
	
	var significance = 7.0
	var context = _get_choice_context(voice_name)
	
	# Record in psyche system
	psyche.make_choice(voice_name, significance, context, sub_expression)
	
	# Reject opposing voice
	var rejected = ""
	match voice_name:
		"curiosity":
			rejected = "stability"
			psyche.reject_voice("stability", "Rejected caution")
		"compassion":
			rejected = "stability"
			psyche.reject_voice("stability", "Chose care over control")
		"stability":
			rejected = "curiosity"
			psyche.reject_voice("curiosity", "Rejected the unknown")
	
	# Record in identity memory
	memory.record_choice(
		current_day, "afternoon", voice_name, sub_expression,
		significance, context, rejected
	)
	
	# Resolve identity state after choice
	var state = resolver.resolve(psyche, memory, current_day, current_phase)
	
	# Archivist reacts to the choice
	archivist.update_from_state(state)
	archivist.on_player_choice(voice_name, sub_expression)
	
	print("\n    ► CHOSE: %s (%s)" % [voice_name.to_upper(), sub_expression])
	print("    \"%s\"" % context)
	
	# Get response tone
	var response_tone = "neutral"
	match voice_name:
		"curiosity": response_tone = "expansive"
		"compassion": response_tone = "gentle"
		"stability": response_tone = "grounded"
	
	# Render choice response
	renderer.render(NarrativeRenderer.choice_response(_get_choice_response(), response_tone))
	
	phase_durations[1] = 4.0


# === VOICE LINES — WITH PSYCHE LEAK ===

func _trigger_voice_lines(context: String, max_voices: int) -> void:
	var active_voices = psyche.get_active_voices(max_voices)
	
	for voice in active_voices:
		var voice_name = voice.voice_name.to_lower()
		var dominant_expr = memory.get_dominant_expression(voice_name)
		if dominant_expr == "":
			dominant_expr = "general"
		
		# === PSYCHE LEAK: 15% chance voice speaks raw/unfiltered ===
		var is_leak = randf() < PSYCHE_LEAK_CHANCE
		if is_leak:
			dominant_expr = "general"
		
		var result = DialogueData.get_line_modified(voice, context, dominant_expr)
		if result.size() > 0:
			if is_leak:
				print("    💭 %s (LEAK|%s): \"%s\"" % [result["voice"], result["tone"], result["line"]])
			else:
				print("    %s (%s|%s): \"%s\"" % [result["voice"], result["sub_expression"], result["tone"], result["line"]])


# === ARCHIVIST NIGHT TEXT ===

func _show_archivist_night_text() -> void:
	var state = resolver.get_state()
	var conf = archivist.confidence
	
	match current_day:
		1:
			label.text = "Across the Garden, the figure has paused.\n\nTheir hand rests in the dirt.\nThe shapes they were drawing have changed."
			if conf >= 0.5:
				print("    [Archivist] Posture shifts — something registered.")
			else:
				print("    [Archivist] The figure is still. Uncertain.")
		2:
			label.text = "The figure is closer now.\nNot because they moved — because the Garden changed.\n\nWhen you look at them,\nsomething in their posture feels... familiar."
			var echo_text = _get_archivist_day2_echo(state)
			echo_label.text = echo_text
			echo_target_opacity = 0.6
			print("    [Archivist] Echo: \"%s\"" % echo_text)
		3:
			label.text = "The figure stands.\n\nFor the first time since you arrived,\nthey face you directly.\n\nIn their hands — a book you've never seen.\nThey open it slowly."
			var echo_text = _get_archivist_day3_echo(state, conf)
			echo_label.text = echo_text
			echo_target_opacity = 1.0
			print("    [Archivist] Speaks: \"%s\"" % echo_text)


func _get_archivist_day2_echo(state: Dictionary) -> String:
	var dominant = state.get("dominant_voice", "balanced")
	var tension = state.get("tension", "open")
	
	match tension:
		"narrowing":
			return "...the shape keeps repeating..."
		"closing":
			return "...doors closing, one by one..."
		"hardening":
			return "...something is being left behind..."
		"ungrounding":
			return "...reaching, always reaching..."
	
	match dominant:
		"curiosity":
			return "...further... always further..."
		"compassion":
			return "...holding... still holding..."
		"stability":
			return "...still here... exactly here..."
		_:
			return "...changing... still changing..."


func _get_archivist_day3_echo(state: Dictionary, conf: float) -> String:
	if conf >= 0.75:
		return "\"I think I understand you.\nNot completely — no one is complete —\nbut the shape repeats.\nI could draw you from memory now.\""
	elif conf >= 0.4:
		return "\"I tried to understand you.\nA pattern kept forming, then softening,\nthen returning.\nI can describe the weather around you\nbetter than I can describe you.\""
	else:
		return "\"I thought I knew you.\nThen you changed.\nOr perhaps I was the one changing\nwhile I watched.\""


# === MORNING TEXT ===

func _get_morning_text() -> String:
	match current_day:
		1:
			return "You awaken in the Garden.\nThe light is uncertain. The voices stir.\n\nAcross the Garden, a figure sits beneath a tree.\nThey are drawing shapes in the dirt."
		2:
			var state = resolver.get_state()
			var dominant = state.get("dominant_voice", "balanced")
			var base = ""
			match dominant:
				"curiosity":
					base = "You awaken again.\nThe Garden is wider today. Something opened overnight.\nThe air smells of distance."
				"compassion":
					base = "You awaken again.\nThe Garden is warmer today. Something softened overnight.\nThe ground remembers your touch."
				"stability":
					base = "You awaken again.\nThe Garden is quieter today. Something settled overnight.\nThe roots hold firm."
				_:
					base = "You awaken again.\nThe Garden has changed."
			return base + "\n\nThe figure is still there. Closer now.\nSymbols surround them — etched into the earth."
		3:
			var state = resolver.get_state()
			var pattern = state.get("active_pattern", "none")
			var base = ""
			match pattern:
				"consistent":
					base = "You awaken for what feels like the last time here.\nThe Garden has learned your shape."
				"oscillator":
					base = "You awaken for what feels like the last time here.\nThe Garden shifts around you — uncertain of your form."
				"late_shift":
					base = "You awaken for what feels like the last time here.\nThe Garden felt you turn in the night."
				_:
					base = "You awaken for what feels like the last time here.\nThe Garden knows you now."
			return base + "\n\nThe figure has changed.\nThey are standing. For the first time.\nIn their hands — something you haven't seen before."
	return "You awaken."


# === DILEMMA TEXT ===

func _get_dilemma_text() -> String:
	match current_day:
		1:
			return """A memory-seed rests before you — pulsing, alive.

It holds a moment: the last time you felt
completely understood by someone who is now gone.

The warmth is real. But so is the ache of absence.

  [1] Open it fully. Feel everything again.
       Even if it breaks you open. (Curiosity)

  [2] Hold it gently. Let the warmth stay,
       let the sharp edges soften. (Compassion)

  [3] Set it down. You've carried this long enough.
       Some weight isn't yours anymore. (Stability)"""
		
		2:
			return """A path splits before you — both directions fade into fog.

One path leads toward something you've always wanted
but never pursued. The other leads back to someone
who needs you — who has always needed you.

You cannot walk both. Not today.

  [1] Walk toward the unknown want.
       You've earned this. (Curiosity)

  [2] Return to the one who needs you.
       Love is not a burden. (Compassion)

  [3] Sit at the crossroads. Wait.
       Clarity will come if you don't force it. (Stability)"""
		
		3:
			return """The garden has grown dense around you.

Three days of choices have shaped this place.
Now the garden asks something in return:

"What will you leave behind when you go?"

  [1] Leave a door open. For whoever comes next.
       Discovery should not end with you. (Curiosity)

  [2] Leave a warmth. A memory of tending.
       So this place remembers being loved. (Compassion)

  [3] Leave the ground steady. Undisturbed.
       So what grows here has roots. (Stability)"""
	return ""


# === CHOICE CONTEXT ===

func _get_choice_context(voice: String) -> String:
	match current_day:
		1:
			match voice:
				"curiosity": return "Opened the memory fully"
				"compassion": return "Held the memory gently"
				"stability": return "Set the memory down"
		2:
			match voice:
				"curiosity": return "Walked toward the unknown"
				"compassion": return "Returned to the one who needs"
				"stability": return "Waited at the crossroads"
		3:
			match voice:
				"curiosity": return "Left a door open"
				"compassion": return "Left a warmth behind"
				"stability": return "Left the ground steady"
	return "Made a choice"


# === CHOICE RESPONSE ===

func _get_choice_response() -> String:
	match current_day:
		1:
			match player_choice:
				"curiosity":
					return "You open the memory completely.\n\nIt floods in — the voice, the laughter,\nthe exact quality of afternoon light.\nAnd then: the silence that followed.\n\nYou remember. All of it."
				"compassion":
					return "You hold the memory like water in cupped hands.\n\nThe warmth stays. The edges soften.\nYou choose to remember the love\nwithout reliving the loss.\n\nGentle. Deliberate."
				"stability":
					return "You set the memory down.\n\nNot thrown away — placed. Carefully.\nLike a stone returned to a riverbed.\nIt is part of the landscape now.\nNot part of your weight."
		2:
			match player_choice:
				"curiosity":
					return "You walk toward the want.\n\nEach step feels lighter and heavier\nat once. The fog parts like it was waiting.\nBehind you, the other path fades.\n\nYou don't look back."
				"compassion":
					return "You turn back.\n\nThe path home is shorter than you remembered.\nThey see you coming and something in their face\nunfolds like a held breath released.\n\nYou chose this. It chose you back."
				"stability":
					return "You sit.\n\nThe crossroads holds you. The fog doesn't clear\nbut it doesn't thicken either. You breathe.\nSomewhere, a bird calls — close, then far.\n\nThe answer will come. Or it won't.\nEither way, you're here."
		3:
			match player_choice:
				"curiosity":
					return "You leave the door open.\n\nWind moves through it already.\nWhoever comes next will find a garden\nthat invites exploration.\n\nYour curiosity becomes their doorway."
				"compassion":
					return "You leave a warmth.\n\nIt settles into the soil like memory.\nThe garden will grow differently now —\nsofter, more forgiving.\n\nYour tenderness becomes its climate."
				"stability":
					return "You leave the ground steady.\n\nRoots deepen in the silence you've kept.\nThe garden will hold whatever comes —\nstorm or stillness.\n\nYour patience becomes its foundation."
	return "You chose."


# === ENDING ===

func _show_ending() -> void:
	var state = resolver.get_state()
	var dominant = state.get("dominant_voice", "balanced")
	var dominant_expr = state.get("dominant_expression", "general")
	var character = state.get("character", "becoming")
	var tension = state.get("tension", "open")
	var conf = archivist.confidence
	
	# Archivist enters offering posture
	archivist.enter_offering(conf)
	
	# Build the ending sequence
	var archivist_line = _get_archivist_final_line(conf)
	var ending_text = _get_ending_text(dominant, dominant_expr)
	
	# Show Archivist's line first, then the ending
	echo_label.text = archivist_line
	echo_target_opacity = 1.0
	label.text = "The Archivist opens the book.\nEvery page is blank except one.\n\n\"I spent three days trying to understand you.\"\n\nThey look up.\n\n\"This is the closest I could get.\""
	
	# After a delay, show the actual ending
	var timer = get_tree().create_timer(6.0)
	timer.timeout.connect(func():
		label.text = ending_text
		echo_target_opacity = 0.0
	)
	
	print("\n╔══════════════════════════════════════════════╗")
	print("║        THIS IS WHO YOU BECAME                ║")
	print("╚══════════════════════════════════════════════╝")
	print("    Archivist confidence: %.2f (%s)" % [conf, _confidence_label(conf)])
	print("    Archivist says: \"%s\"" % archivist_line)
	print("    Dominant voice: %s" % dominant)
	print("    Dominant expression: %s" % dominant_expr)
	print("    Character: %s" % character)
	print("    Tension: %s" % tension)
	print("    Valence: %s" % str(state.get("valence", {})))
	print("    Pattern: %s" % state.get("active_pattern", "none"))
	_print_final_state()
	print("\n    ✦ Thank you for playing BECOMING. ✦")


func _get_archivist_final_line(conf: float) -> String:
	if conf >= 0.75:
		return "\"I think I understand you. Not completely —\nno one is complete — but the shape repeats.\nThe same door, the same turning, the same refusal.\nI could draw you from memory now.\""
	elif conf >= 0.4:
		return "\"I tried to understand you.\nA pattern kept forming, then softening, then returning.\nI can describe the weather around you\nbetter than I can describe you.\""
	else:
		return "\"I thought I knew you. Then you changed.\nOr perhaps I was the one changing while I watched.\nI have a page full of arrows pointing at one another\nand no final direction.\""


func _get_ending_text(dominant: String, dominant_expr: String) -> String:
	match dominant:
		"curiosity":
			match dominant_expr:
				"exploration":
					return "You became the one who opens doors.\n\nThe Garden remembers you as wind —\nalways moving, always seeking.\n\nBut the doors you left open\nchanged the shape of every room."
				"confrontation":
					return "You became the one who faces things.\n\nThe Garden remembers you as lightning —\nbrief, illuminating, unafraid.\n\nThe truths you spoke still echo\nin places that preferred silence."
				"self_inquiry":
					return "You became the one who asks.\n\nThe Garden remembers you as a mirror —\nreflecting everything, including itself.\n\nThe questions you left behind\nare still being answered by no one."
				_:
					return "You became the one who opens doors.\n\nThe Garden remembers you as wind —\nalways moving, always seeking.\n\nBut the doors you left open\nchanged the shape of every room."
		"compassion":
			match dominant_expr:
				"care":
					return "You became the one who tends.\n\nThe Garden remembers you as warmth —\nalways holding, always softening.\n\nBut the things you held\ngrew stronger for being loved."
				"sacrifice":
					return "You became the one who gives.\n\nThe Garden remembers you as soil —\nalways feeding, always beneath.\n\nEverything grew because of you.\nBut no one thought to water the ground."
				"attunement":
					return "You became the one who listens.\n\nThe Garden remembers you as resonance —\nalways feeling, always tuned.\n\nThe world registered in you completely.\nYou carried every frequency."
				_:
					return "You became the one who tends.\n\nThe Garden remembers you as warmth —\nalways holding, always softening.\n\nBut the things you held\ngrew stronger for being loved."
		"stability":
			match dominant_expr:
				"patience":
					return "You became the one who waits.\n\nThe Garden remembers you as season —\nalways turning, always trusting.\n\nThe patience you practiced\nbecame the rhythm everything else followed."
				"control":
					return "You became the one who holds the line.\n\nThe Garden remembers you as architecture —\nstraight edges, clear boundaries.\n\nInside your structure,\nbeautiful things grew safely."
				"detachment":
					return "You became the one who releases.\n\nThe Garden remembers you as autumn —\nalways letting go, always making room.\n\nWhat you dropped became mulch.\nNew things grew from your release."
				_:
					return "You became the one who stays.\n\nThe Garden remembers you as ground —\nalways steady, always here.\n\nBut the ground you held\nbecame home for everything that grew."
		_:
			return "You became no single thing.\n\nThe Garden remembers you as weather —\nchanging, contradicting, alive.\nNever the same twice.\n\nBut in your inconsistency,\nsomething honest took root."


func _confidence_label(conf: float) -> String:
	if conf >= 0.75:
		return "certain"
	elif conf >= 0.4:
		return "provisional"
	else:
		return "fractured"


# === SIGNAL HANDLERS ===

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


func _on_identity_updated(_identity_vector: Dictionary) -> void:
	pass


func _on_trait_emerged(trait_name: String, value: float) -> void:
	print("  🌿 TRAIT EMERGED: %s (%.2f)" % [trait_name, value])


func _on_pattern_detected(pattern_name: String) -> void:
	print("  🔮 PATTERN DETECTED: %s" % pattern_name)


func _on_voice_distorted(voice: Voice) -> void:
	print("  ⚠️  %s has become DISTORTED" % voice.voice_name)


func _on_convergence_approaching(voice_name: String, level: float) -> void:
	print("  ⚡ CONVERGENCE: %s at %.1f" % [voice_name, level])


func _on_display_text(text: String, _style: String) -> void:
	label.text = text


func _on_display_echo(text: String, _speaker: String, _tone: String) -> void:
	echo_label.text = text
	echo_target_opacity = 1.0


func _on_clear_echo() -> void:
	echo_target_opacity = 0.0


func _on_visual_event(event_type: String, params: Dictionary) -> void:
	match event_type:
		"brighten":
			target_color = current_color.lightened(params.get("amount", 0.05))
		"darken":
			target_color = current_color.darkened(params.get("amount", 0.03))


# === UTILITY ===

func _print_final_state() -> void:
	var state = psyche.get_system_state()
	for voice_data in state["voices"]:
		var bar_filled = int(voice_data["level"] / 5.0)
		var bar_empty = 20 - bar_filled
		var bar = "█".repeat(bar_filled) + "░".repeat(bar_empty)
		print("    %s [%s] %s (%.0f)" % [voice_data["name"], bar, voice_data["status"], voice_data["level"]])
