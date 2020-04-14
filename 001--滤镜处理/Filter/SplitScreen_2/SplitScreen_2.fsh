precision highp float;
uniform sampler2D Texture;
varying highp vec2 TextureCoordsVarying;

void main() {
    vec2 uv = TextureCoordsVarying.xy;
    float x;
    if (uv.x >= 0.0 && uv.x <= 0.5) {
        x = uv.x + 0.35;
    } else {
        x = uv.x - 0.15;
    }
    gl_FragColor = texture2D(Texture, vec2(x, uv.y));
}
