// use glsl-canvas extention
// https://marketplace.visualstudio.com/items?itemName=circledev.glsl-canvas

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
	vec2 st = gl_FragCoord.xy/u_resolution;
    st.x *= u_resolution.x/u_resolution.y;

    float cellCountX = 2.;
    float cellCountY = 2.;
    
    vec2 cp = vec2(fract(st.x * cellCountX), fract(st.y * cellCountY) );
    
    //vec3 color = vec3(cp.y*cp.x); 
    float ps = (sin(u_time)+1.)/2.;
    //float ps = 0.0;
    float steps = ceil( distance(cp, vec2(0.5) ) *10. ) / 10.; 
    float gradiant =  distance(cp, vec2(0.5)); 
    vec3 stepsColor = vec3( steps, 0.2+steps/2., 0.5);
    vec3 gradiantColor = vec3(0.1, gradiant, gradiant);
    vec3 color = mix(stepsColor, gradiantColor, ps);

	gl_FragColor = vec4(color,1.0);

    // gamma correction
    //float gamma = 2.2;
    //gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3(1.0/gamma));

}