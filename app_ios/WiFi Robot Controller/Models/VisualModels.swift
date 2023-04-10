//
//  VisualModels.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/13/23.
//

import Foundation

struct OccupancyGrid: Codable {
    var width: Int
    var height: Int
    var data: [Int8]
    var resolution: Float
}

struct Vector3D: Hashable, Codable {
    var x: Float
    var y: Float
    var z: Float
}
