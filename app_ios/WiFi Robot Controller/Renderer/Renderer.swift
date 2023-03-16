//
//  MetalView.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/11/23.
//

import Foundation
import Metal
import MetalKit
import simd

class Renderer : NSObject, MTKViewDelegate {
    
    var parent: MetalView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    
    var viewMatrix: matrix_float4x4
    var viewMatrixBuffer: MTLBuffer
    
    var gridTexture: MTLTexture?
    var wifiTexture: MTLTexture?
    
    init(_ mtkView: MetalView) {
        self.parent = mtkView
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        
        let pipeDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipeDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipeDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipeDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        self.pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipeDescriptor)
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear

        let samplerState = metalDevice.makeSamplerState(descriptor: samplerDescriptor)
        
        let vertices = [
            Vertex(position: [-1, -1], texCoord: [0, 1]),
            Vertex(position: [1, -1], texCoord: [1, 1]),
            Vertex(position: [-1, 1], texCoord: [0, 0]),
            
            Vertex(position: [1, 1], texCoord: [1, 0]),
            Vertex(position: [-1, 1], texCoord: [0, 0]),
            Vertex(position: [1, -1], texCoord: [1, 1])
            
        ]
        self.vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!

        self.viewMatrix = MakeScaleMatrix(xScale: 0.5, yScale: 0.5)
        self.viewMatrixBuffer = metalDevice.makeBuffer(length: MemoryLayout<simd_float4x4>.stride, options: [])!

        
        super.init()
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
       
        //Because our image is black and white, we can store pixel data as a single byte, hence why here we use the pixel format:
        //r8Uint which is no negative numbers and between 0 and 255.
        if let grid = self.parent.mapModel.occupancyGrid {
            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .r8Uint, width: grid.width, height: grid.height, mipmapped: false)
            
            self.gridTexture = self.metalDevice.makeTexture(descriptor: textureDescriptor)!
            
            let region = MTLRegionMake2D(0, 0, grid.width, grid.height)
            //bytesPerRow is calculated by number of bytes per pixel multiplied by the image width
            //withBytes is the actually byte array of texture/image we want to load
            self.gridTexture!.replace(region: region, mipmapLevel: 0, withBytes: grid.data, bytesPerRow: 1 * grid.width)
        }
        
        memcpy(viewMatrixBuffer.contents(), &self.viewMatrix, MemoryLayout<simd_float4x4>.stride)
        
        
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1.0)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.setVertexBuffer(viewMatrixBuffer, offset: 0, index: 1)
        renderEncoder?.setFragmentTexture(self.gridTexture, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
}
