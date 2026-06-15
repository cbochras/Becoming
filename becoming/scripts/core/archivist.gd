class_name Archivist
extends Node2D

## The Archivist — an unresolved self trying to understand the player.
## Visually: abstract silhouette with glow, sway, and posture states.

# === CONFIGURATION ===
var base_position: Vector2
var current_day: int = 1
var confidence: float = 0.5
var dominant_voice: String = "balanced"

# === VISUAL STATE ===
var body: Polygon2D
var glow: Polygon2D
var head: Polygon2D
var head_glow: Polygon2D

# Colors
var body_color: Color = Color(0.12, 0.12, 0.16, 0.95)
var glow_color: Color = Color(0.6, 0.5, 0.3, 0.3)
var target_glow_color: Color = Color(0.6, 0.5, 0.3, 0.3)

# Psyche-driven glow colors
var glow_curiosity: Color = Color(0.3, 0.5, 0.8, 0.35)
var glow_compassion: Color = Color(0.7, 0.35, 0.45, 0.35)
var glow_stability: Color = Color(0.3, 0.65, 0.4, 0.35)
var glow_neutral: Color = Color(0.6, 0.5, 0.3, 0.3)

# Sway
var sway_time: float = 0.0
var sway_amount: float = 3.0           # Pixels of horizontal sway
var sway_speed: float = 1.2            # Oscillation speed
var target_sway_amount: float = 3.0

# Breathing (vertical subtle pulse)
var breath_time: float = 0.0
var breath_amount: float = 2.0
var breath_speed: float = 0.8

# Posture
enum Posture { SITTING, LEANING, STANDING, OFFERING }
var current_posture: Posture = Posture.SITTING
var posture_lerp: float = 0.0
var target_posture_lerp: float = 0.0

# Night proximity
var is_night: bool = false
var night_offset: float = 0.0
var target_night_offset: float = 0.0

# Scale animation
var current_scale: float = 1.0
var target_scale: float = 1.0


func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	
	# Position Archivist on the right side (since text is now left)
	base_position = Vector2(viewport_size.x * 0.7, viewport_size.y * 0.55)
	position = base_position
	
	# Build visual layers
	_build_body()


func _process(delta: float) -> void:
	# Sway animation (inversely proportional to confidence)
	sway_time += delta * sway_speed
	sway_amount = lerp(sway_amount, target_sway_amount, delta * 2.0)
	var sway_offset = sin(sway_time) * sway_amount
	
	# Breathing animation
	breath_time += delta * breath_speed
	var breath_offset = sin(breath_time) * breath_amount
	
	# Night proximity
	night_offset = lerp(night_offset, target_night_offset, delta * 0.8)
	
	# Apply position
	position.x = base_position.x + sway_offset + night_offset
	position.y = base_position.y + breath_offset
	
	# Glow color transition
	glow_color = glow_color.lerp(target_glow_color, delta * 0.8)
	glow.color = glow_color
	head_glow.color = Color(glow_color.r, glow_color.g, glow_color.b, glow_color.a * 0.6)
	
	# Scale transition
	current_scale = lerp(current_scale, target_scale, delta * 1.5)
	scale = Vector2(current_scale, current_scale)
	
	# Posture transition
	posture_lerp = lerp(posture_lerp, target_posture_lerp, delta * 0.8)
	_update_posture_shape()


## === PUBLIC API ===

func set_day(day: int) -> void:
	current_day = day
	match day:
		1:
			current_posture = Posture.SITTING
			target_posture_lerp = 0.0
			target_scale = 0.8
		2:
			current_posture = Posture.LEANING
			target_posture_lerp = 0.5
			target_scale = 0.9
		3:
			current_posture = Posture.STANDING
			target_posture_lerp = 1.0
			target_scale = 1.0


func update_from_state(state: Dictionary) -> void:
	dominant_voice = state.get("dominant_voice", "balanced")
	confidence = state.get("confidence", 0.5)
	
	# Confidence affects sway (less confident = more movement)
	target_sway_amount = remap(confidence, 0.0, 1.0, 6.0, 1.0)
	
	# Confidence affects sway speed (less confident = faster, more anxious)
	sway_speed = remap(confidence, 0.0, 1.0, 2.0, 0.8)
	
	# Confidence affects breath speed
	breath_speed = remap(confidence, 0.0, 1.0, 1.2, 0.6)
	
	# Dominant voice affects glow color
	match dominant_voice:
		"curiosity":
			target_glow_color = glow_curiosity
		"compassion":
			target_glow_color = glow_compassion
		"stability":
			target_glow_color = glow_stability
		_:
			target_glow_color = glow_neutral


func on_player_choice(voice_name: String, _sub_expression: String) -> void:
	# Brief reaction — the Archivist notices
	match voice_name:
		"curiosity":
			target_glow_color = glow_curiosity
		"compassion":
			target_glow_color = glow_compassion
		"stability":
			target_glow_color = glow_stability
	
	# Quick scale pulse (reacts to choice)
	target_scale = current_scale + 0.05
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(func():
		set_day(current_day)  # Restore normal scale
	)


func enter_night() -> void:
	is_night = true
	target_night_offset = -60.0  # Move closer (leftward toward player/text)
	glow_color.a = min(glow_color.a + 0.1, 0.5)
	target_glow_color.a = 0.45


func exit_night() -> void:
	is_night = false
	target_night_offset = 0.0
	target_glow_color.a = 0.3


func enter_offering(conf: float) -> void:
	# Final posture — the Archivist presents the book
	current_posture = Posture.OFFERING
	target_posture_lerp = 1.0
	target_scale = 1.1
	target_night_offset = -80.0  # Closest to player
	
	# Confidence affects final glow intensity
	if conf >= 0.75:
		target_glow_color.a = 0.5
		target_sway_amount = 0.5  # Very still
	elif conf >= 0.4:
		target_glow_color.a = 0.4
		target_sway_amount = 3.0
	else:
		target_glow_color.a = 0.3
		target_sway_amount = 7.0  # Restless


## === INTERNAL: BUILD VISUAL ===

func _build_body() -> void:
	# Body (dark silhouette) — build FIRST
	body = Polygon2D.new()
	body.color = body_color
	body.polygon = _get_body_shape(0.0)
	add_child(body)

	# Head (dark circle approximation)
	head = Polygon2D.new()
	head.color = body_color
	head.polygon = _get_head_shape(0.0)
	add_child(head)

	# Glow layer (behind body — move to back)
	glow = Polygon2D.new()
	glow.color = glow_color
	glow.polygon = _get_glow_shape()
	add_child(glow)
	move_child(glow, 0)  # Send glow behind body

	# Head glow
	head_glow = Polygon2D.new()
	head_glow.color = Color(glow_color.r, glow_color.g, glow_color.b, glow_color.a * 0.6)
	head_glow.polygon = _get_head_glow_shape()
	add_child(head_glow)
	move_child(head_glow, 1)  # Behind head, in front of body glow


func _update_posture_shape() -> void:
	body.polygon = _get_body_shape(posture_lerp)
	head.polygon = _get_head_shape(posture_lerp)
	glow.polygon = _get_glow_shape()
	head_glow.polygon = _get_head_glow_shape()


func _get_body_shape(lerp_val: float) -> PackedVector2Array:
	# Morph between sitting (wide, low) → standing (narrow, tall)
	var width_base = lerp(40.0, 28.0, lerp_val)
	var width_top = lerp(30.0, 22.0, lerp_val)
	var height = lerp(60.0, 110.0, lerp_val)
	var y_offset = lerp(20.0, -30.0, lerp_val)  # Rises as it stands
	
	# Slight asymmetry for organic feel
	return PackedVector2Array([
		Vector2(-width_base, y_offset + height),       # Bottom left
		Vector2(-width_base * 0.9, y_offset + height * 0.6),  # Left hip
		Vector2(-width_top, y_offset),                 # Left shoulder
		Vector2(-width_top * 0.4, y_offset - 8.0),    # Left neck
		Vector2(width_top * 0.4, y_offset - 8.0),     # Right neck
		Vector2(width_top * 1.05, y_offset),           # Right shoulder (slight asymmetry)
		Vector2(width_base * 0.95, y_offset + height * 0.6),  # Right hip
		Vector2(width_base * 1.02, y_offset + height), # Bottom right
	])


func _get_head_shape(lerp_val: float) -> PackedVector2Array:
	var y_offset = lerp(10.0, -45.0, lerp_val)
	var radius = 14.0
	var points: PackedVector2Array = PackedVector2Array()
	
	for i in range(12):
		var angle = (float(i) / 12.0) * TAU
		points.append(Vector2(cos(angle) * radius, y_offset + sin(angle) * radius * 1.1))
	
	return points


func _get_glow_shape() -> PackedVector2Array:
	# Slightly larger than body for glow effect
	var body_points = body.polygon
	var glow_points: PackedVector2Array = PackedVector2Array()
	
	for point in body_points:
		var direction = point.normalized()
		glow_points.append(point + direction * 8.0)
	
	return glow_points


func _get_head_glow_shape() -> PackedVector2Array:
	var head_points = head.polygon
	var glow_points: PackedVector2Array = PackedVector2Array()
	
	for point in head_points:
		var direction = point.normalized()
		glow_points.append(point + direction * 6.0)
	
	return glow_points
