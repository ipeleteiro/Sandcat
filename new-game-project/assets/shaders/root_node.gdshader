shader_type canvas_item;

uniform float tile_scale : hint_range(0.1, 10.0) = 10.0;

void fragment() {
    vec2 scaled_uv = UV * tile_scale;
    COLOR = texture(TEXTURE, scaled_uv);
}
