//
//  WifiViewController.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/21/23.
//

import Foundation

class WifiViewController: ObservableObject {
    @Published var wifiSelection: WifiSelection?
    @Published var wifiHeatMap: [UInt8]?
    
    func setWifiSelection(_ selection: WifiSelection) {
        print("Current Wifi-Selection changed to ", selection.label)
        self.wifiSelection = selection;
    }
    
    func unsetWifiSelection()
    {
        self.wifiSelection = nil;
    }
    
    func generateWifiHeatMap(dim: Int) {
        if self.wifiSelection == nil {
            return
        }
        
        let points = self.wifiSelection!.points
        var grid: [UInt8] = []
        
        //To generate a wifi heat map on the CPU
        //One most first grap the nearest WifiPoint for a given coordinate, then grab the distance
        //But wifi point coordinates are in the metric space of the origin of the starting position of the turtlebot
        //
        
        for i in 0..<dim {
            for j in 0..<dim {
                var distance: Double = 0.0;
                for point in points {
                    distance += sqrt(pow(Double(point.position.x - Float(j)), 2) + pow(Double(point.position.y - Float(i)), 2))
                }
                //grid.append(distance)
            }
        }
    }
}
