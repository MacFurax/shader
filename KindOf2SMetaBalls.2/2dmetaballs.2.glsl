//  Function from Iñigo Quiles
//  www.iquilezles.org/www/articles/functions/functions.htm
float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5;
    uv.x *= iResolution.x/iResolution.y;
    
    // dein circle position and radius
    vec3 c1 = vec3(-0.1, -0.1, 0.14);
    vec3 c2 = vec3(0.1, 0.1, 0.25);

    c1.x += sin(iTime)/(8.+c1.x);
    c1.y += cos(iTime)/10.;
  
    c2.x -= sin(iTime)/5.;
    c2.y -= cos(iTime)/6.;

    // get distance from circle center to uv
    float d1 = distance( c1.xy, uv); 
    float d2 = distance( c2.xy, uv);

    d1 = 1.-smoothstep(0.0, c1.z, d1);
    d2 = 1.-smoothstep(0.0, c2.z, d2);

    float c = d1+d2;

    c = smoothstep(.3, .31, c);
  
    vec3 col = vec3(c);
  
    fragColor = vec4(col,1.0);
}