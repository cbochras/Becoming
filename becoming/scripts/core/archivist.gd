
class_name Archivist
extends Node2D

## The Archivist — an unresolved self trying to understand the player.
## Absorbs: Memory (the book), Resolver (understanding), Future Self (final form).
## The player's choices shape it. Its confidence determines how it speaks.

# === VISUAL COMPONENTS ===
var body: ColorRect               # The silhouette
var activity_mark: ColorRect      # What they're doing (dirt marks → symbols → book)
var glow: ColorRect               # Ambient glow around them

# === STATE ===
var current_day: int = 1
var posture: String = "sitting"   # sitting, leaning, standing, offering
var confidence: float = 0.0       # 0.0–1.0 from resolver
var dominant_voice: String = ""
var character: String = ""

# === ANIMATION ===
var body_target_height: float = 60.0
var body_current_height: float = 60.0
var body_target_width: float = 30.0
var body_current_width: float = 30.0
var body_target_y: float = 0.0
var body_current_y: float = 0.0

var glow_target_opacity: float = 0.15
var glow_current_opacity: float = 0.15
var glow_target_size: float = 80.0
var glow_current_size: float = 80.0

var activity_target_opacity: float = 0.0
var activity_current_opacity: float = 0.0

var sway_time: float = 0.0
var sway_amount: float = 1.0

# Writing animation
var is_writing: bool = false
var write_timer: float = 0.0
var write_pause: bool = false      # For fractured confidence — hesitant writing

# === BASE COLORS ===
var color_neutral = Color("#c4a86e")
var color_curiosity = Color("#4a7eb5")
var color_compassion = Color("#b57a4a")
var color_stability = Color("#4ab57a")
var color_glow_base = Color("#c4a86e")

# === POSITION ===
var base_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	base_position = Vector2(viewport_size.x / 2, viewport_size.y * 0.62)
	
	# === CREATE GLOW (behind body) ===
	glow = ColorRect.new()
	glow.color = color_glow_base
	glow.modulate.a = 0.15
	glow.size = Vector2(80, 80)
	glow.position = base_position - Vector2(40, 40)
	add_child(glow)
	
	# === CREATE BODY (the silhouette) ===
	body = ColorRect.new()
	body.color = color_neutral
	body.size = Vector2(30, 60)
	body.position = base_position - Vector2(15, 60)
	add_child(body)
	
	# === CREATE ACTIVITY MARK (dirt/symbols/book) ===
	activity_mark = ColorRect.new()
	activity_mark.color = Color("#8a7a5a")
	activity_mark.size = Vector2(20, 4)
	activity_mark.position = base_position + Vector2(-10, 10)
	activity_mark.modulate.a = 0.0
	add_child(activity_mark)
	
	# Start Day 1 appearance
	_set_day_appearance(1)


func _process(delta: float) -> void:
	sway_time += delta
	
	# Smooth body transitions
	body_current_height = lerp(body_current_height, body_target_height, delta * 1.2)
	body_current_width = lerp(body_current_width, body_target_width, delta * 1.2)
	body_current_y = lerp(body_current_y, body_target_y, delta * 1.0)
	
	# Apply body size + position with subtle sway
	var sway_offset = sin(sway_time * sway_amount) * 1.5
	body.size = Vector2(body_current_width, body_current_height)
	body.position = Vector2(
		base_position.x - body_current_width / 2 + sway_offset,
		base_position.y - body_current_height + body_current_y
	)
	
	# Glow animation
	glow_current_opacity = lerp(glow_current_opacity, glow_target_opacity, delta * 0.6)
	glow_current_size = lerp(glow_current_size, glow_target_size, delta * 0.8)
	glow.modulate.a = glow_current_opacity
	glow.size = Vector2(glow_current_size, glow_current_size)
	glow.position = Vector2(
		base_position.x - glow_current_size / 2 + sway_offset,
		base_position.y - glow_current_size / 2 - body_current_height * 0.3
	)
	
	# Activity mark animation
	activity_current_opacity = lerp(activity_current_opacity, activity_target_opacity, delta * 0.8)
	activity_mark.modulate.a = activity_current_opacity
	
	# Writing animation (activity mark pulses when writing)
	if is_writing:
		write_timer += delta
		if write_pause and confidence < 0.4:
			# Fractured confidence: hesitant, stopping and starting
			if fmod(write_timer, 2.0) < 0.5:
				activity_mark.modulate.a = activity_current_opacity * 0.3
			else:
				activity_mark.modulate.a = activity_current_opacity
		else:
			# Smooth writing pulse
			var pulse = (sin(write_timer * 3.0) + 1.0) / 2.0
			activity_mark.size.x = lerp(15.0, 25.0, pulse)


## === PUBLIC API ===

## Called when resolver produces new state
func update_from_state(state: Dictionary) -> void:
	dominant_voice = state.get("dominant_voice", "balanced")
	character = state.get("character", "becoming")
	confidence = _calculate_visual_confidence(state)
	
	# Update colors based on dominant voice
	_update_colors()
	
	# Update sway based on confidence
	# High confidence = still. Low confidence = more movement
	sway_amount = lerp(2.5, 0.5, confidence)


## Called at the start of each day
func set_day(day: int) -> void:
	current_day = day
	_set_day_appearance(day)


## Called when player makes a choice — Archivist reacts
func on_player_choice(voice_name: String, _sub_expression: String) -> void:
	# Brief visual reaction
	is_writing = true
	write_timer = 0.0
	write_pause = confidence < 0.4
	
	# Posture shifts slightly toward the chosen voice
	match voice_name:
		"curiosity":
			body_target_height += 3.0   # Stretches taller
			body_target_width -= 1.0
		"compassion":
			body_target_width += 2.0    # Gets rounder
			glow_target_opacity += 0.03
		"stability":
			body_target_height -= 1.0   # Gets denser
			body_target_width += 1.0
			body_target_y += 2.0        # Settles lower
	
	# Stop writing after a few seconds
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(func(): is_writing = false)


## Called during Night phase — Archivist is closest to communicating
func enter_night() -> void:
	glow_target_opacity = 0.35
	glow_target_size = glow_current_size + 20.0
	# Archivist "leans" toward the player
	body_target_y -= 5.0


## Called when night ends
func exit_night() -> void:
	glow_target_opacity = 0.15
	body_target_y += 5.0


## Called at the ending — Archivist offers the book
func enter_offering(final_confidence: float) -> void:
	posture = "offering"
	confidence = final_confidence
	
	# Stand fully tall
	body_target_height = 90.0
	body_target_width = 35.0
	body_target_y = -10.0
	
	# Glow expands
	glow_target_opacity = 0.5
	glow_target_size = 140.0
	
	# Book appears (activity mark becomes larger, brighter)
	activity_mark.color = Color("#d4c088")
	activity_mark.size = Vector2(25, 20)
	activity_mark.position = Vector2(
		base_position.x - 12,
		base_position.y - 90.0  # Held up at "hand" level
	)
	activity_target_opacity = 1.0
	
	# Animation based on confidence
	if confidence >= 0.75:
		sway_amount = 0.3  # Almost still — certain
	elif confidence >= 0.4:
		sway_amount = 1.2  # Slight movement — provisional
	else:
		sway_amount = 3.0  # Restless — fractured


## === INTERNAL ===

func _set_day_appearance(day: int) -> void:
	match day:
		1:
			# Sitting, distant, drawing in dirt
			posture = "sitting"
			body_target_height = 45.0
			body_target_width = 35.0
			body_target_y = 15.0   # Lower = sitting
			glow_target_opacity = 0.1
			glow_target_size = 60.0
			sway_amount = 0.8
			
			# Activity: small marks in the dirt
			activity_mark.color = Color("#6a5a3a")
			activity_mark.size = Vector2(15, 3)
			activity_mark.position = base_position + Vector2(-7, 20)
			activity_target_opacity = 0.4
			
		2:
			# Leaning forward, closer, symbols around
			posture = "leaning"
			body_target_height = 60.0
			body_target_width = 32.0
			body_target_y = 5.0
			glow_target_opacity = 0.2
			glow_target_size = 90.0
			sway_amount = 1.2
			
			# Activity: symbols (slightly larger marks)
			activity_mark.color = Color("#8a7a5a")
			activity_mark.size = Vector2(25, 6)
			activity_mark.position = base_position + Vector2(-12, 15)
			activity_target_opacity = 0.6
			
		3:
			# Standing, has book, facing player
			posture = "standing"
			body_target_height = 80.0
			body_target_width = 30.0
			body_target_y = -5.0
			glow_target_opacity = 0.3
			glow_target_size = 110.0
			sway_amount = 0.5
			
			# Activity: the book (rectangular, brighter)
			activity_mark.color = Color("#c4a86e")
			activity_mark.size = Vector2(20, 15)
			activity_mark.position = Vector2(
				base_position.x - 10,
				base_position.y - 50
			)
			activity_target_opacity = 0.8


func _update_colors() -> void:
	var target_body_color: Color
	var target_glow_color: Color
	
	match dominant_voice:
		"curiosity":
			target_body_color = color_neutral.lerp(color_curiosity, 0.4)
			target_glow_color = color_glow_base.lerp(color_curiosity, 0.3)
		"compassion":
			target_body_color = color_neutral.lerp(color_compassion, 0.4)
			target_glow_color = color_glow_base.lerp(color_compassion, 0.3)
		"stability":
			target_body_color = color_neutral.lerp(color_stability, 0.4)
			target_glow_color = color_glow_base.lerp(color_stability, 0.3)
		_:
			target_body_color = color_neutral
			target_glow_color = color_glow_base
	
	body.color = body.color.lerp(target_body_color, 0.1)
	glow.color = glow.color.lerp(target_glow_color, 0.1)


func _calculate_visual_confidence(state: Dictionary) -> float:
	# Derive confidence from resolver state
	# This is a visual approximation — the real confidence calc lives in resolver
	var pattern = state.get("active_pattern", "none")
	var tension = state.get("tension", "open")
	
	var conf = 0.5  # Default: provisional
	
	match pattern:
		"consistent":
			conf = 0.85
		"oscillator":
			conf = 0.55
		"late_shift":
			conf = 0.25
		"none":
			conf = 0.4
	
	# Tension modifies confidence slightly
	match tension:
		"narrowing":
			conf += 0.1   # System is more sure (maybe too sure)
		"open":
			conf -= 0.05  # Still forming
		"closing", "hardening", "ungrounding":
			conf -= 0.1   # Something suppressed = harder to read
	
	return clamp(conf, 0.0, 1.0)
