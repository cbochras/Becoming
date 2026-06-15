class_name AudioManager
extends Node

## AudioManager — Dynamic mixer that responds to psyche, phase, and confidence.
## Crossfades ambient drones, triggers Archivist SFX, and designs silence.

# === AMBIENT LAYERS ===
var drone_morning: AudioStreamPlayer
var drone_afternoon: AudioStreamPlayer
var drone_evening: AudioStreamPlayer
var drone_night: AudioStreamPlayer
var active_drones: Array[AudioStreamPlayer] = []

# === SFX PLAYERS ===
var sfx_writing: AudioStreamPlayer
var sfx_page_turn: AudioStreamPlayer
var sfx_choice: AudioStreamPlayer
var sfx_transition: AudioStreamPlayer
var sfx_typewriter: AudioStreamPlayer

# === STATE ===
var current_phase: int = 0
var target_volumes: Dictionary = {}
var is_active: bool = true

# === CONFIG ===
const CROSSFADE_SPEED: float = 0.8       # How fast drones blend (lower = slower)
const SFX_BASE_VOLUME: float = -12.0     # dB
const DRONE_BASE_VOLUME: float = -18.0   # dB (drones are quiet foundations)
const SILENCE_DUCK_DB: float = -40.0     # Effectively silent


func _ready() -> void:
	# === CREATE AMBIENT DRONE PLAYERS ===
	drone_morning = _create_drone_player("morning")
	drone_afternoon = _create_drone_player("afternoon")
	drone_evening = _create_drone_player("evening")
	drone_night = _create_drone_player("night")
	
	active_drones = [drone_morning, drone_afternoon, drone_evening, drone_night]
	
	# === CREATE SFX PLAYERS ===
	sfx_writing = _create_sfx_player("writing")
	sfx_page_turn = _create_sfx_player("page_turn")
	sfx_choice = _create_sfx_player("choice")
	sfx_transition = _create_sfx_player("transition")
	sfx_typewriter = _create_sfx_player("typewriter")
	
	# Start with all drones silent
	for drone in active_drones:
		drone.volume_db = SILENCE_DUCK_DB
	
	# Initialize targets
	target_volumes = {
		"morning": SILENCE_DUCK_DB,
		"afternoon": SILENCE_DUCK_DB,
		"evening": SILENCE_DUCK_DB,
		"night": SILENCE_DUCK_DB,
	}


func _process(delta: float) -> void:
	if not is_active:
		return
	
	# Crossfade drones toward target volumes
	_crossfade_drone(drone_morning, target_volumes["morning"], delta)
	_crossfade_drone(drone_afternoon, target_volumes["afternoon"], delta)
	_crossfade_drone(drone_evening, target_volumes["evening"], delta)
	_crossfade_drone(drone_night, target_volumes["night"], delta)


## === PUBLIC API ===

## Called when phase changes — crossfade to new ambient
func set_phase(phase: int) -> void:
	current_phase = phase
	
	# Reset all targets to silent
	for key in target_volumes:
		target_volumes[key] = SILENCE_DUCK_DB
	
	# Activate the right drone
	match phase:
		0:  # Morning
			target_volumes["morning"] = DRONE_BASE_VOLUME
		1:  # Afternoon
			target_volumes["afternoon"] = DRONE_BASE_VOLUME
		2:  # Evening
			target_volumes["evening"] = DRONE_BASE_VOLUME + 2.0  # Slightly louder
		3:  # Night
			target_volumes["night"] = DRONE_BASE_VOLUME + 4.0    # Most present
	
	# Play transition whoosh
	_play_sfx(sfx_transition)


## Psyche colors the drone (adjusts which drones bleed through)
func apply_psyche_color(dominant_voice: String, confidence: float) -> void:
	# Higher confidence = cleaner single drone
	# Lower confidence = bleed from adjacent phases
	if confidence < 0.4:
		# Fractured — multiple drones bleed through
		for key in target_volumes:
			if target_volumes[key] > SILENCE_DUCK_DB:
				target_volumes[key] += 2.0  # Louder primary
			else:
				target_volumes[key] = DRONE_BASE_VOLUME - 8.0  # Bleed others in
	
	# Voice affects overall tone (through bus effects later)
	# For now, adjust night drone presence
	match dominant_voice:
		"curiosity":
			# Shimmer — boost high-end drone slightly
			if target_volumes["morning"] > SILENCE_DUCK_DB:
				target_volumes["morning"] += 1.0
		"compassion":
			# Warmth — boost evening
			if target_volumes["evening"] > SILENCE_DUCK_DB:
				target_volumes["evening"] += 1.0
		"stability":
			# Weight — boost night/low
			if target_volumes["night"] > SILENCE_DUCK_DB:
				target_volumes["night"] += 1.0


## Archivist writing sounds
func play_writing(confidence: float) -> void:
	if sfx_writing.stream == null:
		return
	
	# Confidence affects writing sound behavior
	if confidence >= 0.75:
		# Smooth, continuous
		_play_sfx(sfx_writing)
	elif confidence >= 0.4:
		# Play, pause, play
		_play_sfx(sfx_writing)
		var timer = get_tree().create_timer(randf_range(0.8, 1.5))
		timer.timeout.connect(func(): _play_sfx(sfx_writing))
	else:
		# Scratchy, stopping, restarting
		_play_sfx(sfx_writing)
		var timer = get_tree().create_timer(randf_range(0.3, 0.6))
		timer.timeout.connect(func():
			sfx_writing.stop()
			var timer2 = get_tree().create_timer(randf_range(0.5, 1.0))
			timer2.timeout.connect(func(): _play_sfx(sfx_writing))
		)


## Page turn — only on Day 3 reveal
func play_page_turn() -> void:
	_play_sfx(sfx_page_turn)


## Choice resonance — different per voice
func play_choice_sound(voice_name: String) -> void:
	# Later: load different streams per voice
	# For now: pitch shift based on voice
	match voice_name:
		"curiosity":
			sfx_choice.pitch_scale = 1.2   # Higher, brighter
		"compassion":
			sfx_choice.pitch_scale = 1.0   # Warm, centered
		"stability":
			sfx_choice.pitch_scale = 0.8   # Lower, grounded
	_play_sfx(sfx_choice)


## Typewriter tick (very subtle, per character)
func play_typewriter_tick() -> void:
	if sfx_typewriter.stream == null:
		return
	# Randomize pitch slightly for organic feel
	sfx_typewriter.pitch_scale = randf_range(0.9, 1.1)
	sfx_typewriter.volume_db = SFX_BASE_VOLUME - 8.0  # Very quiet
	_play_sfx(sfx_typewriter)


## Silence design — duck everything for dramatic pause
func duck_for_silence(duration: float) -> void:
	var original_volumes = target_volumes.duplicate()
	
	# Duck all drones
	for key in target_volumes:
		target_volumes[key] = SILENCE_DUCK_DB
	
	# Restore after duration
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(func():
		target_volumes = original_volumes
	)


## === INTERNAL ===

func _create_drone_player(drone_name: String) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = "Ambient"
	player.volume_db = SILENCE_DUCK_DB
	
	# Try to load the audio file
	var path = "res://audio/ambient/drone_%s.ogg" % drone_name
	if ResourceLoader.exists(path):
		player.stream = load(path)
		player.autoplay = true
	else:
		print("[AudioManager] Missing: %s (will be silent)" % path)
	
	add_child(player)
	return player


func _create_sfx_player(sfx_name: String) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = "SFX"
	player.volume_db = SFX_BASE_VOLUME
	
	var path = "res://audio/sfx/%s.ogg" % sfx_name
	if ResourceLoader.exists(path):
		player.stream = load(path)
	else:
		print("[AudioManager] Missing: %s (no sound)" % path)
	
	add_child(player)
	return player


func _play_sfx(player: AudioStreamPlayer) -> void:
	if player.stream != null:
		player.play()


func _crossfade_drone(drone: AudioStreamPlayer, target_db: float, delta: float) -> void:
	drone.volume_db = lerp(drone.volume_db, target_db, delta * CROSSFADE_SPEED)
