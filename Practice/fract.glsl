// use glsl-canvas extention
// https://marketplace.visualstudio.com/items?itemName=circledev.glsl-canvas

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
	vec2 st = gl_FragCoord.xy/u_resolution;
    st.x *= u_resolution.x/u_resolution.y;
    
    //float c = fract(st.x*4.) * fract(st.y *4.);
    //c /= 1. + 1.*abs(sin(u_time));

    float cellCountX = 4.;
    float cellCountY = 4.;
    
    float c = fract(st.x * cellCountX); // fract gradiant on x only 
    float c2 = fract(st.x * cellCountX) * fract(st.y * cellCountY); // fract gradiants on x & y
    
    float s = (sin( u_time/2.)+1.)/2.; // 0 to 1 time sin animator

    //c = c*s + (c2 * (1.-s)); // mix both based on sin 
    c = mix(c, c2, s); // mix both based on sin 
    c = ceil(c*10.)/10.; // transform 0 to 1 gradiant in 10 steps

    vec3 color = vec3(c, (0.2+c/2.)*c, (0.4+st.y)*c); // make color with all that

	gl_FragColor = vec4(color,1.0);
}
