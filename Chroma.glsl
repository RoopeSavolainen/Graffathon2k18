#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform float chroma;

varying vec4 vertTexCoord;

vec4 chromatic_aberration(vec4 c) {
    float g = texture2D(texture, vertTexCoord.st).g;
    float r = texture2D(texture, vec2(vertTexCoord.s+chroma, vertTexCoord.t)).r;
    float b = texture2D(texture, vec2(vertTexCoord.s-chroma, vertTexCoord.t)).b;
    return vec4(r, g, b, 1.0);
}

void main() {
	vec4 color = texture2D(texture, vertTexCoord.st);
    gl_FragColor = chromatic_aberration(color);
}
