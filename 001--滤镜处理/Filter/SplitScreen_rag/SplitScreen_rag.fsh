precision highp float;
// 纹理
uniform sampler2D Texture;
// 纹理坐标
varying vec2 TextureCoordsVarying;
// 时间(通过uniform传入一个时间Time)
uniform float Time;
// 随机数
float rand(float n) {
    //fract(x),返回x的小数部分数据
    return fract(sin(n) * 43758.5453123);
}

void main (void) {
    // 最大抖动
    float maxJitter = 0.06;
    // 一次毛刺滤镜的时长
    float duration = 0.5;
    // 红色颜色偏移量
    float colorROffset = 0.01;
    //绿色颜色偏移量
    float colorGOffset = -0.02;
    // 蓝色颜色偏移量
    float colorBOffset = -0.035;
    
    // 时间周期[0.0,1.0];
    float time = mod(Time, duration * 2.0);
    // 振幅:[0,1];
    float amplitude = max(sin(time * (PI / duration)), 0.0);
    
    // 像素随机偏移[-1,1]
    float jitter = rand(TextureCoordsVarying.y) * 2.0 - 1.0; // -1~1
    
    // 是否要做偏移.
    bool needOffset = abs(jitter) < maxJitter * amplitude;
    
    // 获取纹理X值.根据needOffset，来计算它X撕裂.
    // needOffset = YES，撕裂较大;
    // needOffset = NO，撕裂较小.
    float textureX = TextureCoordsVarying.x + (needOffset ? jitter : (jitter * amplitude * 0.006));
    
    // 撕裂后的纹理坐标x,y
    vec2 textureCoords = vec2(textureX, TextureCoordsVarying.y);
    
    // 颜色偏移3组颜色
    // 根据撕裂后获取的纹理颜色值
    vec4 mask = texture2D(Texture, textureCoords);
    // 撕裂后的纹理颜色偏移
    vec4 maskR = texture2D(Texture, textureCoords + vec2(colorROffset * amplitude, 0.0));
    vec4 maskG = texture2D(Texture, textureCoords + vec2(colorGOffset * amplitude, 0.0));
    vec4 maskB = texture2D(Texture, textureCoords + vec2(colorBOffset * amplitude, 0.0));
    
    // 颜色部分发生撕裂.
    gl_FragColor = vec4(maskR.r, maskG.g, maskB.b, mask.a);
}
