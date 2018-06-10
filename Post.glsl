#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform float chroma;
uniform float whiteout;
uniform float blur;

varying vec4 vertTexCoord;

vec4 chromatic_aberration(vec2 offset) {
    float g = texture2D(texture, vertTexCoord.st + offset).g;
    float r = texture2D(texture, vec2(vertTexCoord.s+chroma+offset.x, vertTexCoord.t+offset.y)).r;
    float b = texture2D(texture, vec2(vertTexCoord.s-chroma+offset.x, vertTexCoord.t+offset.y)).b;
    return vec4(r, g, b, 1.0);
}
/*
vec4 rect_blur() {	
    vec4 sum = vec4(0.0);
    vec2 texSize = textureSize(texture, 0);
	for (float i = -blur; i <= blur; i+=0.5) {
		for (float j = -blur; j <= blur; j+=0.5) {
			float x = 1.0/texSize.x * i;
			float y = 1.0/texSize.y * j;
			if (x >= 0.0 && x <= 1.0 && y >= 0.0 && y <= 1.0) {
				sum += chromatic_aberration(vec2(x,y));
			}
		}
	}
	return sum / ((20*blur+1)*(20*blur+1));
}*/

void main() {
    vec4 white= vec4(1.0, 1.0, 1.0, 1.0) * whiteout;
    //vec4 col = rect_blur() * (1.0-whiteout);
	vec4 col = chromatic_aberration(vec2(0.0)) * (1.0-whiteout);
	
    gl_FragColor = col + white;
}
