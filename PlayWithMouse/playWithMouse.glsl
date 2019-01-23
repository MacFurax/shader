vec4 NormalizeMouse()
{
    vec4 mousePos = vec4(iMouse.xy / iResolution.xy,0.,0.); // xy 0 <> 1
    mousePos.xy = 1. - mousePos.xy;
    mousePos.zw = iMouse.zw; // click button states are just copied
    mousePos.xy -= .5; // xy -.5 <> .5
    mousePos.xy *= 2.; // xy -1. <> 1.
    mousePos.x *= iResolution.x/iResolution.y; // compensate for aspect ratio
    return mousePos;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy; // 0 <> 1
    uv -= .5; // -.5 <> .5
    uv *= 2.; // -1. <> 1.
    uv.x *= iResolution.x/iResolution.y; // compensate for aspect ratio

   vec4 m = NormalizeMouse();

   fragColor = vec4(m.x, m.y, 0., 1.);
}