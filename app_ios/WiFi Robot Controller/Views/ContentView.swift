//
//  ContentView.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 2/2/23.
//

import SwiftUI
import CoreBluetooth

struct PeripheralRow: View {
    var peripheral: CBPeripheral
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    var body: some View {
        HStack {
            Text(peripheral.name ?? "unnamed device")
        }
    }
}
