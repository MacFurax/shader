// use glsl-canvas extention
// https://marketplace.visualstudio.com/items?itemName=circledev.glsl-canvas

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float plotX( vec2 uv, float x)
{
    return smoothstep(x-0.01, x, uv.x) * smoothstep(x+0.01, x, uv.x);
}

void main() {

	vec2 uv = gl_FragCoord.xy/u_resolution;
    uv.x *= u_resolution.x/u_resolution.y;

    //vec3 color = vec3( smoothstep(0.51, 0.52, st.x), smoothstep(0.53, 0.52, st.x), 0.);

    //vec3 color = vec3( smoothstep( line_start, line_middle, st.x) * smoothstep(line_end, line_middle, st.x) );
    //vec3 color = vec3( smoothstep(0.499, 0.50, uv.x) * smoothstep(0.501, 0.50, uv.x) );
    // positive Sin
    float s = sin(u_time);
    float psin = (s+1.)/2.;
    vec3 color = vec3( 0.0, plotX( uv, 0.2+psin),  0.0 );

 	gl_FragColor = vec4(color,1.0);

    // gamma correction
    //float gamma = 2.2;
    //gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3(1.0/gamma));
}   