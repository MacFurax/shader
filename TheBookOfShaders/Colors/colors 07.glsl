#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    //uv.x *= u_resolution.x/u_resolution.y;

    vec3 colL = vec3(0.32,0.17,0.36);
    vec3 colR = vec3(0.63,0.53,0.78);
    vec3 colComp = vec3(0.58,0.44,0.70);

    vec3 color = mix(colL, colR,step(0.5, uv.x));

    color = mix(color, 
        colComp, 
        (step(0.2, uv.x)-step(0.3, uv.x))*step(0.3, uv.y)*step(0.3, 1.-uv.y)
        );

    color = mix(color, 
        colComp, 
        (step(0.7, uv.x)-step(0.8, uv.x))*step(0.3, uv.y)*step(0.3, 1.-uv.y)
        );

    gl_FragColor = vec4(color,1.0);
}