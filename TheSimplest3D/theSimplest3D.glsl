float DistLine( vec3 ro, vec3 rd, vec3 p)
{
    return length(cross(p-ro, rd))/length(rd);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy; // 0 <> 1
    uv -= .5; // -.5 <> .5
    uv.x *= iResolution.x/iResolution.y; // compensate for aspect ratio

    vec3 ro = vec3(0.,0.,-3.); //ray origine (eye) in front of screen
    vec3 rd = vec3(uv.x, uv.y, 0.) - ro;

    float t =  iGlobalTime;
    vec3 p = vec3(sin(t),0.,1.+cos(t)*2.);
    float d = DistLine( ro, rd, p);

    d = smoothstep(.1,.09, d);

    fragColor = vec4(d);
}