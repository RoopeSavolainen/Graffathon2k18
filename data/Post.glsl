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

vec3 rect_blur() {
    vec3 sum = vec3(0.0);
	float weights[5][5] = float[5][5](
		float[5](0.1, 0.2, 0.3, 0.2, 0.1),
		float[5](0.2, 0.4, 0.6, 0.4, 0.2),
		float[5](0.3, 0.6, 1.0, 0.6, 0.3),
		float[5](0.2, 0.4, 0.6, 0.4, 0.2),
		float[5](0.1, 0.2, 0.3, 0.2, 0.1));
	for (int i = 0; i < 5; i++) {
		for (int j = 0; j < 5; j++) {
			weights[i][j] = pow(weights[i][j], 1/blur);
		}
	}
	
	float weight_sum = 0.0;
    vec2 texSize = textureSize(texture, 0);
	for (int i = -2; i <= 2; i++) {
		for (int j = -2; j <= 2; j++) {
			float x = 1.0/texSize.x * i;
			float y = 1.0/texSize.y * j;
			if (x >= 0.0 && x <= 1.0 && y >= 0.0 && y <= 1.0) {
				sum += chromatic_aberration(vec2(x,y)).rgb * weights[i+2][j+2];
				weight_sum += weights[i+2][j+2];
			}
		}
	}
	return sum / weight_sum;
}

void main() {
    vec4 white = vec4(1.0, 1.0, 1.0, 1.0) * whiteout;
    vec4 col = vec4(rect_blur(), 1.0) * (1.0-whiteout);
	//vec4 col = chromatic_aberration(vec2(0.0)) * (1.0-whiteout);
	
    gl_FragColor = col + white;
}
