
class_name DialogueData
extends RefCounted

## Dialogue lines now organized by voice + sub-expression.
## Each voice speaks differently based on WHICH flavor is dominant.

# Structure: voice_name -> context -> sub_expression -> [lines]
# Falls back to "general" sub_expression if specific one has no lines

static var lines: Dictionary = {
	"Curiosity": {
		"observe": {
			"exploration": [
				"There's something past that edge. Can you feel it pulling?",
				"Look — the light bends differently there. What's it hiding?",
				"Every boundary is just an invitation in disguise.",
			],
			"confrontation": [
				"You're avoiding that corner of the garden. Why?",
				"What are you afraid you'll find if you look closer?",
				"The thing you won't examine is the thing that owns you.",
			],
			"self_inquiry": [
				"What does it mean that you noticed this before anything else?",
				"Your attention went there first. What does that tell you?",
				"The garden shows you yourself. Are you looking?",
			],
			"general": [
				"There's something past that edge. Can you feel it?",
				"Look — the light bends differently there. Why?",
				"What else is out there, beyond what we've seen?",
			],
		},
		"dilemma": {
			"exploration": [
				"Go through the door. The worst that happens is you learn something.",
				"You already know what staying feels like. Don't you want to know what going feels like?",
			],
			"confrontation": [
				"You're hesitating because you already know the answer. Say it.",
				"Stop pretending this is complicated. You know what you want.",
			],
			"self_inquiry": [
				"Before you choose — what does your hesitation tell you about yourself?",
				"Which choice scares you more? That's the one worth examining.",
			],
			"general": [
				"Go through the door. What's the worst that happens — you learn something?",
				"You already know what staying feels like. Don't you want to know what going feels like?",
			],
		},
		"reflect": {
			"exploration": [
				"The world got a little larger today. That's never a loss.",
				"Every door you open becomes part of the landscape. This one is yours now.",
			],
			"confrontation": [
				"You faced it. That's more than most people do with a lifetime.",
				"The truth didn't kill you. It never does. It just rearranges things.",
			],
			"self_inquiry": [
				"What did you learn about yourself today? Sit with it.",
				"You chose. Now ask: was that who you are, or who you're becoming?",
			],
			"general": [
				"The world got a little larger today. That's never a loss.",
				"Every door you open becomes part of the landscape.",
			],
		},
		"night": {
			"general": [
				"What else is out there, beyond what we've seen?",
				"Even in the dark, I'm reaching for the edge of things.",
				"Sleep is just another threshold. What's on the other side?",
			],
		},
	},
	"Compassion": {
		"observe": {
			"care": [
				"Something here is hurting. Can you feel it too?",
				"There's a warmth here — faint, but real. Someone left it.",
			],
			"sacrifice": [
				"Who else is in this garden? They might need you more.",
				"Your comfort can wait. Look around first.",
			],
			"attunement": [
				"The garden itself is breathing. Listen to its rhythm.",
				"Something shifted just now. Did you feel it? Something tender.",
			],
			"general": [
				"Something here is hurting. Can you feel it too?",
				"There's a warmth here — faint, but real. Someone left it.",
				"This place remembers being tended. It misses it.",
			],
		},
		"dilemma": {
			"care": [
				"Before you choose — who else does this affect?",
				"What would kindness do here? Not softness — kindness. They're different.",
			],
			"sacrifice": [
				"Maybe this isn't about what you want. Maybe it's about what's needed.",
				"You can bear this. The question is whether you should.",
			],
			"attunement": [
				"Feel into all three options. Which one resonates in your body?",
				"Your thinking mind has opinions. What does your feeling mind say?",
			],
			"general": [
				"Before you choose — who else does this affect?",
				"What would kindness do here? Not softness — kindness.",
			],
		},
		"reflect": {
			"care": [
				"The world is a little warmer now. You did that.",
				"Someone somewhere just felt a little less alone. Because of you.",
			],
			"sacrifice": [
				"You gave something today. Don't forget to notice what it cost.",
				"Generosity without awareness becomes depletion. Watch that edge.",
			],
			"attunement": [
				"You felt it all today. Every ripple. That's exhausting. That's also sacred.",
				"The world registered in you fully. Let that be enough.",
			],
			"general": [
				"The world is a little warmer now. You did that.",
				"What you gave today will grow in soil you'll never see.",
			],
		},
		"night": {
			"general": [
				"Who are you holding in your mind right now? They matter.",
				"Even rest is an act of care — for yourself.",
				"The warmth you gave today is still radiating somewhere.",
			],
		},
	},
	"Stability": {
		"observe": {
			"patience": [
				"The ground held. It always does. Give it time.",
				"Not everything needs to happen today. Look how steady this is.",
			],
			"control": [
				"Mark the boundaries. Know what's yours. Know what isn't.",
				"Order isn't the enemy of beauty. It's the container for it.",
			],
			"detachment": [
				"You don't need to engage with everything you see.",
				"Some things are just landscape. They don't require your attention.",
			],
			"general": [
				"The ground held. See? Caution has its rewards.",
				"Not everything needs to change. Some things are already right.",
				"Notice how the still things have their own kind of beauty.",
			],
		},
		"dilemma": {
			"patience": [
				"There's wisdom in staying. Not everything still is stagnant.",
				"Wait. The answer that comes from patience is different from the one you force.",
			],
			"control": [
				"What we have works. Are you sure you want to disturb it?",
				"Calculate the risk. Really calculate it. Then decide.",
			],
			"detachment": [
				"You could also just... not choose. That's allowed.",
				"This doesn't have to be your problem. Set it down.",
			],
			"general": [
				"There's wisdom in staying. Not everything still is stagnant.",
				"What we have works. Are you sure you want to disturb it?",
			],
		},
		"reflect": {
			"patience": [
				"See? The ground holds. You didn't need to rush.",
				"Time proved you right. It usually does, if you let it.",
			],
			"control": [
				"The structure held. Because you maintained it.",
				"Everything in its place. There's peace in that.",
			],
			"detachment": [
				"You let it go. The world didn't end. Remember that.",
				"Sometimes the bravest thing is to not engage.",
			],
			"general": [
				"The ground held. See? Caution has its rewards.",
				"Sometimes the bravest thing is to not move.",
			],
		},
		"night": {
			"general": [
				"Rest now. Tomorrow the ground will still be here.",
				"Nothing collapsed today. Let that be enough.",
				"Stillness isn't emptiness. It's readiness.",
			],
		},
	},
}


# === GET LINE — Now with sub-expression awareness ===

static func get_line(voice: Voice, context: String, sub_expression: String = "") -> String:
	var voice_name = voice.voice_name
	
	if not lines.has(voice_name):
		return ""
	if not lines[voice_name].has(context):
		return ""
	
	var context_lines = lines[voice_name][context]
	
	# Try specific sub-expression first
	if sub_expression != "" and context_lines.has(sub_expression):
		var pool = context_lines[sub_expression]
		if pool.size() > 0:
			return pool[randi() % pool.size()]
	
	# Fall back to "general"
	if context_lines.has("general"):
		var pool = context_lines["general"]
		if pool.size() > 0:
			return pool[randi() % pool.size()]
	
	return ""


# === GET LINE WITH STATUS MODIFIER ===

static func get_line_modified(voice: Voice, context: String, sub_expression: String = "") -> Dictionary:
	var line = get_line(voice, context, sub_expression)
	if line == "":
		return {}
	
	var tone = "clear"
	
	# Modify based on voice status
	match voice.status:
		Voice.Status.WEAKENED:
			tone = "fragile"
			# Weakened voices speak with less certainty
			line = _weaken_line(line)
		Voice.Status.DISTORTED:
			tone = "twisted"
			# Distorted voices twist their own philosophy
			line = _distort_line(line, voice.voice_name)
	
	return {
		"line": line,
		"tone": tone,
		"voice": voice.voice_name,
		"sub_expression": sub_expression,
		"status": Voice.Status.keys()[voice.status],
	}


static func _weaken_line(line: String) -> String:
	# Add uncertainty markers to weakened lines
	var prefixes = ["Maybe... ", "I think... ", "If you can still hear me... "]
	return prefixes[randi() % prefixes.size()] + line.to_lower()


static func _distort_line(line: String, voice_name: String) -> String:
	# Distorted voices become corrupted versions of themselves
	match voice_name:
		"Curiosity":
			# Becomes obsessive, invasive
			return line.replace("?", "? You NEED to know. You HAVE to—")
		"Compassion":
			# Becomes martyrdom, guilt
			return "You're not doing ENOUGH. " + line
		"Stability":
			# Becomes rigidity, paralysis
			return "DON'T MOVE. " + line.replace(".", ". Stay. STAY.")
	return line
