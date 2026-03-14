varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform mediump sampler2D texture_sampler;
uniform lowp vec4 tint;

// https://github.com/subsoap/deffx/blob/master/deffx/materials/rendertarget/blur_simple.fp
void main()
{
    vec4 distance = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 resolution = vec4(450.0, 650.0, 0.0, 0.0);
	float ResS = resolution.x;
	float ResT = resolution.y;

	vec2 stp0 = vec2(1.0/ResS, 0.0);
	vec2 st0p = vec2(0.0, 1.0/ResT);
	vec2 stpp = vec2(1.0/ResS, 1.0/ResT);
	vec2 stpm = vec2(1.0/ResS, -1.0/ResT);

	vec4 i00 = texture2D(texture_sampler, var_texcoord0);
	vec3 im1m1 = texture2D(texture_sampler, var_texcoord0-stpp*distance.x).rgb;
	vec3 ip1p1 = texture2D(texture_sampler, var_texcoord0+stpp*distance.x).rgb;
	vec3 im1p1 = texture2D(texture_sampler, var_texcoord0-stpm*distance.x).rgb;
	vec3 ip1m1 = texture2D(texture_sampler, var_texcoord0+stpm*distance.x).rgb;
	vec3 im10 = texture2D(texture_sampler, var_texcoord0-stp0*distance.x).rgb;
	vec3 ip10 = texture2D(texture_sampler, var_texcoord0+stp0*distance.x).rgb;
	vec3 i0m1 = texture2D(texture_sampler, var_texcoord0-st0p*distance.x).rgb;
	vec3 i0p1 = texture2D(texture_sampler, var_texcoord0+st0p*distance.x).rgb;

	vec3 target = vec3(0.0, 0.0, 0.0);
	target += 1.0*(im1m1+ip1m1+ip1p1+im1p1); 
	target += 2.0*(im10+ip10+i0p1);
	target += 4.0*(i00.rgb);
	target /= 16.0;
	gl_FragColor = vec4(target, i00.a) * tint;
}