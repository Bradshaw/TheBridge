vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	vec4 ret = Texel(texture, texture_coords);
	return vec4(1,1,1,ret.a)*color;
}
