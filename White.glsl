#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform float whiteout_r;
uniform float whiteout_g;
uniform float whiteout_b;
uniform float whiteout;

varying vec4 vertTexCoord;

void main() {
    vec4 white= vec4(whiteout_r, whiteout_g, whiteout_b, 1.0) * whiteout;
	vec4 color = texture2D(texture, vertTexCoord.st) * (1.0-whiteout);
    gl_FragColor = color + white;
}
