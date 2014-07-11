extern float times = 10;
extern float time = 0;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	texture_coords.x = mod(texture_coords.x * times+time,1);

	return color * Texel(texture, texture_coords);
}
