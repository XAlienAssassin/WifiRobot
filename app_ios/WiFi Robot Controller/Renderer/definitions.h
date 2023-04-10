//
//  definitions.h
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/11/23.
//

#ifndef definitions_h
#define definitions_h


#endif /* definitions_h */

#include <simd/simd.h>

struct Vertex {
    vector_float2 position;
    vector_float2 texCoord;
};

struct FragmentUniforms {
    simd_float4 clearColor;
};

struct WifiStrengthPoint {
    simd_float2 pos;
    uint8_t strength;
};
