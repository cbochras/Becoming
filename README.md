## The Remainder — Godot Project

A game about perception, choice, and the frameworks that shape what we can see.

### Project Structure

```
the-remainder/
├── project.godot
├── scenes/               # All game scenes
│   ├── main.tscn         # Entry point
│   ├── locations/        # Town location scenes
│   └── ui/               # UI scenes (dialogue, etc.)
├── scripts/
│   ├── autoload/         # Singletons (GameState, FrameworkManager, etc.)
│   ├── player/           # Player controller
│   ├── interaction/      # Interactable objects, NPCs
│   ├── dialogue/         # Dialogue system
│   └── systems/          # Framework-conditional visibility, drift
├── assets/
│   ├── art/              # Scene backgrounds, layers
│   ├── characters/       # Character sprites
│   ├── audio/            # Ambient, music, SFX
│   └── fonts/
├── data/
│   ├── dialogue/         # Dialogue JSON files
│   ├── scenes/           # Scene definition data
│   └── framework/        # Interaction tag definitions
└── docs/
    └── art-bible.md
```

### Running

Open in Godot 4.3+. Press F5.

### Controls

- WASD — Move
- E — Interact
- Mouse click — Move to / Interact with
