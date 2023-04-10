//
//  MapClient.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/9/23.
//

import Foundation
import Network

class GridProvider: ObservableObject, NetworkDelegate {
    @Published var occupancyGrid: OccupancyGrid?;
    
    private var client: NetworkClient!
    
    init() {
        self.client = NetworkClient(self, host: "192.168.1.81", port: "3001", using: .tcp)
    }
    
    func onMessage(data: String) {
        let decoder = JSONDecoder()
        DispatchQueue.main.async {
            do {
                self.occupancyGrid = try decoder.decode(OccupancyGrid.self, from: data.data(using: .utf8)!)
                //self.occupancyGrid = self.generateFakeGrid(dim: 20)
            } catch let error {
                print("Error occured whilst decoding incoming map collection: \(error)")
            }
        }
        print("Sucessfully got map: ", self.occupancyGrid?.width)
    }
    
    func isConnected() -> Bool {
        self.client.connection.state == .ready
    }
    
    private func generateFakeGrid(dim: Int) -> OccupancyGrid {
        var temp = OccupancyGrid(width: dim, height: dim, data: [], resolution: 0.5)
        
        for _ in 0..<dim {
            for _ in 0..<dim {
                temp.data.append(Int8.random(in: 0..<125))
            }
        }
        
        return temp
    }
}
