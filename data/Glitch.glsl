#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform float glitch_row;
uniform float glitch_len;
uniform float glitch_str;

varying vec4 vertTexCoord;

vec4 corrupt() {
	vec4 val;
	if (vertTexCoord.t >= glitch_row && vertTexCoord.t <= glitch_row + glitch_len) {
		float x = vertTexCoord.s + glitch_str;
		x = x-int(x);
		val = texture2D(texture, vec2(x, vertTexCoord.t));
	}
	else
	{
		val = texture2D(texture, vertTexCoord.st);
	}
	return val;
}

void main() {
    gl_FragColor = corrupt();
}
