#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// impulse	
float impulse( float k, float x )
{
    float h = k*x;
    return h*exp(1.0-h);
}

// kind of parabol, c center, w half width
float cubicPulse( float c, float w, float x )
{
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

// oulse curve
float pcurve( float x, float a, float b )
{
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

void main() {
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;

    vec3 black = vec3(0.0);
    vec3 blue = vec3(0.5647, 0.9843, 0.8941);
    vec3 orangePink = vec3(0.7804, 0.3059, 0.1608);

    vec3 color = mix(black, blue, smoothstep(0.001, 0.8,uv.y));

    color = mix(color, orangePink, cubicPulse(.7, .2, uv.y));

    gl_FragColor = vec4(color,1.0);
}