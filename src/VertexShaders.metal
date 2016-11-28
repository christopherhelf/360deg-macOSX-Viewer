//
//  VertexShaders.metal
//
//  Created by Christopher Helf on 12.07.16.
//  Copyright © 2016 Christopher Helf. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut
{
    float4 m_Position [[ position ]];
    float2 m_TexCoord [[ user(texturecoord) ]];
};

struct VertexIn
{
    float3 m_Position [[ attribute(0) ]];
    float2 m_TexCoord [[ attribute(1) ]];
};

struct Uniforms{
    float4x4 modelMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut vertexShaderSimple(
                                    VertexIn in [[ stage_in ]],
                                    const device Uniforms&  uniforms    [[ buffer(1) ]],
                                    unsigned int vid [[ vertex_id ]]
                                    )
{
    VertexOut outVertex;
    outVertex.m_Position = uniforms.projectionMatrix*uniforms.modelMatrix*float4(in.m_Position,1.0);
    outVertex.m_TexCoord = in.m_TexCoord;
    return outVertex;
}

fragment half4 sphericalSample(VertexOut      inFrag    [[ stage_in ]],
                       texture2d<float>  texture     [[ texture(0) ]],
                       sampler bilinear [[ sampler(0) ]])
{
    return half4(texture.sample(bilinear, inFrag.m_TexCoord));
}
