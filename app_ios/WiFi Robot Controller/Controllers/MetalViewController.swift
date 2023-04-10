//
//  MetalViewController.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/23/23.
//

import Foundation
import UIKit

class MetalViewController {
    var viewMatrix: simd_float4x4
    public var lastTranslation: SIMD2<Float> = SIMD2<Float>(x: 0, y: 0)
    public var currentTranslation: SIMD2<Float> = SIMD2<Float>(x: 0, y: 0)
    
    public var lastScaleFactor: Float = 1.0
    public var currentScaleFactor: Float = 1.0
    
    init() {
        self.viewMatrix = MakeScaleMatrix(xScale: 1, yScale: 1)
    }

    func scaleView(_ factor: Float) {
        self.currentScaleFactor = factor
        self.updateViewMatrix()
    }
    
    func translateView2d(_ translate: SIMD2<Float>)
    {
        self.currentTranslation.x = (translate.x + self.lastTranslation.x)
        self.currentTranslation.y = (translate.y + self.lastTranslation.y)
        print(translate)
        self.updateViewMatrix()
    }
    
    func endTranslation()
    {
        self.lastTranslation = self.currentTranslation
    }
    
    func endScale()
    {
        self.lastScaleFactor = self.currentScaleFactor
    }
    
    func updateViewMatrix()
    {
        self.viewMatrix = MakeScaleMatrix(xScale: self.currentScaleFactor, yScale: self.currentScaleFactor);
        self.viewMatrix[3, 0] = self.currentTranslation.x
        self.viewMatrix[3, 1] = self.currentTranslation.y
    }
    
}
