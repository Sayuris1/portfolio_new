#version 140

in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;
uniform mediump sampler2D mask;

void main()
{
    vec4 text = texture(texture_sampler, var_texcoord0.xy);
    vec4 mask = texture(mask, var_texcoord0.xy);

    out_fragColor = (text * mask.x);
}
