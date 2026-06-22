# Art Pipeline Setup Guide — Mac M4 Pro

## Step 1: Install Software

### Blender (3D blockout)
1. Go to https://www.blender.org/download/
2. Download **macOS Apple Silicon** version
3. Open the .dmg, drag Blender to Applications
4. Open Blender. It works immediately. No account needed.

### Krita (painting/editing)
1. Go to https://krita.org/en/download/
2. Download **macOS** version
3. Open the .dmg, drag Krita to Applications

### ComfyUI (Stable Diffusion)
1. Open Terminal (Cmd+Space → type "Terminal")
2. Install Homebrew if you don't have it:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
3. Install Python and Git:
```bash
brew install python@3.11 git
```
4. Clone ComfyUI:
```bash
cd ~/Documents
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
```
5. Install dependencies:
```bash
pip3 install torch torchvision torchaudio
pip3 install -r requirements.txt
```
6. Download SDXL model:
```bash
cd models/checkpoints
# Download Juggernaut XL from CivitAI:
# Go to https://civitai.com/models/133005/juggernaut-xl
# Click Download on the latest version (the .safetensors file)
# Move the downloaded file here:
mv ~/Downloads/juggernautXL*.safetensors .
cd ../..
```
7. Download ControlNet models:
```bash
cd custom_nodes
git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git
cd ..
cd models/controlnet

# Download SDXL ControlNet Depth:
# 1. Open: https://huggingface.co/diffusers/controlnet-depth-sdxl-1.0/tree/main
# 2. Click on "diffusion_pytorch_model.fp16.safetensors" 
# 3. Click the download arrow (↓) on that page
# 4. Save/move the file to this folder (models/controlnet/)
# 5. Rename it for clarity:
mv ~/Downloads/diffusion_pytorch_model.fp16.safetensors ./controlnet-depth-sdxl.safetensors

# Download SDXL ControlNet Canny:
# 1. Open: https://huggingface.co/diffusers/controlnet-canny-sdxl-1.0/tree/main
# 2. Click on "diffusion_pytorch_model.fp16.safetensors"
# 3. Click the download arrow (↓) on that page
# 4. Save/move the file to this folder (models/controlnet/)
# 5. Rename it:
mv ~/Downloads/diffusion_pytorch_model.fp16.safetensors ./controlnet-canny-sdxl.safetensors

cd ../..
```

**Alternative (command line download with curl):**
```bash
cd models/controlnet

# Depth ControlNet (~2.5GB)
curl -L -o controlnet-depth-sdxl.safetensors \
  "https://huggingface.co/diffusers/controlnet-depth-sdxl-1.0/resolve/main/diffusion_pytorch_model.fp16.safetensors"

# Canny ControlNet (~2.5GB)  
curl -L -o controlnet-canny-sdxl.safetensors \
  "https://huggingface.co/diffusers/controlnet-canny-sdxl-1.0/resolve/main/diffusion_pytorch_model.fp16.safetensors"

cd ../..
```
8. Run ComfyUI:
```bash
python3 main.py --force-fp16
```
9. Open browser at: http://127.0.0.1:8188

---

## Step 2: Blender — Bus Depot Blockout

### Create the scene (follow exactly):

1. Open Blender. Delete the default cube (select it → press X → Delete)

2. **Set camera:**
   - Press Numpad 0 to enter camera view
   - Select the camera in the Outliner (top right panel)
   - In Properties panel (right side) → Object Properties (orange square icon):
     - Location: X=9.6, Y=-12, Z=3.5
     - Rotation: X=80°, Y=0°, Z=0°
   - Under Camera Properties (green camera icon):
     - Focal Length: 35mm
     - Resolution: 1920 x 1080 (under Output Properties, the printer icon)

3. **Floor:**
   - Shift+A → Mesh → Plane
   - Scale: S → 19.2 → Enter, then S → Y → 10.8 → Enter
   - Location: X=9.6, Y=5.4, Z=0

4. **Back wall:**
   - Shift+A → Mesh → Cube
   - Scale: S → X → 19.2 → Enter, S → Y → 0.2 → Enter, S → Z → 6 → Enter
   - Location: X=9.6, Y=10.8, Z=3

5. **Ceiling:**
   - Shift+A → Mesh → Plane
   - Scale same as floor
   - Location: X=9.6, Y=5.4, Z=6

6. **Left wall:**
   - Shift+A → Mesh → Cube
   - Scale: X=0.2, Y=10.8, Z=6
   - Location: X=0, Y=5.4, Z=3

7. **Windows (3 holes in back wall):**
   - For now, add 3 cubes with an emissive material (bluish white):
   - Shift+A → Mesh → Cube, Scale: X=1.5, Y=0.1, Z=2, Location: X=4, Y=10.7, Z=4.5
   - Duplicate (Shift+D): Location: X=9.6, Y=10.7, Z=4.5
   - Duplicate: Location: X=15, Y=10.7, Z=4.5

8. **Pillars (2):**
   - Shift+A → Mesh → Cylinder (Vertices: 8)
   - Scale: X=0.3, Y=0.3, Z=6, Location: X=6, Y=5, Z=3
   - Duplicate: Location: X=13, Y=5, Z=3

9. **Bus:**
   - Shift+A → Mesh → Cube
   - Scale: X=1.5, Y=3, Z=2, Location: X=4, Y=7, Z=2
   - Add material: dark teal (R=0.2, G=0.35, B=0.3)

10. **Bench:**
    - Shift+A → Mesh → Cube
    - Scale: X=1.5, Y=0.3, Z=0.3, Location: X=2, Y=2, Z=0.5
    - Add material: brown (R=0.45, G=0.3, B=0.15)

11. **Rope:**
    - Shift+A → Mesh → Cylinder
    - Scale: X=0.03, Y=4, Z=0.03, Rotation: X=90°
    - Location: X=12, Y=6, Z=1.2
    - Material: red-brown (R=0.6, G=0.2, B=0.15)

12. **Materials (basic colors):**
    - Floor: cream-grey (R=0.25, G=0.23, B=0.22)
    - Walls: warm grey (R=0.35, G=0.33, B=0.3)
    - Ceiling: dark (R=0.18, G=0.17, B=0.16)
    - Windows: emissive blue-grey (R=0.6, G=0.62, B=0.65, Emission: 2.0)

13. **Lighting:**
    - Delete the default light
    - Add a Sun light: Shift+A → Light → Sun
    - Rotation: X=60°, Y=20°, Z=0°
    - Strength: 2.0
    - Colour: warm white (R=1.0, G=0.95, B=0.9)

14. **Render:**
    - Set render engine to EEVEE (fast) in Render Properties
    - Press F12 to render
    - Image → Save As → `~/Documents/the-remainder-art/depot_color.png`

15. **Depth pass:**
    - Go to Compositing workspace (top tabs)
    - Check "Use Nodes"
    - Add node: Viewer → check "Depth" in Render Layers node
    - Actually easier: View Layer Properties → Passes → check "Z"
    - Re-render (F12)
    - In Compositor, connect "Depth" output from Render Layers to a Normalize node → to Composite
    - Save as `~/Documents/the-remainder-art/depot_depth.png`

---

## Step 3: ComfyUI — Generate the Painted Version

1. Make sure ComfyUI is running: `python3 main.py --force-fp16`
2. Open http://127.0.0.1:8188 in your browser

### Build the workflow:

**If you've used ComfyUI before**, here's the node setup:

```
[Load Checkpoint: JuggernautXL]
         ↓
[CLIP Text Encode (Positive)] → paste the positive prompt below
[CLIP Text Encode (Negative)] → paste the negative prompt below
         ↓
[Load Image: depot_color.png] → [ControlNet Apply (Canny)] weight=0.4
[Load Image: depot_depth.png] → [ControlNet Apply (Depth)] weight=0.6
         ↓
[KSampler] steps=30, cfg=7, sampler=dpmpp_2m, scheduler=karras
         ↓
[VAE Decode] → [Save Image]
```

**Positive prompt:**
```
interior of an art deco bus depot, high vaulted ceiling with iron beams, morning light through dusty clerestory windows, green-oxidized brass fixtures, geometric tilework floor in cream and rust, one bus parked in bay, roped off empty sections, pigeons perched on beams, motes of dust in light shafts, wide composition showing scale and emptiness, quiet abandoned grandeur, painterly digital art, warm atmospheric lighting, muted color palette, amber gold and slate blue tones, soft edges, visible brushstrokes, melancholic beauty, edward hopper mood, game environment concept art, no people, empty scene
```

**Negative prompt:**
```
photorealistic, 3d render, anime, cartoon, pixel art, fantasy, sci-fi, neon, vibrant saturated colors, text, watermark, blurry, low quality, distorted architecture, people, figures, characters, faces, modern, futuristic
```

**Settings:**
- Resolution: 1920 x 1080 (or 1344 x 768 and upscale after — faster)
- Steps: 30
- CFG: 7.0
- Sampler: dpmpp_2m
- Scheduler: karras
- Seed: random (try several)

3. Click "Queue Prompt" — generate 8-12 images (change seed each time)
4. Pick the best 2-3 results

---

## Step 4: Krita — Paintover

1. Open Krita
2. File → Open → your best ComfyUI result
3. Create layers:
   - Duplicate the image layer → name it "reference" → lock it
   - Create new layer above: "paintover"
   - Create new layer: "details"

4. Paint over with a textured brush:
   - Fix any weird architecture (AI sometimes warps lines)
   - Enhance the light shafts from windows
   - Add subtle pigeon shapes on the beams
   - Add bench wear/texture
   - Make sure the bench area (left side) feels like a place you'd sit

5. When done, flatten and export:
   - File → Export → PNG
   - Save as `depot_background.png`

---

## Step 5: Into Godot

1. Copy `depot_background.png` to your Godot project:
   `the-remainder/assets/art/scenes/depot_background.png`

2. In the bus_depot.tscn — replace the CanvasLayer full of ColorRects
   with a single Sprite2D showing your painted background.

   I'll help you with this step when you have the image ready.

---

## Estimated Time

| Step | Time |
|------|------|
| Install everything | 30-45 min (mostly downloads) |
| Blender blockout | 30-45 min |
| ComfyUI generation | 30-60 min (including iteration) |
| Krita paintover | 1-2 hrs |
| Into Godot | 15 min |
| **Total** | **3-5 hours** |

---

## Tips

- If ComfyUI is slow: generate at 1344x768 first, then upscale with the
  built-in SDXL refiner or a 2x upscaler node
- Your M4 Pro 48GB can handle SDXL natively — expect ~30-60 sec per image
- Save your ComfyUI workflow (click Save) so you can reuse it for other scenes
- Keep ALL your Blender blockouts in one .blend file — one scene per location
