//
//  PointRenderer.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/30/23.
//

import Foundation
import MetalKit
import Metal

class PointRenderer: SceneRenderer {
    
    let parent: MetalView
    let device: MTLDevice
    let vertexBuffer: MTLBuffer
    let vertexCount: Int
    let pipelineState: MTLRenderPipelineState
    
    init(device: MTLDevice, parent: MetalView) {
        self.device = device;
        self.parent = parent;
        
        var vertices: [SIMD2<Float>] = []
        self.vertexCount = 32
        for i in 0..<self.vertexCount {
            let angle = 2 * Float.pi * Float(i) / Float(self.vertexCount)
            let x = cos(angle)
            let y = sin(angle)
            vertices.append(SIMD2<Float>(x, y))
        }
        
        self.vertexBuffer = self.device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        self.pipelineState = Renderer.createPipelineState(vertexFunction: "vertexShader", fragmentFunction: "fragmentShader", device: self.device)
    }
    
    func render(encoder: MTLRenderCommandEncoder, viewMatrixBuffer: MTLBuffer, fragmentUniformBuffer: MTLBuffer) {
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBuffer(viewMatrixBuffer, offset: 0, index: 1)
        encoder.setFragmentBuffer(fragmentUniformBuffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.vertexCount)
    }
}
