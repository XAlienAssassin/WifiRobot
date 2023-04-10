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

protocol SceneRenderer {
    func render(encoder: MTLRenderCommandEncoder, viewMatrixBuffer: MTLBuffer, fragmentUniformBuffer: MTLBuffer)
}

class Renderer : NSObject, MTKViewDelegate {
    
    var parent: MetalView
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let clearColor: MTLClearColor
    //let pipelineState: MTLRenderPipelineState
    
    
    var viewMatrixBuffer: MTLBuffer
    var fragmentUniformBuffer: MTLBuffer
    
    var scenes: [SceneRenderer] = []
    
    init(_ mtkView: MetalView) {
        self.parent = mtkView
        
        self.device = MTLCreateSystemDefaultDevice()!
        self.commandQueue = self.device.makeCommandQueue()!
    
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear

        let samplerState = self.device.makeSamplerState(descriptor: samplerDescriptor)
        
        var initialFragmentUniforms = FragmentUniforms(clearColor: [0.0, 0.5, 0.5, 1.0])
        self.fragmentUniformBuffer = self.device.makeBuffer(bytes: &initialFragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride, options: [])!
        self.viewMatrixBuffer = self.device.makeBuffer(length: MemoryLayout<simd_float4x4>.stride, options: [])!
        
        self.clearColor = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1.0)
        let ptr = self.fragmentUniformBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
        ptr.pointee.clearColor = SIMD4<Float>(x: Float(clearColor.red), y: Float(clearColor.green), z: Float(clearColor.blue), w: Float(clearColor.alpha))
        
        scenes.append(GridRenderer(device: self.device, parent: self.parent))

        
        super.init()
    }
    
    static func createPipelineState(vertexFunction: String, fragmentFunction: String, device: MTLDevice) -> MTLRenderPipelineState {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: vertexFunction)!
        let fragmentFunction = library.makeFunction(name: fragmentFunction)!
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        return try! device.makeRenderPipelineState(descriptor: descriptor)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }

        
        memcpy(viewMatrixBuffer.contents(), &self.parent.viewController.viewMatrix, MemoryLayout<simd_float4x4>.stride)
        
        //Basic drawing Setup
        let commandBuffer = self.commandQueue.makeCommandBuffer()
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = self.clearColor
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        if let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!) {
            //Draw specific for the scene
            for ele in self.scenes {
                ele.render(encoder: renderEncoder, viewMatrixBuffer: self.viewMatrixBuffer, fragmentUniformBuffer: self.fragmentUniformBuffer)
            }
        
            renderEncoder.endEncoding()
        }
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
}
