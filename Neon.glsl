#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

uniform int strength;

varying vec4 vertTexCoord;

vec4 neon_blur() {
    vec4 sum = vec4(0.0);
    vec2 texSize = textureSize(texture, 0);
    for (int i = 0; i <= strength; i++) {
        for (int j = 0; j <= strength; j++) {
            float x = vertTexCoord.s + (1.0/texSize.x * i);
            float y = vertTexCoord.t + (1.0/texSize.y * j);
            if (x >= 0.0 && x <= 1.0 && y >= 0.0 && y <= 1.0) {
                sum += texture2D(texture, vec2(x,y)) / (i+1.0);
            }
        }
    }
    return sum;
}

void main() {
    gl_FragColor = neon_blur();
}
