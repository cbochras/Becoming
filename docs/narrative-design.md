# The Remainder — Narrative Design Document

---

## Vision

The game does what Souls games do — but for the mind instead of the body.

Souls games teach you: failure isn't death, it's information. You are capable. The world
doesn't owe you an explanation. Persist, and something changes — not the world, but you.

The Remainder teaches you: perception isn't truth, it's a lens. You are blind in ways you
cannot detect. The world contains more than you can hold. And the shape of your blindness
IS the shape of who you chose to become.

Both games respect the player by refusing to help them. Both games change the player,
not the avatar. Both games create community through oblique connection. Both games earn
their meaning by making the player build it themselves.

---

## The Condition (Not a Backstory)

The player has no defined history. They have a CONDITION:

- You arrived here. One-way ticket. You don't say why.
- You were tired. You fell asleep on the depot bench.
- The bus left without you.
- You're here now. The town feels... like something. Not home. Not foreign. Something.

That's all. The player fills the rest with their own life. Their own unfinished thing.
Their own town they left or didn't leave. Their own door they didn't open.

---

## The Hook: What Am I Not Seeing?

The hook isn't a mystery to solve. It's a feeling to sit with.

By minute 30, the player should feel:
- The flickers at the edge of vision (something is there that I can't quite see)
- The Other walking through walls (someone else sees a different world)
- Small gaps they can't name (a conversation that feels like it's missing a line)

The pull isn't "what happened here" — it's "what's happening HERE, RIGHT NOW,
that I'm not perceiving?" That hook never resolves. It pulls through the whole game.

### The Water Tower (Spatial Pull)

Visible from almost every outdoor scene. On the Hill. You see it in the background.
A landmark you're drawn toward. It takes the whole game to reach.

When you get there: you see the entire town from above. Every location. Every path.
Including the ones you never entered. The doors that don't exist for you.
The town is complete. Your experience of it was a subset. You see the shape of
your own blindness by seeing what you missed from above.

### The Bus (Temporal Pressure)

The bus runs for the first 3 hours of gameplay. Every 20 minutes, a distant engine
sound — arriving, departing. The player stops noticing by hour two.

After 3 hours: a notice on the depot. Closed for renovation. The exit seals.
Not dramatically. Bureaucratically.

For the player who goes back early, walks into the bus: "You left." Fade. End.
Almost no one does this. Because by then they're hooked. They have questions.
They have a framework. They have reasons to stay.

---

## The Framework System

### What the Player Does (Internal Names)

| Behavior | Internal Name | Philosophy (never shown to player) |
|----------|--------------|-------------------------------------|
| Watching. Waiting. Not acting. Sitting. | **Still** | Vairagya / Detachment |
| Examining. Reading. Analyzing. Pattern-seeking. | **Mapping** | Nihilism / Deconstruction |
| Following impulse. Entering without purpose. Playing. | **Wandering** | Absurdism / Defiant Joy |
| Engaging people. Staying in discomfort. Witnessing. | **Holding** | Existentialism / Radical Presence |

### How It Works

- Four axes, each 0.0 to 1.0, starting at 0.25
- Every interaction shifts one or more axes by tiny amounts (0.01-0.03)
- The dominant axis determines what you can perceive
- The world updates with slight lag (you're changing faster than what you see)
- No single interaction determines anything — it's the accumulation

### The Realism of Invisible Foreclosure

People don't appear and disappear. They don't teleport. There's no magic.
There's no sci-fi. The town is real. The people are real. They're always there.

**You just don't notice them.**

This is how attention actually works. In real life:
- You've walked past the same person 200 times without seeing their face
- There's a shop on your commute you've never registered exists
- Someone has been trying to talk to you for weeks and you haven't noticed
  because you're focused on something else

Psychologists call it inattentional blindness. You only see what your current
frame of reference makes relevant. The game simulates this honestly:

**Ruth:** She's at the canal. Every day. But if you're rushing, analyzing systems,
looking at buildings instead of people — she's just "a woman on a bench."
Background. Your eye skips over her the way it skips over everything that isn't
relevant to what you're currently doing. She's not invisible — she's irrelevant
to you. Which is worse.

**Daniel:** His door is a door. Always has been. But if you're not looking for
patterns, not reading notices, not mapping systems — why would you knock on a
random flat? You wouldn't. You'd walk past a thousand times. Because nothing
about it says "enter here" unless your mind is tuned to that frequency.

**The Busker:** They play at odd hours in odd spots. If you're purposeful —
going A to B with intent — you won't be in the right place at the right time.
You'll hear a snatch of music and think: radio? neighbor? Gone. The Busker
doesn't perform for people going somewhere. They play for people going nowhere.

**The game never says "you can't see this."** It says: "this isn't here."
And it's telling the truth — from your character's perspective. It's not here
for you. Not because of magic. Because you're not looking. Because your
attention is elsewhere. Because you're a certain kind of person and certain
kinds of people don't notice certain things.

This isn't science fiction. This is the most realistic thing a game has ever done.
More realistic than games where you can see everything — because in reality,
you never can.

**The implementation:** Characters are ALWAYS physically present and visible.
Ruth is on the bench. Daniel's door exists. The Busker is on the corner.
You can see them. You can walk near them. But if your framework doesn't
align — they're unavailable. They don't look up. They're on their phone.
They're turned away. They're clearly not open to a stranger right now.

You can't REACH them. Not because they disappeared — because connection
requires two people to be in the right state. And you're not. Not yet.
Maybe not ever. Depending on who you become.

- **Below threshold:** Character present, non-interactable. Press E → 
  "She doesn't look up." / "The door doesn't open." / They ignore you.
- **At threshold:** Character available. They look up. They shift. 
  Connection is possible. Press E → real conversation.
- **Glance (flicker equivalent):** Sometimes, when you're nearby but not
  ready, they glance at you. Half a second of eye contact. Then back to
  whatever they were doing. A moment that says: maybe, if you were
  different, we'd talk.

**What the Shadow says about it:**
"She was there. Every day. You walked right past. Not because you couldn't
see her. Because you weren't looking. You were looking at something else.
You're always looking at something else."

That's not supernatural. That's a fact. And it hurts because it's true.

### What Each Framework Reveals and Hides

**Still (Detachment):**
- SEES: Beauty in impermanence. Peace in Mara. The canal as meditation. Quiet.
- HIDDEN: Leon (urgency). Ruth (emotional weight). Suffering you'd need to engage with.

**Mapping (Deconstruction):**
- SEES: Systems. Daniel's maps. The council notices. The bus routes. How decline works.
- HIDDEN: The Busker (joy without reason). Helen (meaning through time, not analysis).

**Wandering (Defiant Joy):**
- SEES: The Busker. Color. Music scraps. Doors that open for no reason. Surprise.
- HIDDEN: Helen (patience, long view). The weight of things. Anything that requires staying.

**Holding (Presence):**
- SEES: Ruth. The bench man. People carrying choices. Weight. Responsibility.
- HIDDEN: Daniel (systems view). The structural forces that constrain individual choice.

---

## Characters

### MARA (Universal — All Frameworks)

Who: Mid-40s. Runs the café. Has been here forever. Knows everyone. No one knows her.

Role: The town's continuity. The constant. She represents what staying looks like
from the inside — which looks different depending on your lens.

The hook: She says things that suggest she recognizes you. Or maybe she's just
like that with everyone. You'll never know.

Framework variations: Same woman, four different readings. Is she at peace or
trapped? Content or paralyzed? Free or resigned? Your framework decides.

### RUTH (Holding-only)

Who: 70s. Sits by the canal. Her son left. She chose to let him go. Every day
she chooses again not to call him back.

Role: The cost of loving correctly. She represents what happens when you
respect someone's autonomy fully — the loneliness it buys.

Why Holding-only: You have to be attuned to the weight of choice and
presence to perceive her. She's not dramatic. She's just a woman on a bench.
Only someone who understands that sitting with pain is an act of courage
will see her there.

### DANIEL (Mapping-only)

Who: 40s. Former systems analyst. Lives in a flat covered in maps of the
town's decline. Every data point accurate. Every prediction correct.

Role: The endpoint of total comprehension without power. He knows everything.
It saves no one. Including himself.

Why Mapping-only: Only a player deconstructing systems can perceive someone
who's mapped them to obsession. His flat looks like "just a flat" to anyone
not looking for patterns.

### THE BUSKER (Wandering-only)

Who: Ageless. Plays an instrument at different spots. Never the same spot twice.
Never when asked. Sometimes to empty streets.

Role: Pure creation without audience. Joy without justification. The absurd
hero who doesn't explain themselves.

Why Wandering-only: Only a player who embraces meaning-through-action can
perceive someone whose existence IS that. Everyone else hears a snatch of
music, maybe, from somewhere. Gone before they turn.

### HELEN (Still or Holding — hidden from Mapping and Wandering)

Who: 70s. Former doctor. Retired. Garden on the Hill. Speaks deliberately.

Role: The long view. Fifty years of choosing. The accumulation of a life.
The question: does the shape of your life feel like yours?

Why hidden from Mapping/Wandering: A mapper deconstructs legacy — Helen is
invisible because she represents accumulated meaning over time. A wanderer
lives in the present — Helen's retrospective gaze doesn't register.

### ELI (Pre-Framework — Disappears Once Any Axis Hits 0.35)

Who: 14-15. Sitting on the depot bench when you arrive. Not waiting for
anything. Not going anywhere. Just there.

Role: The state before choosing. Before frameworks. Before becoming.
The last moment of openness before the game reads you and you start
seeing through a lens.

What they say: "You don't have to be anything." Simple. Forgettable in
the moment. The only true thing anyone says. Gone once you've become
something.

Mechanic: Once ANY framework axis crosses 0.35, Eli is removed from the game.
Not hidden behind a threshold. Deleted. They exist only in the space before
commitment.

### THE SHADOW (Endgame)

Who: You. The parts you didn't live. The frameworks you rejected. The
characters you never met. The doors you didn't enter.

Not a monster. Not a boss. A person who looks like you and speaks with
your precision — but from the other side of your choices.

What it knows: Everything you walked past. Everything that flickered.
Every hesitation the game tracked. It uses these against you. Not cruelly.
Just honestly.

---

## The Town

### Structure

```
                    [Water Tower] ← endgame destination
                         |
                    [The Hill Path]
                         |
[Bus Depot] ←→ [High Street] ←→ [The Square] ←→ [Canal Path]
                     ↕                ↕
                [Mara's Café]     [Library]
                                     
                [Old Port] ← accessible from Canal Path
```

### Design Principles

- The town is REAL. Not metaphor. Not allegory. A real declining town.
- Beautiful. Golden hour light. Canal reflections. The sunset makes you ache.
- The systems are failing but the beauty persists. That contrast is everything.
- The town doesn't try to keep you. YOU keep yourself. Your framework generates reasons.
- Things change between visits (a cup moved, a person gone) — the town has its own life.

### Each Scene Contains

- Shared content (visible to all)
- Framework-specific content (appears/disappears based on dominant framework)
- Time-sensitive content (changes with game clock)
- Visit-sensitive content (changes or disappears after first visit)
- One "missed moment" — something available only the first time you enter, gone forever after

---

## Narrative Arc

### Act 1: Arrival (0-60 min)

- Wake on the depot bench (Eli conversation if you sit)
- Step outside. The town opens.
- First interactions. Framework begins seeding.
- The bus sound every 20 minutes (barely noticed).
- Tone: curiosity, beauty, gentleness. "This is a nice quiet game."

The player thinks they're exploring a town. They don't know they're being read.

### Act 2: Living (60-180 min)

- Framework crystallizes. World reorganizes around your lens.
- Characters become accessible. Storylines develop.
- The flicker begins. The Other appears.
- The bus still comes (background engine sound). Depot still open.
- Dilemmas emerge — small, no-right-answer ethical moments.
- The Water Tower pulls you from the background.
- Tone: deepening, aching, beautiful. Something is off. Not wrong. Off.

The player knows they're missing things. They can't name what.

### Act 3: The Remainder (180-240+ min)

- Depot closes (notice appears after 3 hours).
- The Shadow begins appearing at the periphery.
- The Hill path opens. The climb to the Water Tower.
- The Shadow encounter (canal bench, café, wherever you end up).
- The final walk. The ending.
- Tone: still, quiet, enormous. The sunset. The canal. The sky.

---

## The Shadow Encounter

### How It Happens

Not triggered by reaching a place. It emerges. The Shadow has been in the background
since mid-Act 2 — someone at the edge of the frame. Getting closer. More present.

Eventually: you're both in the same space. A bench. A doorway. A table.
Stillness happens. And they speak.

### What They Say (Generated From Your Playthrough)

The Shadow speaks from the frameworks you rejected, about the characters you
never met, referencing the moments you hesitated:

- If you never found Ruth: "There was a woman by the canal. She sat alone every day.
  You walked that path. You never saw her."
- If you never found Daniel: "Someone mapped the whole thing. Every system.
  Every failure. You never asked why."
- If you never found the Busker: "There was music. Right there. On that corner.
  Every time you passed. You never heard it."
- About your hesitations: "You stopped. Right there. For half a second. Then kept
  walking. Three times you did that. What was there?"
- About the bus: "It came. Six times. You heard it. You know you heard it."
- About Eli: "Someone told you. At the very beginning. Before you were anything.
  Do you remember what they said?"

### Player Response (Physical, Not Verbal)

- **Stay.** Don't move. Listen. Acknowledgment.
- **Move closer.** Integration. "I see you."
- **Walk away.** Rejection. Continue as you are.
- **Wait.** Neither toward nor away. Ambiguity. Honesty.

No timer. No prompt. The player acts or doesn't by being — like the whole game.

---

## Endings

### "You Left" (Bus Ending — Act 1 or early Act 2)

Walk into the bus at the depot before it closes. Fade. "You left." Hold.
No score. No completion. No judgment. Just: you left.

The player feels: unsettled. Did I miss something? Was that right?
The same way OTHER players feel: should I have left?

No one feels right. Everyone feels the remainder.

### After the Shadow — Acknowledge (Stay/Move Closer)

Walk through the town one last time. One new thing visible: a small detail
that wasn't there before. A plaque. A name. A light in a window. Not enough
to change anything. Just enough to crack the frame.

You sit. Somewhere. The game holds. Evening becomes night. Quiet.
You stopped. That's the ending. You stopped running/seeking/becoming.

### After the Shadow — Reject (Walk Away)

The town is exactly as it was. Beautiful. Complete. Yours. Sealed.
You keep walking. The game ends in motion. Still moving. Still outrunning.
Now the player KNOWS that's what they're doing. And knowing is its own wound.

### After the Shadow — Wait (Ambiguity)

The flickering everywhere. Edges of the world shimmering with what-could-be.
Nothing resolves. You see both the framework and the remainder simultaneously.
Most honest. Most uncomfortable. No rest.

---

## Dilemmas (Ethical Moments — No Right Answer)

### The Letter (High Street)

Found on the ground. Opened. Not yours. Personal. Someone's medical results.
- Read it (knowledge, violation)
- Leave it (righteousness, inaction)  
- Carry it (honesty, uselessness)

### Mara's Question (Café — After Multiple Visits)

"I'm thinking of closing Wednesdays. What do you think?"
- "Do what's best for you" (detachment — but you're giving up on the place)
- "People need this open" (responsibility — but you're volunteering her labor)
- "Does it matter what I think?" (honest — but cold)

No answer changes what happens. Wednesday comes regardless.

### The Bench Man (Square — Duration-Triggered)

Sit next to him for 60 seconds. He says: "I lost my job. Three months ago.
I haven't told my wife." Then nothing. No prompt. No options. You can only
stay or leave. The weight of witness without agency.

### Daniel's Offer (Mapping-only)

"I could send this to the council. Once everyone knows — they fix it or they don't.
Is it better to know?"
- "People deserve truth"
- "Knowing won't help"
- "Not your decision"

He does nothing regardless. He needed a witness, not an advisor.

### Ruth's Silence (Holding-only)

"Should I tell him I want him here? Or does that make it about me?"
- "Tell him" (guilt as weapon)
- "Don't" (suffering in silence)
- "He probably knows" (comfortable lie)

The impossibility of honest love without manipulation.

---

## Tone & Writing Rules

- Short sentences. Fragments. Let silence work.
- Never explain. Show the image. Trust the reader.
- Specific over abstract. Not "she felt loss" — "the cup was still warm."
- No philosophy jargon in-game. No character says "existentialism." They live it.
- Repeated motifs: water (reflection), light (perception), doors (access), routes (foreclosure)
- The town is beautiful. Always. The beauty doesn't save anyone. That's the point.

---

## The Souls Connection

Like Souls games:
- The world doesn't care about you. Indifference as respect.
- Progress is internal, not external. YOU change. Not the town.
- Oblique multiplayer. The Other. "Someone was here. They can't help you. But they existed."
- Death → failure reframed. Here: missing something isn't failure. It's the cost of seeing.
- Earned meaning. Fragmented. Player-assembled. Valued because built, not given.
- No hand-holding. No waypoints. No "you should go here." You go where you go.

Unlike Souls games:
- No difficulty as mechanic. This isn't about overcoming.
- No retry. Choices are irreversible. That's the point.
- No power fantasy. You don't get stronger. You get more formed. And more blind.
- The "boss" (Shadow) can't be beaten. Only acknowledged.

---

## What Makes This Game Rare

No game has done invisible foreclosure at this scale. The mechanic where:
- Content exists that you cannot see
- You don't know it exists
- Your own engagement patterns determine what's hidden
- Another player, in the same world, sees what you can't
- Neither of you knows the other's experience is equally valid

That's not a game mechanic. That's a philosophical argument made playable.
That's consciousness itself rendered as a system you can walk through.

That's The Remainder.
