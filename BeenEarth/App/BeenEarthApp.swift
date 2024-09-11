//
//  BeenEarthApp.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 11.09.2024.
//

import SwiftUI

@main
struct BeenEarthApp: App {
    
    @State var didTapOkButton: Bool = false
    
    var body: some Scene {
        
        WindowGroup {
            if !didTapOkButton {
                WelcomeBoardView() {
                    didTapOkButton = true
                }
            } else {
                NotifyScreen()
            }
        }
    }
}
