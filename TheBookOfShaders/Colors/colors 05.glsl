#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 rgb2hsb( in vec3 c ){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                             6.0)-3.0)-1.0,
                     0.0,
                     1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

//  Function from Iñigo Quiles
//http://www.iquilezles.org/www/articles/functions/functions.htm
float impulse( float k, float x )
{
    float h = k*x;
    return h*exp(1.0-h);
}


void main() {
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    uv.x *= u_resolution.x/u_resolution.y;

    float hue = 0.1;
    float brigth = 0.9;
    brigth = 1.-(impulse(2.0+sin(u_time), uv.x)*0.8);
    //float saturation = impulse(5.0, uv.x);
    //float saturation = impulse(1.0, uv.x);
    float saturation = 1.-(impulse(2.0+sin(u_time), uv.x)*1.0);
    vec3 color = vec3(hsb2rgb(vec3(hue, saturation, brigth)));

    color *= smoothstep( .601,.6, uv.y);
    color *= smoothstep( .4,.401, uv.y);

    gl_FragColor = vec4(color,1.0);
}