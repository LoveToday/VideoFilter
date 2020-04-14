precision highp float;
// 纹理采样器
uniform sampler2D Texture;
// 纹理坐标
varying vec2 TextureCoordsVarying;
// 时间(通过uniform传入一个时间Time)
uniform float Time;

void main (void) {
    // 一次闪白滤镜的时长
    float duration = 0.5;
    // 表示时间周期[0.0,0.5]
    float time = mod(Time, duration);
    // 白色颜色遮罩层
    vec4 whiteMask = vec4(1.0, 1.0, 1.0, 1.0);
    // 振幅: (0.0,1.0)
    float amplitude = abs(sin(time * (PI / duration)));
    // 纹理坐标对应的纹素(RGBA)
    vec4 mask = texture2D(Texture, TextureCoordsVarying);
    
    // 利用混合方程式; 白色图层 + 原始纹理图片颜色 来进行混合
    gl_FragColor = mask * (1.0 - amplitude) + whiteMask * amplitude;
}
