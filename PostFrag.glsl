#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform float whiteout_r;
uniform float whiteout_g;
uniform float whiteout_b;
uniform float whiteout;
uniform int blurring;
uniform float chroma;

varying vec4 vertTexCoord;

vec4 blur(vec4 c) {
    vec4 sum = vec4(0.0);
    vec2 texSize = textureSize(texture, 0);
    for (int i = 0 - blurring; i <= blurring; i++) {
        for (int j = 0 - blurring; j <= blurring; j++) {
            float x = vertTexCoord.s + (1.0 / texSize.x * i);
            float y = vertTexCoord.t + (1.0 / texSize.y * j);
            if (x >= 0.0 && x <= 1.0 && y >= 0.0 && y <= 1.0) {
                sum = sum + texture2D(texture, vec2(x,y));
            }
        }
    }
    return sum / ((2*blurring+1) * (2*blurring+1));
}

vec4 chromatic_aberration(vec4 c) {
    float g = texture2D(texture, vertTexCoord.st).g;
    float r = texture2D(texture, vec2(vertTexCoord.s+chroma, vertTexCoord.t)).r;
    float b = texture2D(texture, vec2(vertTexCoord.s-chroma, vertTexCoord.t)).b;
    return vec4(r, g, b, 1.0);
}

void main() {
    vec4 white= vec4(whiteout_r, whiteout_g, whiteout_b, 1.0) * whiteout;
	vec4 color = texture2D(texture, vertTexCoord.st) * (1.0-whiteout);
	vec4 mix = color + white;
    gl_FragColor = chromatic_aberration(blur(mix));
}
