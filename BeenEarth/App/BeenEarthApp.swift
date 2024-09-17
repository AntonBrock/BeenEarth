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
    @State var didTapOkButtonInNotifyScreen: Bool = false
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
#warning("TODO: НЕ ЗАБЫТЬ ВЕРНУТЬ")
    @State var hidedLaunch: Bool = true //false
    
    var body: some Scene {
        
        WindowGroup {
            if !didTapOkButton {
                if hidedLaunch {
                    WelcomeBoardView() {
                        didTapOkButton = true
                    }
                    .preferredColorScheme(.light)
                } else {
                    LaunchScreen() {
                        hidedLaunch = true
                    }
                    .preferredColorScheme(.dark)
                }
            } else {
                if hasSeenOnboarding {
                    if !didTapOkButtonInNotifyScreen {
                        NotifyScreen() {
                            didTapOkButtonInNotifyScreen = true
                        }
                        .preferredColorScheme(.light)
                    } else {
                        MainScreenView()
                            .preferredColorScheme(.light)
                    }
                } else {
                    OnboardingScreen()
                }
            }
        }
    }
}


