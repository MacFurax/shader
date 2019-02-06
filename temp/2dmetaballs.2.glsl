//  Function from Iñigo Quiles
//  www.iquilezles.org/www/articles/functions/functions.htm
float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

#define S(v,v0,r)  smoothstep( 1.5/R.y, -1.5/R.y, length(v-(v0)) - (r) ) 

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from -1 to 1)
    vec2 R = iResolution.xy;
    vec2 uv = (2. * fragCoord - iResolution.xy) / iResolution.y;
    
    // dein circle position and radius
    vec3 c1 = vec3(0.0, 0.0, 0.4);
    vec3 c2 = vec3(0.4, 0.4, 0.3);

    c1.x += sin(iTime)/(8.+c1.x);
    c1.y += cos(iTime)/10.;
  
    c2.x -= sin(iTime)/5.;
    c2.y -= cos(iTime)/6.;

    // get distance from circle center to uv
    float d1 = distance( c1.xy, uv); 
    float d2 = distance( c2.xy, uv);

    // make them circle
    d1 = smoothstep(c1.z, 0.0, d1);
    d2 = smoothstep(c2.z, 0.0, d2);

    float c = d1+d2;
    //float c = d1;

    //c = smoothstep( 0.1, 0.11, c);
    //c = S( uv, 0., c1.z);
  
    vec3 col = vec3(c);
  
    //fragColor = vec4(col,1.0) * vec4(uv.x, uv.y, 1.0,1.0);
    //fragColor = vec4(fract(uv.x), fract(uv.y), 0.0,1.0) * vec4(col, 1.0);
    
    // gamma correction
    fragColor = pow(vec4(col, 1.0), vec4(1./2.2) );
}