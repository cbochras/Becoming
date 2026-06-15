class_name Typewriter
extends Label

## Typewriter — reveals text character by character.
## Creates the feeling of words being written, not displayed.

signal text_completed
signal character_revealed(char: String)

# === CONFIG ===
@export var base_speed: float = 0.035         # Seconds per character
@export var punctuation_pause: float = 0.15   # Extra pause after . , — : ;
@export var paragraph_pause: float = 0.4      # Extra pause after newline
@export var instant_mode: bool = false        # Skip animation (for debug)

# === STATE ===
var full_text: String = ""
var visible_chars: int = 0
var total_chars: int = 0
var is_revealing: bool = false
var char_timer: float = 0.0
var current_pause: float = 0.0

# Speed modifiers (can be changed by psyche state)
var speed_multiplier: float = 1.0  # Lower = faster, Higher = slower


func _ready() -> void:
	# Use visible_characters for reveal
	visible_characters = 0
	clip_text = true


func _process(delta: float) -> void:
	if not is_revealing:
		return
	
	char_timer += delta
	
	var effective_speed = base_speed * speed_multiplier
	var required_time = effective_speed + current_pause
	
	if char_timer >= required_time:
		char_timer = 0.0
		current_pause = 0.0
		_reveal_next_char()


## === PUBLIC API ===

## Start revealing text from the beginning
func reveal(new_text: String) -> void:
	full_text = new_text
	text = full_text
	total_chars = full_text.length()
	visible_chars = 0
	visible_characters = 0
	char_timer = 0.0
	current_pause = 0.0
	
	if instant_mode or full_text.is_empty():
		_complete_immediately()
		return
	
	is_revealing = true


## Skip to end (player pressed a key to skip)
func skip_to_end() -> void:
	if is_revealing:
		_complete_immediately()


## Check if currently animating
func is_active() -> bool:
	return is_revealing


## Set speed based on emotional context
func set_tone(tone: String) -> void:
	match tone:
		"awakening":
			speed_multiplier = 1.3     # Slow, dreamy morning
		"settling":
			speed_multiplier = 1.1     # Gentle evening
		"expansive":
			speed_multiplier = 0.9     # Slightly eager
		"gentle":
			speed_multiplier = 1.2     # Soft, careful
		"grounded":
			speed_multiplier = 1.0     # Steady
		"intimate":
			speed_multiplier = 1.4     # Night — slowest, most weight
		"dilemma":
			speed_multiplier = 1.0     # Normal for choices
		_:
			speed_multiplier = 1.0


## === INTERNAL ===

func _reveal_next_char() -> void:
	visible_chars += 1
	visible_characters = visible_chars
	
	# Get the character just revealed
	if visible_chars <= total_chars:
		var current_char = full_text[visible_chars - 1]
		character_revealed.emit(current_char)
		
		# Calculate pause for next character based on what was just revealed
		current_pause = _get_char_pause(current_char)
	
	# Check if complete
	if visible_chars >= total_chars:
		_complete_immediately()


func _get_char_pause(c: String) -> float:
	match c:
		".", "?", "!":
			return punctuation_pause * 1.5   # Full stop = longest pause
		",", ";", ":":
			return punctuation_pause          # Comma = medium pause
		"—", "–":
			return punctuation_pause * 1.2   # Em dash = dramatic pause
		"\n":
			return paragraph_pause            # New line = breath
		" ":
			return 0.0                        # Spaces are instant
		_:
			return 0.0


func _complete_immediately() -> void:
	visible_chars = total_chars
	visible_characters = -1  # Show all
	is_revealing = false
	text_completed.emit()
