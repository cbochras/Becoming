
shader_type canvas_item;

// Psyche-driven color inputs
uniform vec4 color_top : source_color = vec4(0.08, 0.09, 0.15, 1.0);
uniform vec4 color_bottom : source_color = vec4(0.12, 0.14, 0.22, 1.0);
uniform vec4 color_accent : source_color = vec4(0.1, 0.12, 0.18, 1.0);

// Atmosphere controls
uniform float time_scale : hint_range(0.0, 1.0) = 0.3;
uniform float fog_density : hint_range(0.0, 1.0) = 0.15;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.4;
uniform float breathing : hint_range(0.0, 1.0) = 0.5;

// Noise-based fog
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void fragment() {
    vec2 uv = UV;

    // === BASE GRADIENT (top to bottom with slight curve) ===
    float gradient = pow(uv.y, 1.2);
    vec4 base_color = mix(color_top, color_bottom, gradient);

    // === ACCENT BLEND (side-to-side atmospheric wash) ===
    float accent_mask = sin(uv.x * 3.14159) * 0.3;
    base_color = mix(base_color, color_accent, accent_mask * 0.4);

    // === BREATHING (subtle pulsing luminosity) ===
    float breath = sin(TIME * time_scale * 0.8) * 0.02 * breathing;
    base_color.rgb += breath;

    // === FOG LAYER (drifting noise) ===
    vec2 fog_uv = uv * 3.0 + vec2(TIME * time_scale * 0.1, TIME * time_scale * 0.05);
    float fog = fbm(fog_uv) * fog_density;
    base_color.rgb += fog * vec3(0.15, 0.12, 0.2);

    // === SECONDARY FOG (slower, larger scale) ===
    vec2 fog2_uv = uv * 1.5 + vec2(-TIME * time_scale * 0.05, TIME * time_scale * 0.02);
    float fog2 = fbm(fog2_uv) * fog_density * 0.5;
    base_color.rgb += fog2 * vec3(0.1, 0.15, 0.12);

    // === VIGNETTE (darker edges, focus center) ===
    vec2 center = uv - vec2(0.5);
    float vignette = 1.0 - dot(center, center) * vignette_strength * 2.0;
    vignette = clamp(vignette, 0.0, 1.0);
    base_color.rgb *= vignette;

    COLOR = base_color;
}
