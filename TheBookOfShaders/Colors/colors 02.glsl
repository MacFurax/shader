#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 colorA = vec3(0.149,0.141,0.912);
vec3 colorB = vec3(1.000,0.833,0.224);

float plot (vec2 st, float pct){
  return  smoothstep( pct-0.003, pct, st.y) -
          smoothstep( pct, pct+0.003, st.y);
}

// kind of parabol, c center, w half width
float cubicPulse( float c, float w, float x )
{
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

// 
float pcurve( float x, float a, float b )
{
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.0);

    vec3 pct = vec3(st.x);
    float posSin = (sin(u_time/2.)+1.)/2.;
    float posCos = (cos(u_time/2.)+1.)/2.;

    pct.r = smoothstep(0.0,1.1-posCos, st.x);
    pct.g = sin(st.x*PI);
    pct.g = cubicPulse(.1+0.5*posCos, .1+0.4*posSin, st.x);
    pct.g = pcurve( st.x, 0.1, 4.0 );
    pct.b = pow(st.x,.2+posSin*1.5);

    color = mix(colorA, colorB, pct);

    // Plot transition lines for each channel
    color = mix(color,vec3(0.5,0.0,0.0),plot(st,pct.r));
    color = mix(color,vec3(0.0,0.5,0.0),plot(st,pct.g));
    color = mix(color,vec3(0.0,0.0,0.5),plot(st,pct.b));

    gl_FragColor = vec4(color,1.0);
}