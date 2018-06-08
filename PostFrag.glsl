#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform float whiteout_r;
uniform float whiteout_g;
uniform float whiteout_b;
uniform float whiteout_intensity;
uniform int blurring;
uniform float chroma;
uniform int pixelation;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

vec4 pixelate(vec4 c) {

    return c;
}

vec4 blur(vec4 c) {

    return c;
}

vec4 chromatic_aberration(vec4 c) {
    return c;
}


void main() {
    vec4 whiteout = vec4(whiteout_r, whiteout_g, whiteout_b, 1.0) * whiteout_intensity;
	vec4 color = texture2D(texture, vertTexCoord.st) * (1.0-whiteout_intensity);
	vec4 mix = color + whiteout;
    gl_FragColor = chromatic_aberration( pixelate( blur(mix)));
}
