
float pi = 3.14159265359;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5;
    uv *= 2.0;
    uv.x *= iResolution.x/iResolution.y;

    // -4 to 4
    uv *= 4.;
    
    // create cells index
    vec2 index = floor(uv+4.); // row:col index 0 -> 7
    
    // move few column at interval
    if( mod(index.x,3. ) == .0)
    {
        float s = max(mod(iTime+5., 6.)-5., 0.);
         s = smoothstep(0.1,0.9,s);
        uv.y -= s*2.;
    }

    // move few rows at interval
    // if(mod(index.y, 4.) == 0.)
    // {
    //     float s = max(mod(iTime+3.,6.)-5., 0.);
    //     uv.x += s*4.;
    // }

    if(mod(index.y, 4.) == 0.)
    {
        float s = max(mod((iTime/2.)+4.,6.)-5., 0.);
        s = smoothstep(0.1,0.9,s);
        uv.x += s;
    }

     if(mod(index.y, 3.) == 0.)
    {
        float s = max(mod((iTime/2.)+7.,6.)-5., 0.);
         s = smoothstep(0.1,0.9,s);
        uv.x += s*4.;
    }

    // create cells gradiant
    vec2 fractVal = fract(uv); // create cells gradiant 0.0 -> 1.0

    // create circle
    float c = distance(fractVal, vec2(.5, .5)); // create gradiant centered in 0->1 cells
    c = smoothstep(.3, .31, c); // gradiant to circle
    vec3 color = vec3(c);    

    //fragColor = vec4( fractVal.xy, c, 1. );
    fragColor = vec4( color,  1. );
}

