vec2 N22(vec2 p)
{
    vec3 a = fract(p.xyx*vec3(123.34, 234.34, 345.65));
    //vec3 a = fract(p.xyx*vec3(632.34, 234.34, 345.65));
    //vec3 a = fract(p.xyx*vec3(632.34, 234.34, 44.65));
    a+= dot(a, a+34.45);
    return fract(vec2(a.x*a.y, a.y*a.z));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5;
    uv *= 2.0;
    uv.x *= iResolution.x/iResolution.y;

    float m = 0.;

    float speed = .8;

    float t = iTime*speed;

    float minDist = 100.;
    float cellIndex = 0.;

    float numberOfCells = 50.;

    for( float i = 0.; i<50.; i++)
    {
        vec2 n = N22(vec2(i));
        vec2 p = sin(n*t);

        float d = length(uv-p);
        
        //d = smoothstep(0.1, 0.41, d); // to change contrast
        //d *= 4.0; // like graine de grenadine
        //d = d*d; // intestin ? sir alpha à 0.
        //m += 1. - smoothstep(0.01, 0.02, d);

        if( d<minDist)
        {
            minDist = d;
            cellIndex = i/numberOfCells;
        }
    }

    //vec3 col = vec3(1.-minDist-.6, minDist/2., .0); // to get stomac
    minDist = smoothstep( 0.8, 0.01, minDist);
    vec3 col = vec3(minDist); // to get stomac
    //vec3 col = vec3(cellIndex); // to get cristal

    fragColor = vec4( col ,1.);
}