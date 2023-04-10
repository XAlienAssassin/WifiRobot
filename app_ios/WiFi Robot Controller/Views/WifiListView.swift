//
//  WifiListView.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/13/23.
//

import Foundation
import SwiftUI

struct WifiListView: View {
    @ObservedObject var wifiSelectionController: WifiViewController
    
    @ObservedObject var wifiModel = WifiDataProvider()
    
    init(controller: WifiViewController) {
        self.wifiSelectionController = controller;
    }
    
    

    var body: some View {
        if self.wifiSelectionController.wifiSelection == nil {
            Text("Default Run: ")
                .padding([.leading], 20)
            List {
                ForEach(Array(wifiModel.wifiMap.keys), id: \.self) { key in
                    HStack {
                        Text(key)
                    }.onTapGesture {
                        self.wifiSelectionController.setWifiSelection(WifiSelection(label: key, essid: self.wifiModel.wifiMap[key]![0].signal.essid, points: self.wifiModel.wifiMap[key]!))
                    }
                }
            }
        } else {
            VStack(alignment: .leading) {
                Text("\(self.wifiSelectionController.wifiSelection!.label) \"\(self.wifiSelectionController.wifiSelection!.essid)\"")
                HStack() {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .padding([.top], 1)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.wifiSelectionController.unsetWifiSelection()
                }
            }.padding([.leading, .trailing], 20)
            List(self.wifiSelectionController.wifiSelection!.points, id: \.self) { point in
                HStack {
                    Circle()
                        .fill(Color(.blue.interpolateRGBColorTo(end: .red, fraction:  CGFloat(point.signal.quality) / 70.0)))
                        .frame(width: 25, height: 25)
                    HStack {
                        HStack {
                            Image(systemName: "link")
                            Text(String(point.signal.quality))
                        }.padding([.trailing], 20)
                        HStack {
                            Image(systemName: "chart.bar")
                            Text(String(point.signal.signalLevel))
                        }
                    }
                }
            }
        }
    }
}
