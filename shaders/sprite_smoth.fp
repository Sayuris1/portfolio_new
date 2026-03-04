#version 140

in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;
uniform fs_uniforms
{
    mediump vec4 tint;
    mediump vec4 smoothness;
};

void main()
{
    float dist = pow(length((var_texcoord0.xy * 2) - 1) * smoothness.y, smoothness.x);
    dist = 1 - dist;

    mediump vec4 tint_pm = vec4(tint.xyz * tint.w * dist, dist);
    out_fragColor = texture(texture_sampler, var_texcoord0.xy) * tint_pm;
}
