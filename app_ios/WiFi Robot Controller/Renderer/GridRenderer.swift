//
//  GridRenderer.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/30/23.
//

import Foundation
import MetalKit
import Metal

class GridRenderer : SceneRenderer {
    
    var gridTexture: MTLTexture?
   
    let parent: MetalView
    let device: MTLDevice
    let vertexBuffer: MTLBuffer
    let vertexCount: Int
    let pipelineState: MTLRenderPipelineState
    
    init(device: MTLDevice, parent: MetalView) {
        self.device = device;
        self.parent = parent;
        
        let vertices = [
            Vertex(position: [-1, -1], texCoord: [0, 1]),
            Vertex(position: [1, -1], texCoord: [1, 1]),
            Vertex(position: [-1, 1], texCoord: [0, 0]),
            
            Vertex(position: [1, 1], texCoord: [1, 0]),
            Vertex(position: [-1, 1], texCoord: [0, 0]),
            Vertex(position: [1, -1], texCoord: [1, 1])
            
        ]
        
        self.vertexBuffer = self.device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        self.vertexCount = vertices.count;
        self.pipelineState = Renderer.createPipelineState(vertexFunction: "vertexShader", fragmentFunction: "fragmentShader", device: self.device)
    }

    
    func render(encoder: MTLRenderCommandEncoder, viewMatrixBuffer: MTLBuffer, fragmentUniformBuffer: MTLBuffer) {
        getOccupancyGridTexture()
        
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBuffer(viewMatrixBuffer, offset: 0, index: 1)
        encoder.setFragmentTexture(self.gridTexture, index: 0)
        encoder.setFragmentBuffer(fragmentUniformBuffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.vertexCount)
    }
    
    private func getOccupancyGridTexture() {
        if var grid = self.parent.mapModel.occupancyGrid {
            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .r8Sint, width: grid.width, height: grid.height, mipmapped: false)
            
            self.gridTexture = self.device.makeTexture(descriptor: textureDescriptor)!
            
            let region = MTLRegionMake2D(0, 0, grid.width, grid.height)
        
            //bytesPerRow is calculated by number of bytes per pixel multiplied by the image width
            //withBytes is the actually byte array of texture/image we want to load
            self.gridTexture!.replace(region: region, mipmapLevel: 0, withBytes: grid.data, bytesPerRow: 1 * grid.width)
        
        }
    }
    
}
