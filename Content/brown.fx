#if OPENGL
#define SV_POSITION POSITION
#define VS_SHADERMODEL vs_3_0
#define PS_SHADERMODEL ps_3_0
#else
#define VS_SHADERMODEL vs_4_0
#define PS_SHADERMODEL ps_4_0
#endif

float time;
float2 ratio;
sampler TextureSampler : register(s0);

float hash(float2 n) {
    return frac(sin(dot(n, float2(12.9898, 78.233))) * 43758.5453123);
}

float noise(float2 p) {
    float2 i = floor(p);
    float2 u = smoothstep(0.0, 1.0, frac(p));

    float a = hash(i + float2(0, 0));
    float b = hash(i + float2(1, 0));
    float c = hash(i + float2(0, 1));
    float d = hash(i + float2(1, 1));

    float r = lerp(lerp(a, b, u.x), lerp(c, d, u.x), u.y);

    return r * r;
}

float fbm(float2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float e = 3.0;

    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= e;
        amplitude *= 0.5;
        e *= 0.95;
    }

    return value;
}

float4 PS(float4 pos : SV_POSITION, float4 color : COLOR, float4 texCoord : TEXCOORD0) : SV_TARGET0 {
    float2 p = texCoord.xy * ratio;

    float3 c = float3(0.0, 0.0, 0.0);

    float2 q = float2(0.0, 0.0);
    q.x = fbm(p);
    q.y = fbm(p + float2(1.0, 1.0));

    float2 r = float2(0.0, 0.0);
    r.x = fbm(p + 1.0 * q + float2(1.7, 9.2) + 0.150 * time );
    r.y = fbm(p + 1.0 * q + float2(8.3, 2.8) + 0.126 * time);

    float f = fbm(p + r);

    c = lerp(
        float3(0.101961, 0.619608, 0.666667),
        float3(0.666667, 0.666667, 0.498039),
        clamp((f * f) * 4.0, 0.0, 1.0)
    );

    c = lerp(
        c,
        float3(0.0, 0.0, 0.164706),
        clamp(length(q), 0.0, 1.0)
    );

    c = lerp(
        c,
        float3(1, 1, 1),
        clamp(length(r.x), 0.0, 1.0)
    );

    float4 center = tex2D(TextureSampler, texCoord.xy);
    return float4(c, 1.0) * center;
}

technique wind {
    pass P0 {
        PixelShader = compile PS_SHADERMODEL PS();
    }
}
