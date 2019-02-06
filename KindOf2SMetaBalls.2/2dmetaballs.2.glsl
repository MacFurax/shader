//  Function from Iñigo Quiles
//  www.iquilezles.org/www/articles/functions/functions.htm
float pcurve( float x, float a, float b ){
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from -1 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5;
    uv.x *= iResolution.x/iResolution.y;
    
    // circle position and radius
    vec3 c1 = vec3(-0.1, -0.1, 0.14);
    vec3 c2 = vec3(0.1, 0.1, 0.25);
    vec3 c3 = vec3(0.0,0.0, 0.3);

    // circle colors
    vec3 col1 = vec3(0.7059, 0.3333, 0.3333);
    vec3 col2 = vec3(0.3412, 0.9608, 0.8275);
    vec3 col3 = vec3(0.6863, 0.2784, 0.702);

    // move cirles
    c1.x += sin(iTime)/(8.+c1.x);
    c1.y += cos(iTime)/10.;
  
    c2.x -= sin(iTime)/5.;
    c2.y -= cos(iTime)/6.;

    c3.x -= sin(iTime/2.)/3.;
    c3.y += cos(iTime/4.)/3.;

    // get distance from circle center to uv
    float d1 = distance( c1.xy, uv); 
    float d2 = distance( c2.xy, uv);
    float d3 = distance( c3.xy, uv);

    // make gradiant circle smaller 
    d1 = smoothstep(c1.z, 0.0, d1);
    d2 = smoothstep(c2.z, 0.0, d2);
    d3 = smoothstep(c3.z, 0.0, d3);

    // draw each  ircle
    float c = d1+d2+d3;

    // gradiant to plain circle
    c = smoothstep(.4, .7, c);
  
    //float bgc = fract(uv.x*(18.+2.*sin(iTime))+sin(uv.y*14.));
    
    //float bgc = sin(uv.x*50.)+cos(uv.y*50.);
    float bgc = .0;
    vec3 bgColor = vec3(bgc/4.);

    //bgc = smoothstep(.3, .4, bgc);
    //vec3 bgColor = bgc * vec3(0.8196+uv.y, 0.451, 0.0275);

    // generate colors
    vec3 cola = ((col1 * d1 + col2*d2 + col3 *d3)  * c) ;
    //vec3 colb = (vec3(0.1725, 0.0431, 0.0431)*1.-c);
    vec3 colb = vec3(1.-c);
    vec3 col = 
     colb * bgColor
     + cola;
  
    //fragColor = vec4(col,1.0) * vec4(uv.x, uv.y, 1.0,1.0);
    //fragColor = vec4(fract(uv.x), fract(uv.y), 0.0,1.0) * vec4(col, 1.0);
    
    // gamma correction
    fragColor = pow(vec4(col, 1.0), vec4(1./2.2) );
}