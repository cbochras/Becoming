# The Remainder — Art Bible

---

## 1. Visual Identity

### One-Line Description
A painterly, warm, melancholic town rendered as theatrical stage sets — each scene
a composed frame the player walks ACROSS, not INTO. Like watching a play about a
place that used to matter more.

### Core References
- **NORCO** — Painted backgrounds, side-view composition, layered depth, rich color
- **Kentucky Route Zero** — Theatrical flat staging, silhouette characters, negative space
- **Disco Elysium** — Oil-paint texture, lived-in detail, isometric-but-flat feel
- **Edward Hopper paintings** — Isolation, golden light, figures in architectural space
- **Inside (Playdead)** — Silhouette characters against detailed environments, scale

### What This IS
- 2D side-view compositions (like a theatre stage seen from the audience)
- Characters walk LEFT to RIGHT across composed frames
- Painterly but grounded — warm, textured, brushstroke-visible
- Each scene is wide, showing the full width of the space
- Clear floor/ground strip for character movement
- Layered: background (sky/far wall) → midground (architecture) → foreground (objects player interacts with)

### What This Is NOT
- Not 3D perspective shots looking "into" a room
- Not photorealistic
- Not pixel art or anime
- Not fantasy/sci-fi
- Not first-person or over-the-shoulder

---

## 2. Composition Rules (UPDATED — Most Important Section)

### The Stage Metaphor

Every scene is a **theatre stage viewed from the audience.** The camera never moves.
The player is an actor walking across the stage. The background is the set.

```
┌─────────────────────────────────────────────┐
│          SKY / CEILING (far background)      │
│─────────────────────────────────────────────│
│     BACK WALL / BUILDINGS (midground)        │
│         windows, doors, signs, detail        │
│─────────────────────────────────────────────│
│  ═══════ FLOOR STRIP (player walks here) ═══│
│─────────────────────────────────────────────│
│      FOREGROUND (optional - bench edge,      │
│        railing, close objects)               │
└─────────────────────────────────────────────┘
```

### Key Composition Rules

1. **Flat, not deep.** Minimal perspective. The back wall is parallel to the camera.
   Objects don't shrink dramatically with distance. Think paper theatre / diorama.

2. **The floor strip is sacred.** The bottom 20-30% of the frame is where the player
   walks. It must be clear, uncluttered, and readable as "ground."

3. **Entrances/exits at LEFT and RIGHT edges.** The player enters from one side,
   exits the other. Doorways, paths, and transitions are at the horizontal edges.

4. **Vertical = visual interest. Horizontal = movement.** Pillars, windows, doors
   are vertical landmarks. The floor is the horizontal movement plane.

5. **Characters are SMALL.** 10-15% of frame height. The environment dominates.
   The player is a figure in a space, not a character in a close-up.

6. **Light comes from one direction** (usually the right or above-right). This
   creates consistent shadow direction across all scenes.

### SD Prompt Formula for Stage-View Scenes

Always include these terms in every scene prompt:
```
wide side view, seen from the side like a theatre stage, flat composition
showing full width of the room, 2D side-scrolling game environment background,
game background art, wide aspect ratio, no people
```

---

## 3. Color Palette

```
AMBER GOLD      #D4A857  — Evening light, warmth, the "ache" color
SLATE BLUE      #5B7A8A  — Morning, distance, the canal, melancholy
CANAL GREEN     #6B8F71  — Water, growth, the organic beneath the industrial
WARM RUST       #A0522D  — Brick, metal, age, the port's memory
SOFT CREAM      #F5E6D3  — Sky, paper, breath, the library interior
DEEP CHARCOAL   #2C3E42  — Shadows, weight, night, the Shadow character
```

### Time-of-Day Shifts

| Time | Dominant | Cast | Shadows |
|------|----------|------|---------|
| Morning (grey) | Slate Blue + Soft Cream | Cool, diffuse | Minimal, soft |
| Afternoon (white) | Cream + washed Gold | Flat, bright | Short, defined |
| Evening (gold) | Amber Gold + Warm Rust | Warm, directional | Long, dramatic |
| Night (blue-black) | Deep Charcoal + Slate Blue | Cool pools of artificial light | Dense, enveloping |

### Framework Color Tinting (Subtle — Never Obvious)

The world shifts color temperature slightly based on dominant framework. The player should NEVER consciously notice this. It's felt, not seen.

| Framework | Shift | Effect |
|-----------|-------|--------|
| Vairagya (Detachment) | +5% desaturation, +cool shift | World feels slightly further away, like looking through glass |
| Nihilism (Deconstruction) | +contrast, slight blue-green tint | Mechanical. Clinical. Edges sharper. |
| Absurdism (Defiant Joy) | +warmth, +saturation 5% | World is slightly more alive. Colors breathe. |
| Existentialism (Presence) | No shift — neutral. Raw. | The world as-is. Unfiltered. This IS the weight. |

---

## 3. Composition Rules

### Camera / Frame

- **Fixed perspective per scene.** No camera movement. No pan. No zoom. The frame IS the experience.
- **Aspect ratio:** 16:9 (standard widescreen). Scenes are composed for this frame.
- **Player character scale:** Small. 10-15% of frame height. The town is bigger than you.
- **Horizon line:** Varies per scene but generally mid-to-low. Sky is present. The world extends.

### Composition Principles

1. **Every frame is a painting.** Before building a scene, ask: would I hang this on a wall? If no, redesign.
2. **Leading lines toward interactables.** The architecture, paths, shadows guide the eye toward what can be engaged with — subtly, not with arrows.
3. **Negative space is story.** Empty areas aren't lazy — they're the quiet. The canal's surface. The sky above the flats. The gap where a shop used to be.
4. **Depth through layers.** Every scene has: far background (sky, distant buildings) → midground (main scene) → foreground (close objects, sometimes partial, framing).
5. **Human scale.** Every scene should contain evidence of human life at human scale: a hanging flower basket, a bicycle, a curtain, a discarded cup.

### Flicker Composition Rule

Flicker content (near-threshold objects/characters) should ALWAYS appear in **peripheral zones** of the frame — the edges, the background, the places your eye doesn't land first. Never center frame. Never foreground.

```
┌─────────────────────────────────┐
│ FLICKER   │             │FLICKER│
│ ZONE      │   PRIMARY   │ ZONE  │
│           │   FOCUS     │       │
│           │   AREA      │       │
│ FLICKER   │             │FLICKER│
│ ZONE      │             │ ZONE  │
└─────────────────────────────────┘
```

---

## 4. Scene Categories & Treatment

### Exteriors — Streets & Paths

- Wide compositions. Horizontal emphasis.
- Buildings on both sides creating corridor/channel.
- Sky visible. Weather visible.
- Ground detail: puddles, cracks, weeds in pavement, shadows of unseen things.
- Signs of life: lit windows, laundry, parked bikes, a cat.

### Exteriors — Open Spaces (Shore, Square, Canal)

- Breathing room. More sky, more horizon.
- Fewer objects. More atmosphere.
- These are contemplation spaces — scenes where the player might just... stop.
- Water reflections (canal, estuary) as a visual motif for the "doubled world" theme.

### Interiors — Intimate (Mara's Café, Daniel's Flat, Helen's House)

- Warmer. Closer. More saturated.
- Detail-rich. Objects tell stories (books, photos, unwashed mugs, post-it notes).
- Lighting: practical sources (lamps, windows). Warm pools.
- Player character is larger relative to frame (closer camera = more intimate).

### Interiors — Institutional (Library, Hospital Waiting Room, Bus Depot)

- Cooler. Wider. More geometric.
- Fluorescent light cast (slightly green-white).
- Signs of system: timetables, notices, numbered chairs, faded posters.
- Human warmth exists but is fighting the architecture.

---

## 5. Character Design

### General Principles

- Characters are painterly, not cartoonish. Proportional. Grounded.
- Limited animation — emphasis on **pose** and **silhouette** over fluid motion.
- Each character has a **signature shape** and **signature color** for instant recognition at small scale.
- Faces are suggested, not detailed. Eyes are important. Expression lives in posture more than facial features.

### Character Specs — UPDATED

Characters are **simple painted silhouettes with minimal detail.** Not fully
rendered portraits — recognizable shapes with just enough information to read
as human at 10-15% of frame height.

Think: Kentucky Route Zero, Inside (Playdead), NORCO's smaller characters.

At game resolution, detail is wasted. What matters:
- **Shape** (posture, proportions, stance)
- **One signature color** (Mara = warm ochre apron, Eli = grey-neutral)
- **Silhouette readability** (can you tell who it is from shape alone?)

| Character | Shape | Color | Notes |
|-----------|-------|-------|-------|
| **Player** | Neutral standing/walking figure | Muted warm tan | Small. Unassuming. Not heroic. |
| **Eli** | Seated, hunched slightly forward | Grey-neutral, soft | Smaller than player. Young proportions. |
| **Mara** | Solid, grounded, wide stance | Warm ochre/cream (apron) | Behind counter = half-visible |
| **Ruth** | Seated. Always seated. | Muted green-blue | Stillness as identity |
| **Daniel** | Angular, hunched over something | Dark blue | Surrounded by paper/maps |
| **The Busker** | Irregular, instrument as body extension | Patchwork warm | Never straight |
| **The Shadow** | Mirror of player | Complementary to player color | Familiar but wrong |

### How to Create Characters (Pipeline)

**Option A — Draw in Krita (recommended for this style):**
1. New file, transparent background, 200x400px
2. Block in the silhouette with a dark base color
3. Add one or two color accents (apron, bag, instrument)
4. Add minimal highlights (shoulder, top of head)
5. Export as PNG with transparency
6. Scale down in Godot to 10-15% of frame height

**Option B — Generate with SD then simplify:**
1. Generate a character with SD (transparent background)
2. Open in Krita, paint over to simplify into silhouette
3. Remove detail until it reads at small scale
| **Mara** | Rectangle (solid, grounded, café counter) | Warm ochre, cream apron | Wide stance, arms often at sides or wiping something |
| **Leon** | Triangle (kinetic, leaning forward, ascending) | Faded blue-green, climbing chalk dust | Always slightly off-balance, head forward |
| **Helen** | Circle (contained, complete, garden) | Deep purple-grey, white collar | Upright, still, hands clasped or holding something small |
| **The Busker** | Irregular (unpredictable, instrument as extension) | Patchwork warm tones, instrument gleam | Never standing straight, instrument is part of body shape |
| **Daniel** | Sharp lines (angular, maps, systems) | Dark blue, paper-white highlights | Hunched, surrounded by vertical lines (shelves, maps) |
| **Ruth** | Horizontal line (bench, canal, horizon) | Muted green-blue, canal reflection colors | Seated. Always seated. Stillness as identity. |
| **The Shadow** | Mirror of player (whatever you've become) | Complementary to dominant framework color | Recognizable but wrong — familiar posture, inverted palette |

### The Player Character

- **Gender-neutral, age-ambiguous.** Not blank-slate avatar — a *person.* But one the player projects onto.
- **Muted clothing.** Doesn't stand out. Part of the town.
- **Small in frame.** The town is the character. You are a figure within it.
- **Walk cycle:** 4-6 frames. Slight. Not bouncy. Not heavy. Just: moving.
- **Idle:** Subtle shift of weight. Looking around slowly. Breathing.

---

## 6. Scene List (Prototype — First 30 Minutes)

These are the scenes needed for the vertical slice:

### Scene 01: The Arrival — Bus Depot
- Wide interior. Too big for the two buses present.
- Art deco tilework. Brass fixtures gone green.
- Morning light through high windows. Dust motes.
- Two bays roped off. Pigeons in the rafters.
- **Interactive:** Timetable (outdated). Bench (sit or don't). Exit to street.

### Scene 02: High Street (South)
- Street view. Shops on both sides.
- Mix of open/closed. One being renovated (scaffolding). One empty (TO LET sign fading).
- Mara's café visible: fogged window, warm light inside.
- A bench. Someone sitting (NPC or player interaction seed).
- **Interactive:** Café door. Shop window (look). Notice board. Bench.

### Scene 03: The Square
- Open space. War memorial center. Benches. Trees.
- The library on one side. Other buildings on three sides.
- A bird on the ground. A lost object (scarf? book?).
- Evening version: golden light. Long memorial shadow.
- **Interactive:** Memorial (read). Library entrance. Object on ground. Bench. Bird proximity.

### Scene 04: The Canal Path
- Horizontal composition. Canal on one side, buildings on the other.
- Slow green water reflecting the sky.
- A bridge in the distance.
- Ruth's bench (existentialism-only: she's there. Others: empty bench by water).
- **Interactive:** Bench (sit). Water (look). Walk east toward port or west toward square.

### Scene 05: Mara's Café (Interior)
- Formica tables. Tin ceiling. Chipped mugs.
- Mara behind the counter. Radio playing something indistinct.
- Window shows the street (High Street exterior visible, tiny).
- Two other tables — sometimes occupied, sometimes not.
- **Interactive:** Counter (talk to Mara). Table (sit). Window (look). Menu (read). Radio (listen).

### Scene 06: The Library (Interior)
- Tall shelves. Institutional but warm.
- Fewer people than the space was built for.
- A section roped off (reduced hours, reduced access).
- Notice board inside (different from the one outside).
- Light from tall windows. The smell you can't render but must imply.
- **Interactive:** Shelves (browse). Notice board. Reading table (sit). Exit.

---

## 7. Stable Diffusion Prompt Templates

### Base Style Prompt (Append to ALL Scene Prompts)

```
POSITIVE (append to every prompt):
painterly digital art, warm atmospheric lighting, muted color palette, 
amber gold and slate blue tones, soft edges, visible brushstrokes, 
melancholic beauty, edward hopper mood, small town atmosphere, 
fixed perspective composition, highly detailed background art, 
game environment concept art, no people, empty scene, quiet, still

NEGATIVE (use for every prompt):
photorealistic, 3d render, anime, cartoon, pixel art, fantasy, 
sci-fi, futuristic, medieval, dark souls, post-apocalyptic, 
neon, vibrant saturated colors, text, watermark, signature, 
blurry, low quality, distorted architecture, fisheye lens,
people, figures, characters, faces
```

### Scene-Specific Prompts

**Scene 01 — Bus Depot:**
```
wide side view interior of a 1930s bus depot waiting hall, seen from the side
like a theatre stage, flat composition showing full width of the room, high
vaulted iron ceiling with steel beam trusses, arched windows along the back
wall letting in golden morning light, wooden waiting bench on the left side,
iron support columns with peeling green paint, concrete floor with painted
bay markings, one exit doorway on the right side with bright outside light,
pigeons on beams above, timetable board on wall, empty and quiet, painterly
digital art, visible brushstrokes, warm muted palette of amber cream and rust,
2D side-scrolling game environment background, edward hopper style, no people,
wide aspect ratio
```

**Scene 02 — High Street:**
```
wide side view of a small town high street, seen from the side like a theatre
stage, flat composition, mixed architecture shopfronts spanning full width,
(victorian shopfronts next to 1960s facades), one shop with scaffolding, 
one empty unit with faded TO LET sign, warm light from a cafe window 
(fogged glass, amber interior glow), overcast afternoon light, 
wet pavement reflecting shop lights, a wooden bench on the sidewalk,
notice board on a wall, quiet street with no people, lived-in detail
```

**Scene 03 — The Square:**
```
town square with stone war memorial in center, surrounded by benches 
and sparse trees, library building visible (neoclassical facade, 
wide steps), golden evening light casting long shadows from the memorial,
birds on the ground near crumbs, a lost scarf draped on a bench,
atmospheric perspective showing buildings receding on three sides,
peaceful melancholic open space, autumn feeling
```

**Scene 04 — Canal Path:**
```
narrow canal path at dusk, still green water reflecting amber sky,
industrial brick buildings on opposite bank (some converted to galleries,
some derelict), a stone bridge in the middle distance, wrought iron railing 
along the path, a single wooden bench facing the water, weeds growing 
through cobblestones, one warm window light reflected in canal,
horizontal composition emphasizing stillness and reflection
```

**Scene 05 — Café Interior:**
```
small town cafe interior, formica tables with chrome edges, 
pressed tin ceiling painted cream, chipped ceramic mugs, 
counter with glass cake display (half empty), warm amber lighting 
from pendant lamps, foggy window showing street outside (tiny, distant),
a radio on a shelf, worn linoleum floor, cozy and slightly faded,
intimate composition looking across the room toward the counter
```

**Scene 06 — Library Interior:**
```
public library interior, tall wooden bookshelves, high windows with 
pale afternoon light streaming in, institutional but warm, reading 
tables with green banker's lamps, a section with a rope barrier 
and "closed" sign, notice board covered in layered papers, 
fewer books than the shelves can hold, quiet empty institutional space,
vertical composition emphasizing the height of shelves and windows
```

### ControlNet Usage Notes

For best results with the Blender→SD pipeline:

1. **Render Blender blockout** with basic materials (grey for stone, brown for wood, blue for sky)
2. **Generate depth map** from Blender render (Z-pass)
3. **Feed both** into ControlNet (depth + canny edge):
   - ControlNet Depth: weight 0.6-0.8 (controls spatial layout)
   - ControlNet Canny: weight 0.3-0.5 (controls architectural lines)
4. **Generate** with scene-specific prompt + base style prompt
5. **Iterate** at lower ControlNet weights if too rigid, higher if composition drifts

### Recommended Models (All Free, CivitAI)

| Model | Use Case |
|-------|----------|
| **Juggernaut XL v9** | Best general painterly/realistic hybrid |
| **DreamShaper XL** | More illustrated, slightly stylized |
| **RealVisXL** | When you need architectural accuracy |
| **SDXL base + refiner** | Fallback, always works |

### Recommended LoRAs (Optional, Free)

- **Painted World LoRA** — adds visible brushstroke texture
- **Atmospheric Lighting LoRA** — improves golden hour / moody lighting
- **Architectural Detail LoRA** — better building consistency

---

## 8. Production Workflow Per Scene

```
STEP 1: DESIGN (30 min)
├── Sketch rough composition on paper/Krita (5 min)
├── Define: what's interactive, what's framework-conditional
├── Define: time-of-day variants needed
└── Define: where flicker zones are

STEP 2: BLOCKOUT (1 hr)
├── Build simple geometry in Blender
├── Set camera to fixed frame (match aspect ratio)
├── Basic materials for color blocking
├── Render: color pass, depth pass, normal pass
└── Render all time-of-day variants (change HDRI/sun position)

STEP 3: GENERATION (1-2 hrs)
├── Load renders into ComfyUI
├── ControlNet: depth + canny from Blender renders
├── Generate 8-12 variants per scene
├── Select best 2-3 as base
└── Generate time-of-day variants from same ControlNet input

STEP 4: PAINTOVER (2-4 hrs)
├── Import best generation into Krita
├── Paint over: fix inconsistencies, add detail
├── Separate layers: background / midground / foreground
├── Add interactive elements as distinct layers
├── Match to color palette guide
└── Create framework-conditional element layers (hidden by default)

STEP 5: EXPORT (30 min)
├── Export layers as separate PNGs
├── Name convention: scene_XX_layer_name_framework.png
├── Import into Godot scene
└── Set up parallax + visibility scripting

TOTAL PER SCENE: 5-8 hours (with practice, drops to 3-5)
PROTOTYPE (6 scenes × 2 time variants): ~60-90 hours of art production
```

---

## 9. Technical Art Specs

### Resolution
- **Working resolution:** 3840 × 2160 (4K) — paint at this size
- **Export for game:** 1920 × 1080 — scale down for performance
- **Keep 4K originals** — for future upscaling if needed

### File Format
- **Working files:** .kra (Krita native) — preserves layers
- **Game export:** .png (lossless, transparency support for layers)
- **Blender files:** .blend (keep all blockouts in one project file)

### Layer Naming Convention
```
scene_01_busdepot/
├── bg_far.png          (sky, distant buildings through windows)
├── bg_main.png         (main architecture, walls, ceiling)
├── mg_objects.png      (benches, buses, pillars — non-interactive)
├── mg_interactive_01.png  (timetable board)
├── mg_interactive_02.png  (bench)
├── fg_frame.png        (foreground framing elements — pillar edge, etc.)
├── fx_dust_motes.png   (particle overlay, animated in engine)
├── light_morning.png   (light overlay — multiply blend mode)
├── light_evening.png   (alt lighting — swap in engine)
└── flicker_nihilism_door.png  (framework-conditional, hidden by default)
```

### Animation (Minimal)
- **Characters:** Sprite sheets, 4-8 frames per action (idle, walk, sit, gesture)
- **Environment:** Parallax scrolling on layers (subtle, 1-3% movement differential)
- **Water:** Slow UV scroll on reflection overlay layer
- **Dust/particles:** Simple particle system in Godot (not painted)
- **Flicker:** Opacity tween (0→30%→0 over 0.3s) on conditional layer

---

## 10. Mood Boards by Location (Description for Generation Reference)

### The Shore (Not in Prototype — But Sets the Emotional Ceiling)

The estuary at low tide. Mud flats stretch to the horizon. The sky is enormous — 70% of the frame. The town is behind you (suggested by a distant roofline at the frame's edge). One wooden groyne extends into the mud. A single channel of water reflects the sky like a mirror laid on the earth.

This is where the game ends. This is the widest frame. The most sky. The most silence. The player should feel: *I am very small and the world is very large and that is both terrifying and beautiful.*

### Daniel's Flat (Nihilism-Only Interior)

Walls covered in maps, printouts, string connecting pins. Not "conspiracy board crazy" — methodical. Organized. Labeled. A desk with three monitors showing spreadsheets. Coffee cups in various stages of age. Curtains closed. One desk lamp. The room is a mind turned inside out. Every surface is information. None of it helps.

### The Water Tower (Hill — Late Game Location)

Disused. Cylindrical brick. Door rusted but open. Inside: empty. Echoey. Graffiti from fifteen years ago. From the top (if you climb): you see the entire town. Every location you've been. Every place you couldn't enter. The view is the game's map — but you can't interact with it. You can only look. And know that what you see is not all there is.

---

## 11. Hardware-Specific Notes

### M4 Pro 48GB (Mac)
- Run ComfyUI natively — M4 Pro handles SDXL well via MPS backend
- Krita runs great on macOS
- Blender is excellent on Apple Silicon
- This is your primary art machine

### HP EliteBook (Intel + NPU)
- The Intel NPU can run smaller SD models via OpenVINO
- Better used for Godot development (lighter, portable)
- Can run ComfyUI with CPU/iGPU but slower — use Mac for generation

### Recommended Split
- **Mac:** Art production (SD generation, Krita painting, Blender blockout)
- **HP:** Godot development, writing, testing, playtesting on weaker hardware (good perf target)

---

## 12. Consistency Checklist (Use Before Finalizing Any Scene)

- [ ] Horizon line matches adjacent connected scenes
- [ ] Color palette uses only defined colors (± minor variation)
- [ ] Framework tinting applied correctly for each variant
- [ ] Interactive elements are visually distinct without being "gamey"
- [ ] Flicker zones are in peripheral areas only
- [ ] Human-scale details present (something a person left behind)
- [ ] Light direction consistent with time-of-day
- [ ] Negative space is intentional and emotional, not accidental
- [ ] Scene reads clearly at 1920×1080 (test at export res)
- [ ] Player character silhouette is visible against all background areas
