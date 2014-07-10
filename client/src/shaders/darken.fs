extern float min = 0.08;
extern float max = 0.3;


vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	vec4 ret = Texel(texture, texture_coords)*color;
	ret = smoothstep(vec4(min,min,min,1),vec4(max,max,max,1),ret);
	ret.a = 1;
	return ret;
}
