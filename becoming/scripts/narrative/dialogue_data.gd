class_name DialogueData
extends RefCounted

# === VOICE LINES DATABASE ===
# Organized by: voice → status → context → lines[]
# Context types: "observe", "dilemma", "reflect", "night"
# The system picks lines based on voice state + current phase of the day

static var lines: Dictionary = {
	"curiosity": {
		"healthy": {
			"observe": [
				"There's something past that edge. Can you feel it?",
				"This place wasn't here yesterday. Or was it?",
				"Look — the light bends differently there. Why?",
				"Everything here is an invitation. Even the silence.",
			],
			"dilemma": [
				"Go through the door. What's the worst that happens — you learn something?",
				"You already know what staying feels like. Don't you want to know what going feels like?",
				"The unknown isn't dangerous. It's just... unknown.",
				"If you don't look, you'll always wonder. And wondering is heavier than knowing.",
			],
			"reflect": [
				"See? That wasn't so terrible. And now you know something you didn't before.",
				"Every door you open becomes part of the landscape. This one is yours now.",
				"The world got a little larger today. That's never a loss.",
			],
			"night": [
				"What else is out there, beyond what we've seen?",
				"Even in the dark, there are outlines of things waiting to be found.",
			],
		},
		"weakened": {
			"observe": [
				"...is there something there? I can't quite...",
				"Maybe. I don't know anymore.",
			],
			"dilemma": [
				"You could... look? If you wanted to. It's fine either way.",
				"I used to feel more strongly about this.",
			],
			"reflect": [
				"Did that matter? I think it did. Once.",
			],
			"night": [
				"....",
			],
		},
		"distorted": {
			"observe": [
				"THERE. Did you see that? We need to go. NOW.",
				"Everything here is hiding something. Everything.",
				"Why are we standing still? There's always more. ALWAYS.",
			],
			"dilemma": [
				"Open it. Open everything. What are you afraid of?",
				"Staying is death. Comfort is a coffin. MOVE.",
				"You'll never have enough. Accept that and keep searching.",
			],
			"reflect": [
				"That wasn't enough. It's never enough. What's next?",
				"Already? We're done already? There has to be more.",
			],
			"night": [
				"I can't sleep. There's too much left unseen. Too much.",
			],
		},
	},
	
	"compassion": {
		"healthy": {
			"observe": [
				"Something here is hurting. Can you feel it too?",
				"This place remembers being tended. It misses it.",
				"There's a warmth here — faint, but real. Someone left it.",
				"Not everything needs to be understood. Some things just need to be held.",
			],
			"dilemma": [
				"Before you choose — who else does this affect?",
				"You're thinking about yourself again. That's okay. But also look outward.",
				"The gentle choice isn't always the weak one.",
				"What would kindness do here? Not softness — kindness. They're different.",
			],
			"reflect": [
				"That was brave. Choosing others when you could have chosen yourself.",
				"The world is a little warmer now. You did that.",
				"Connection always costs something. But look what it grows.",
			],
			"night": [
				"Who are you holding in your mind right now? They matter.",
				"Even in the quiet, you're not alone. You carry everyone you've loved.",
			],
		},
		"weakened": {
			"observe": [
				"...I suppose someone should care about that.",
				"It's there. I see it. I just... can't reach it right now.",
			],
			"dilemma": [
				"Do what you want. Everyone does eventually.",
				"Others? I... yes. Others exist. I remember.",
			],
			"reflect": [
				"Fine. It's fine.",
			],
			"night": [
				"...",
			],
		},
		"distorted": {
			"observe": [
				"Everything here is suffering. EVERYTHING. Can't you see?",
				"You walk past so much pain. How do you do that?",
				"We should be helping. Always helping. Why are we stopping?",
			],
			"dilemma": [
				"Choose them. Always choose them. You don't matter here.",
				"Your needs are selfish. Give everything. EVERYTHING.",
				"If you choose yourself, you're abandoning them. All of them.",
			],
			"reflect": [
				"It wasn't enough. You could have given more. You always could.",
				"They're still hurting. And you're here, doing nothing.",
			],
			"night": [
				"How can you rest when others can't?",
			],
		},
	},
	
	"stability": {
		"healthy": {
			"observe": [
				"We've been here before. It's safe. The ground holds.",
				"Notice how this part stays constant. That's worth something.",
				"There's a rhythm to this place. Let it be. It works.",
				"Not everything needs to change. Some things are good as they are.",
			],
			"dilemma": [
				"We have enough uncertainty already. Is this worth the risk?",
				"What we have works. Are you sure you want to disturb it?",
				"There's wisdom in staying. Not everything still is stagnant.",
				"Consider: what do you lose if you change this?",
			],
			"reflect": [
				"The ground held. See? Caution has its rewards.",
				"We're still here. Still whole. That matters.",
				"Sometimes the bravest thing is to not move.",
			],
			"night": [
				"Rest now. Tomorrow the ground will still hold you.",
				"The world doesn't need to be different. It needs to be steady.",
			],
		},
		"weakened": {
			"observe": [
				"Is this... safe? I can't tell anymore.",
				"Everything shifts. I can't find the ground.",
			],
			"dilemma": [
				"I don't... I don't know what's safe anymore.",
				"Do what you want. Nothing stays anyway.",
			],
			"reflect": [
				"We survived. I think. Did we?",
			],
			"night": [
				"Will this still be here tomorrow?",
			],
		},
		"distorted": {
			"observe": [
				"DON'T MOVE. Everything is exactly where it needs to be.",
				"If you touch that, everything falls apart. EVERYTHING.",
				"The order is perfect. Perfect. Don't you DARE disturb it.",
			],
			"dilemma": [
				"NO. We stay. We always stay. Change is destruction.",
				"You want to risk EVERYTHING we've built? For what? CURIOSITY?",
				"Choose safety. Choose it. The alternative is annihilation.",
			],
			"reflect": [
				"See what happens when things change? SEE?",
				"We need more control. More structure. More walls.",
			],
			"night": [
				"I'll watch. Someone has to watch. Always.",
			],
		},
	},
}


# === RETRIEVAL METHODS ===

## Get a line for a specific voice, based on current state and context
static func get_line(voice: Voice, context: String) -> String:
	var voice_key = voice.voice_name.to_lower()
	var status_key = _get_status_key(voice)
	
	if not lines.has(voice_key):
		return ""
	if not lines[voice_key].has(status_key):
		status_key = "healthy"  # fallback
	if not lines[voice_key][status_key].has(context):
		return ""
	
	var available_lines = lines[voice_key][status_key][context]
	if available_lines.is_empty():
		return ""
	
	# Pick a random line from available options
	return available_lines[randi() % available_lines.size()]


## Get status key string from voice status enum
static func _get_status_key(voice: Voice) -> String:
	match voice.status:
		Voice.Status.HEALTHY:
			return "healthy"
		Voice.Status.WEAKENED:
			return "weakened"
		Voice.Status.DISTORTED:
			return "distorted"
		Voice.Status.SILENT:
			return "silent"
	return "healthy"
