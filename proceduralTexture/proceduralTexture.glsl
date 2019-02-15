// require Shader Toy extention for VS Code 


//
// https://www.youtube.com/watch?v=PBxuVlp7nuM
// 

#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURF_DIST .01
const float EPSILON = 0.0001;

vec4 NormalizeMouse()
{
    vec4 mousePos = vec4(iMouse.xy / iResolution.xy,0.,0.); // xy 0 <> 1
    mousePos.xy = 1. - mousePos.xy;
    mousePos.zw = iMouse.zw; // click button states are just copied
    mousePos.xy -= .5; // xy -.5 <> .5
    mousePos.xy *= 2.; // xy -1. <> 1.
    mousePos.x *= iResolution.x/iResolution.y; // compensate for aspect ratio
    return mousePos;
}


//
// This function return the distance from a point in 3D space 
// to the view ray
//
float DistLine( vec3 ro, vec3 rd, vec3 p)
{
    return length(cross(p-ro, rd))/length(rd);
}

// draw a point
// ro: ray origine
// rd: ray direction
// p: point 
//
float DrawPoint(vec3 ro, vec3 rd, vec3 p)
{
// get the distance from the point p to the view ray
    float d = DistLine( ro, rd, p);

    // make it a dot not a degrade
    // comment this line to see distance value
    d = smoothstep(.06,.05, d);
    return d;
}

vec4 s = vec4(0., 1., 6., 1.);

float GetDist(vec3 p) {
    
    float sphereDist =  length(p-s.xyz)-s.w;
    float planeDist = p.y+4.+sin(p.x-iTime*2.)+sin(p.z)/2.;
    
    float d = min(sphereDist, planeDist);
    //float d = sphereDist;
    return d;
}

/**
 * Using the gradient of the SDF, estimate the normal on the surface at point p.
 */
vec3 estimateNormal(vec3 p) {
    return normalize(vec3(
        GetDist(vec3(p.x + EPSILON, p.y, p.z)) - GetDist(vec3(p.x - EPSILON, p.y, p.z)),
        GetDist(vec3(p.x, p.y + EPSILON, p.z)) - GetDist(vec3(p.x, p.y - EPSILON, p.z)),
        GetDist(vec3(p.x, p.y, p.z  + EPSILON)) - GetDist(vec3(p.x, p.y, p.z - EPSILON))
    ));
}

/**
 * Lighting contribution of a single point light source via Phong illumination.
 * 
 * The vec3 returned is the RGB color of the light's contribution.
 *
 * k_a: Ambient color
 * k_d: Diffuse color
 * k_s: Specular color
 * alpha: Shininess coefficient
 * p: position of point being lit
 * eye: the position of the camera
 * lightPos: the position of the light
 * lightIntensity: color/intensity of the light
 *
 * See https://en.wikipedia.org/wiki/Phong_reflection_model#Description
 */
vec3 phongContribForLight(vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 eye,
                          vec3 lightPos, vec3 lightIntensity) {
    vec3 N = estimateNormal(p);
    vec3 L = normalize(lightPos - p);
    vec3 V = normalize(eye - p);
    vec3 R = normalize(reflect(-L, N));
    
    float dotLN = dot(L, N);
    float dotRV = dot(R, V);
    
    if (dotLN < 0.0) {
        // Light not visible from this point on the surface
        return vec3(0.0, 0.0, 0.0);
    } 
    
    if (dotRV < 0.0) {
        // Light reflection in opposite direction as viewer, apply only diffuse
        // component
        return lightIntensity * (k_d * dotLN);
    }
    return lightIntensity * (k_d * dotLN + k_s * pow(dotRV, alpha));
}

/**
 * Lighting via Phong illumination.
 * 
 * The vec3 returned is the RGB color of that point after lighting is applied.
 * k_a: Ambient color
 * k_d: Diffuse color
 * k_s: Specular color
 * alpha: Shininess coefficient
 * p: position of point being lit
 * eye: the position of the camera
 *
 * See https://en.wikipedia.org/wiki/Phong_reflection_model#Description
 */
vec3 phongIllumination(vec3 k_a, vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 eye) {
    const vec3 ambientLight = 0.5 * vec3(1.0, 1.0, 1.0);
    vec3 color = ambientLight * k_a;
    
    vec3 light1Pos = vec3(4.0 * sin(iTime),
                          2.0,
                          4.0 * cos(iTime));
    vec3 light1Intensity = vec3(0.7, 0.7, 0.7);
    
    color += phongContribForLight(k_d, k_s, alpha, p, eye,
                                  light1Pos,
                                  light1Intensity);
    
    vec3 light2Pos = vec3(2.0 * sin(0.37 * iTime),
                          2.0 * cos(0.37 * iTime),
                          2.0);
    vec3 light2Intensity = vec3(0.4, 0.4, 0.4);
    
    color += phongContribForLight(k_d, k_s, alpha, p, eye,
                                  light2Pos,
                                  light2Intensity);    
    return color;
}

float RayMarch(vec3 ro, vec3 rd) {
	float dO=0.;
    
    for(int i=0; i<MAX_STEPS; i++) {
    	vec3 p = ro + rd*dO;
        float dS = GetDist(p);
        dO += dS;
        if(dO>MAX_DIST || dS<SURF_DIST) break;
    }
    
    return dO;
}

vec3 applyFog( in vec3  rgb,       // original color of the pixel
               in float distance, // camera to point distance
               in float b ) // fog density
{
    float fogAmount = 1.0 - exp( -distance*b );
    vec3  fogColor  = vec3(0.4,0.4,0.4);
    return mix( rgb, fogColor, fogAmount );
}

vec3 applyFogY( in vec3  rgb,      // original color of the pixel
               in float distance, // camera to point distance
               in vec3  rayOri,   // camera position
               in vec3  rayDir, // camera to point vector
               in float b,// fog density
               in float c )  // vertical density ?
{
    float fogAmount = c * exp(-rayOri.y*b) * (1.0-exp( -distance*rayDir.y*b ))/rayDir.y;
    vec3  fogColor  = vec3(0.5,0.6,0.7);
    return mix( rgb, fogColor, fogAmount );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float t = iGlobalTime;
	vec2 uv = fragCoord.xy / iResolution.xy; // 0 <> 1
    uv -= .5; // -.5 <> .5
    uv.x *= iResolution.x/iResolution.y; // compensate for aspect ratio

    vec4 mousePos = NormalizeMouse();

    //vec3 ro = vec3(3.*sin(t),2.,-3.*cos(t)); //ray origine (eye) in front of screen
    // zoom factor, eye pos and lookat
    float zoom = 1.;
    vec3 ro = vec3(0., 1., -3.);

    if( mousePos.z > .5)
    {
        ro = ro + vec3(mousePos.x*10., mousePos.y*10., 0.); //ray origine (eye) in front of screen
    }

    if( mousePos.w > .5)
    {
        zoom += mousePos.y*3.;
    }

    vec3 lookAt = vec3(0., 1., 0.);
    
    vec3 f = normalize(lookAt-ro); // camera FORWARD
    vec3 r = cross( vec3(0.,1.,0.), f ); // camera RIGHT
    vec3 u = cross( f, r); // camera UP

    vec3 c =  ro + f*zoom; // center of screen pos
    vec3 i = c + uv.x*r + uv.y*u; // intersetction between ray and intersection

    vec3 rd = i - ro; // ray vector from origine to point on screen
        
    //float d = RayMarch(ro, rd)/15.;
    float d = RayMarch(ro, rd);

    // The closest point on the surface to the eyepoint along the view ray
    vec3 p = ro + d * rd;
    
    vec3 K_a = vec3(0.0667, 0.1569, 0.1922);
    vec3 K_d = vec3(0.0, 0.0, 0.0);
    vec3 K_s = vec3(0.0157, 0.3255, 0.9922);
    float shininess = 10.0;

    vec3 fromCenterToP = normalize( p - s.xyz);
    float fromCenterIntensity = dot(-rd,fromCenterToP );

    float texture = smoothstep( 0.4, 0.5,  fract( p.x*4. + sin(p.y+p.z) + iTime  ));

    //vec3 color = phongIllumination(K_a, K_d, K_s, shininess, p, ro);
    vec3 color = phongIllumination(K_a, vec3(texture, sin(iTime), .1), K_s, shininess, p, ro);

    //fromCenterIntensity *= fromCenterIntensity;
    
    //color += fromCenterIntensity * vec3(0.4, .4, 0.); 

    //color = applyFog( color, d, 0.02);
    //color = applyFogY( color, d, ro, rd, 0.05, .1);

    fragColor = vec4(color, 1.0);
}