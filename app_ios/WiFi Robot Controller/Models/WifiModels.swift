//
//  Wifi.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/13/23.
//

import Foundation

struct WifiCollection: Hashable, Codable {
    static func == (lhs: WifiCollection, rhs: WifiCollection) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
    
    var timestamp: Date
    var data: [WifiSignal]
    var position: Vector3D
}

struct WifiSignal: Hashable, Codable {
    var essid: String
    var address: String
    var quality: Int
    var signalLevel: Int
}

struct WifiPoint: Hashable {
    var signal: WifiSignal
    var position: Vector3D
    var timestamp: Date
}

struct WifiSelection {
    var label: String
    var essid: String
    var points: [WifiPoint]
}
