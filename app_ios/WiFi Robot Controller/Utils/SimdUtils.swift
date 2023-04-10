//
//  SimdUtils.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/16/23.
//

import Foundation

func MakeScaleMatrix(xScale: Float, yScale: Float) -> simd_float4x4 {
    let rows = [
        simd_float4(xScale, 0, 0, 0),
        simd_float4(0, yScale, 0, 0),
        simd_float4(0, 0, 1, 0),
        simd_float4(0, 0, 0, 1)
    ]
    
    return float4x4(rows: rows)
}

