#version 140

in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;
uniform mediump sampler2D mask;
uniform fs_uniforms
{
    mediump vec4 inputs;
};

#define PI 3.1415926535
#define HALF_PI 1.57079632675

float sdRoundedBox(in vec2 p, in vec2 b, in vec4 r) {
    r.xy = (p.x > 0.0) ? r.xy : r.zw;
    r.x  = (p.y > 0.0) ? r.x  : r.y;
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

// ============================================================
// Core Func：Calculate the custom UV for rounded rectangle
// p: uv
// boxHalfSize: half of rectangle size
// radius: round radius
// thickness: border thickness
// ============================================================
vec2 getRoundedRectUV(vec2 p, vec2 boxHalfSize, float radius, float thickness) {

    float d = sdRoundedBox(p, boxHalfSize, vec4(radius));
    
    // Map the SDF to the 0-1 range.
    // The SDF is 0 at the center of the border, -thickness/2 at the inner edge, 
    // and +thickness/2 at the outer edge.
    float uvX = (d / thickness) + 0.5;
    
    // 2. Calculate Perimeter UV (uv.y 0-1)
    // Determine which section it belongs to based on the pixel position.
    
    vec2 innerHalf = boxHalfSize - radius;
    
    // Calculate the lengths of the four key sections
    float topLen = innerHalf.x * 2.0;
    float sideLen = innerHalf.y * 2.0;
    float cornerLen = PI * radius * 0.5; // 1/4 C
    float totalLen = (topLen + sideLen) * 2.0 + cornerLen * 4.0;
    
    float currentLen = 0.0;
    
    if (p.x > -innerHalf.x && p.x < innerHalf.x) {
        // Within the range of the upper and lower two sides
        if (p.y < 0.0) { 
            // start：Bottom center
            currentLen = p.x < 0.0 ? totalLen + p.x : p.x; 
        } else {
            // dist = BottomHalf + Corner + Side + Corner + TopDist
            currentLen = topLen + cornerLen * 2.0 + sideLen - p.x;
        }
    } 
    else if (p.y > -innerHalf.y && p.y < innerHalf.y) {
        // Within the range of the two sides on either side
        if (p.x > 0.0) {
            // right
            currentLen = innerHalf.x + cornerLen + p.y + innerHalf.y;
        } else {
            // left
            currentLen = (innerHalf.x + innerHalf.y + cornerLen) * 3.0 - p.y;
        }
    }
    else {
        // In the four corner areas
        // Calculate the angles relative to the centers of the four corners
        vec2 cornerCenter = vec2(
            (p.x > 0.0) ? innerHalf.x : -innerHalf.x,
            (p.y > 0.0) ? innerHalf.y : -innerHalf.y
        );
        vec2 diff = p - cornerCenter;
        
        // atan(y, x)
        float angle = atan(diff.y, diff.x);
        float arcLen = 0.0;
        
        // (Bottom-Right)
        if (p.x > 0.0 && p.y < 0.0) {
            // range(-PI/2 , 0)
            float localAngle = angle + HALF_PI; // 0 ~ PI/2
            currentLen = innerHalf.x + localAngle * radius;
        }
        // (Top-Right)
        else if (p.x > 0.0 && p.y > 0.0) {
            float localAngle = angle; // 0 ~ PI/2
            currentLen = innerHalf.x + cornerLen + sideLen + localAngle * radius;
        }
        // (Top-Left)
        else if (p.x < 0.0 && p.y > 0.0) {
            float localAngle = angle - HALF_PI; // 0 ~ PI/2
            currentLen = innerHalf.x * 3.0 + cornerLen * 2.0 + sideLen + localAngle * radius;
        }
        // (Bottom-Left)
        else {
            float localAngle = -angle - HALF_PI; // 0 ~ PI/2
            currentLen = totalLen - innerHalf.x - localAngle * radius;
        }
    }

    // Normalization uv.y
    float uvY = currentLen / totalLen;
    
    return vec2(uvX, uvY);
}

void main()
{
    vec2 uv = var_texcoord0.xy * 2.0 - 1.0;
    
    // the parameters of a rectangle
    vec2 size = vec2(0.95, 0.95);
    float radius = 0.15;
    float width = 0.1; // border
    
    // newUV.x : thickness (0=inner, 1=outer)
    // newUV.y : length (0=start, 1=end)
    vec2 newUV = getRoundedRectUV(uv, size, radius, width);
    
    float distField = (newUV.x - 0.5) * width;
    float borderMask = 1.0 - smoothstep(width*0.5 - 0.002, width*0.5, abs(distField));
    
    // --- Effect: Uniform Flow ---
    float tailLength = 1;

    float progress = fract(newUV.y - inputs.x * 0.5);
     float beam = smoothstep(0.0, tailLength, progress) * smoothstep(tailLength + 0.1, tailLength, progress);
    
    // --- Effect：Make the color the brightest at the center. ---
    float thicknessGlow = sin(newUV.x * 3.14159); 
    
    // HSV loop
    vec3 col = 0.5 + 0.5 * cos(newUV.y * 6.283 + inputs.x + vec3(0, 2, 4));
    
    vec3 finalColor = col * beam * thicknessGlow * 2.0;
    
    vec2 uv_text = var_texcoord0.xy * 2.0 - 1.0;
    uv_text *= 1.11;
    uv_text = (uv_text + 1.0) * 0.5;
    vec4 text = texture(texture_sampler, uv_text);
    vec4 mask = texture(mask, var_texcoord0.xy);

    vec3 endCol = vec3(finalColor * borderMask);
    if (endCol.r != 0.0) 
        out_fragColor = vec4(endCol, 1.0);
    else
        out_fragColor = text * mask.x;
}