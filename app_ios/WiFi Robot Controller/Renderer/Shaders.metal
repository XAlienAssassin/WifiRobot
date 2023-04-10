//
//  Shaders.metal
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/11/23.
//

#include <metal_stdlib>
using namespace metal;

#include "definitions.h"

struct Fragment {
    float4 position [[position]];
    float2 texCoord;
};

vertex Fragment vertexShader(
                             const device Vertex *vertexArray[[buffer(0)]],
                             const device float4x4& view [[buffer(1)]],
                             unsigned int vid [[vertex_id]]) {
    Vertex input = vertexArray[vid];
    
    Fragment output;
    output.position = view * float4(input.position.x, input.position.y, 0, 1);
    output.texCoord = input.texCoord;
    
    return output;
}

fragment float4 fragmentShader(
                               Fragment input [[stage_in]],
                               const device FragmentUniforms &uniforms [[buffer(0)]],
                               texture2d<int> texture [[texture(0)]],
                               texture2d<int> wifiMap [[texture(1)]])
{
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    
    int4 pixelValue = texture.sample(textureSampler, input.texCoord);
    float colorValue = (pixelValue.r / 125.0);
    
    float4 drawColor = float4(colorValue, colorValue, colorValue, 1.0);
                            
    return mix(drawColor, uniforms.clearColor, pixelValue.r < 0 ? 1.0 : 0.0);
}
