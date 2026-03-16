//precision highp float;
uniform lowp vec4 u_in;
uniform lowp vec4 u_screen;

varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;
uniform lowp vec4 tint;

float circleFast(vec2 st, vec2 pos, float r) {
    vec2 dist = st - pos;
    return 1.-smoothstep(r-(0.09),r+(0.09),dot(dist,dist)*4.);
}

void main()
{
    // x --> Distortion
    // y --> Size, z --> Circle
    const vec3 WaveParams = vec3(12.0, 0.8, 0.03);

    //Sawtooth wave
    float offset = (u_in.z - floor(u_in.z)) / u_in.z;
	float current_time = u_in.z * offset;    

    vec2 wave_centre = u_in.xy / u_screen.xy;
    float dist = distance(var_texcoord0, wave_centre);

    vec4 color = texture2D(texture_sampler, var_texcoord0);

    //Only distort the pixels within the parameter distance from the centre
    if ((dist <= ((current_time) + (WaveParams.z))) && 
        (dist >= ((current_time) - (WaveParams.z)))) 
	{
        //The pixel offset distance based on the input parameters
		float diff = dist - current_time; 
		float scale_diff = 1.0 - pow(abs(diff * WaveParams.x), WaveParams.y); 
		float diff_time = diff  * scale_diff;
        
        //The direction of the distortion
		vec2 diff_tex_coord = normalize(var_texcoord0 - wave_centre);         
        
        //Perform the distortion and reduce the effect over time
        vec2 tex_coord = var_texcoord0;
		tex_coord += ((diff_tex_coord * diff_time) / (current_time * dist * 40.0));
		color = texture2D(texture_sampler, tex_coord);
        
        //Blow out the color and reduce the effect over time
		color += (color * scale_diff) / (current_time * dist * 40.0);
	} 

    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    gl_FragColor = color * tint_pm; 
}
