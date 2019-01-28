
float pi = 3.14159265359;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5;
    uv *= 2.0;
    uv.x *= iResolution.x/iResolution.y;

    uv *= 4.;
    
    vec2 index = floor(uv+4.); // row:col index 0 -> 7
    
    if( mod(index.x,3. ) == .0)
    {
        float s = max(sin(iTime*.4), 0.);
        uv.y += s*2.;
    }

    if(mod(index.y, 3.) == 0.)
    {
        float s = max(sin(iTime*.4+pi), 0.);
        uv.x += s*4.;
    }

    vec2 fractVal = fract(uv); // create cells 0 -> 1

    float c = distance(fractVal, vec2(.5, .5)); // create circle centered in 0->1 cells
    c = smoothstep(.4, .43, c);
    vec3 color = vec3(c);    

    //fragColor = vec4( fractVal.xy, c, 1. );
    fragColor = vec4( color,  1. );
}

