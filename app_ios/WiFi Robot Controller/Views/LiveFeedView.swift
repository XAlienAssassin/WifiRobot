//
//  LiveFeedView.swift
//  WiFi Robot Controller
//
//  Created by Maguire Krist on 3/16/23.
//

import Foundation
import SwiftUI

//This represents the streamed feedback part of the application
struct LiveFeedView: View {
    var wifiViewController: WifiViewController = WifiViewController()
    var viewController: MetalViewController = MetalViewController()
    
    var body: some View {
        VStack(alignment: .leading) {
                    MetalView(wifiController: self.wifiViewController, viewController: self.viewController)
                        .frame(height: 300)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    print(value.magnitude)
                                    self.viewController.scaleView(Float(value.magnitude))
                                }
                                .onEnded { value in
                                    self.viewController.endScale()
                                }
                                .simultaneously(with:
                                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onChanged { value in
                                        self.viewController.translateView2d(SIMD2<Float>(Float(value.translation.width / 150), -Float(value.translation.height / 150)))
                                    }
                                    .onEnded { value in
                                        self.viewController.endTranslation()
                                    }
                                )
                                .simultaneously(with:
                                   RotationGesture()
                                    .onChanged { value in
                                        print(value)
                                    }
                                    .onEnded { value in
                                        
                                    })
                        )
                        WifiListView(controller: self.wifiViewController)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.top)
    }
}
