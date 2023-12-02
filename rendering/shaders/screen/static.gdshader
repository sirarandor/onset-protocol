shader_type canvas_item;

void fragment() {
	vec2 uv = UV*0.05;
	float a = fract(sin(dot(UV, vec2(12.9898, 78.233) * TIME)) * 438.5453) * 1.4;
	vec4 col = texture(TEXTURE, UV);
	col.a = a-1.25;
	COLOR.a = col.a;
}