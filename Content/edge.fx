#if OPENGL
#define SV_POSITION POSITION
#define VS_SHADERMODEL vs_3_0
#define PS_SHADERMODEL ps_3_0
#else
#define VS_SHADERMODEL vs_4_0
#define PS_SHADERMODEL ps_4_0
#endif

float2 unit;
sampler TextureSampler : register(s0);

float4 PS(float4 pos : SV_POSITION, float4 color : COLOR, float4 texCoord : TEXCOORD0) : SV_TARGET0 {
    float3x3 kernel = {
        0, 1, 0,
        1, -4, 1,
        0, 1, 0
    };

    float4 left = tex2D(TextureSampler, texCoord.xy + float2(-unit.x, 0));
    float4 top = tex2D(TextureSampler, texCoord.xy + float2(0, -unit.y));
    float4 right = tex2D(TextureSampler, texCoord.xy + float2(unit.x, 0));
    float4 bottom = tex2D(TextureSampler, texCoord.xy + float2(0, unit.y));

    float4 topLeft = tex2D(TextureSampler, texCoord.xy + float2(-unit.x, -unit.y));
    float4 topRight = tex2D(TextureSampler, texCoord.xy + float2(unit.x, -unit.y));
    float4 bottomRight = tex2D(TextureSampler, texCoord.xy + float2(unit.x, unit.y));
    float4 bottomLeft = tex2D(TextureSampler, texCoord.xy + float2(-unit.x, unit.y));

    float4 center = tex2D(TextureSampler, texCoord.xy);

    return
        (topLeft * kernel._m00 + top * kernel._m01 + topRight * kernel._m02 +
        left * kernel._m10 + center * kernel._m11 + right * kernel._m12 +
        bottomLeft * kernel._m20 + bottom * kernel._m21 + bottomRight * kernel._m22) * 2;
}

technique wind {
    pass P0 {
        PixelShader = compile PS_SHADERMODEL PS();
    }
}
