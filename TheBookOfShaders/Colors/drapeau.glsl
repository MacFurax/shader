#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main() {
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;

    vec3 color = vec3(1.);

    float a = step( .0, uv.x) * (1.-step(.33, uv.x));
    float b = step(.33, uv.x) * (1.-step(.66, uv.x));
    float c = step(.66, uv.x) * (1.-step( 1., uv.x));

    color =vec3(0.4353, 0.8941, 0.9216)*a 
         + vec3(0.8196, 0.4118, 0.6)*b
         + vec3(0.6667, 0.8863, 0.2588)*c;

    float posSin = sin(u_time*1.5+uv.x*10.)/20.;
    float posCos = cos(u_time+uv.x*10.)/20.;

    color *= step(.2+posSin, uv.y) * 
            (1.-step(.8+posSin, uv.y));

    color *= (sin(uv.y*500.+posCos*300.)*1.5);


        
    //color = vec3( mod(uv.y*10.+posSin*10., 1.) );

    gl_FragColor = vec4(color,1.0);

}