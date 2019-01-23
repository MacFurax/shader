//
// https://www.youtube.com/watch?v=PBxuVlp7nuM
// 

//
// This function return the distance from a point in 3D space 
// to the view ray
//
float DistLine( vec3 ro, vec3 rd, vec3 p)
{
    return length(cross(p-ro, rd))/length(rd);
}

// draw a point
// ro: ray origine
// rd: ray direction
// p: point 
//
float DrawPoint(vec3 ro, vec3 rd, vec3 p)
{
// get the distance from the point p to the view ray
    float d = DistLine( ro, rd, p);

    // make it a dot not a degrade
    // comment this line to see distance value
    d = smoothstep(.06,.05, d);
    return d;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy; // 0 <> 1
    uv -= .5; // -.5 <> .5
    uv.x *= iResolution.x/iResolution.y; // compensate for aspect ratio

    // warning if we move the camera back allow we zomm in
    // field of view become narrower
    // so we nned to also move the screen back
    vec3 ro = vec3(0.,0.,-3.); //ray origine (eye) in front of screen
    vec3 rd = vec3(uv.x, uv.y, -2.) - ro; // ray vector from origine to point on screen
        
    float d = 0.;

    d += DrawPoint( ro, rd, vec3(0.,0.,0.));
    d += DrawPoint( ro, rd, vec3(0.,0.,1.));
    d += DrawPoint( ro, rd, vec3(0.,1.,0.));
    d += DrawPoint( ro, rd, vec3(0.,1.,1.));

    d += DrawPoint( ro, rd, vec3(1.,0.,0.));
    d += DrawPoint( ro, rd, vec3(1.,0.,1.));
    d += DrawPoint( ro, rd, vec3(1.,1.,0.));
    d += DrawPoint( ro, rd, vec3(1.,1.,1.));

    fragColor = vec4(d);
}