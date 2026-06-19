# Framework Tint Shader
# Applied to a ColorRect overlay on each scene.
# Subtly shifts color temperature based on dominant framework.
# The player should never consciously notice this.

shader_type canvas_item;

uniform float vairagya : hint_range(0.0, 1.0) = 0.25;
uniform float nihilism : hint_range(0.0, 1.0) = 0.25;
uniform float absurdism : hint_range(0.0, 1.0) = 0.25;
uniform float existentialism : hint_range(0.0, 1.0) = 0.25;
uniform float intensity : hint_range(0.0, 0.1) = 0.03;

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    // Vairagya: slight desaturation + cool shift
    float desat = vairagya * intensity;
    float grey = dot(base.rgb, vec3(0.299, 0.587, 0.114));
    vec3 vairagya_tint = mix(base.rgb, vec3(grey) + vec3(-0.02, 0.0, 0.03), desat);

    // Nihilism: contrast boost + blue-green
    vec3 nihilism_tint = mix(base.rgb, base.rgb * vec3(0.95, 1.0, 1.02), nihilism * intensity);

    // Absurdism: warmth + slight saturation boost
    vec3 absurdism_tint = mix(base.rgb, base.rgb * vec3(1.03, 1.01, 0.97), absurdism * intensity);

    // Existentialism: no shift (raw)
    vec3 existentialism_tint = base.rgb;

    // Blend all based on weights
    float total = vairagya + nihilism + absurdism + existentialism;
    vec3 final_color = (
        vairagya_tint * vairagya +
        nihilism_tint * nihilism +
        absurdism_tint * absurdism +
        existentialism_tint * existentialism
    ) / max(total, 0.01);

    COLOR = vec4(final_color, base.a);
}
