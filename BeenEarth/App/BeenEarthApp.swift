//
//  BeenEarthApp.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 11.09.2024.
//

import SwiftUI
import AppTrackingTransparency

@main
struct BeenEarthApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State var didTapOkButton: Bool = false
    @State var didTapOkButtonInNotifyScreen: Bool = false
    
    @AppStorage("ATTID") private var ATTID = false
    @AppStorage("hasEnablePushNotification") private var hasEnablePushNotification = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    @State var hidedLaunch: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !didTapOkButton && !hasSeenOnboarding {
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
                    if !hasEnablePushNotification {
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

// MARK: - Push notification
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .notDetermined:
                    print("Not determined")
                case .restricted:
                    print("restricted")
                case .denied:
                    print("Denied")
                case .authorized:
                    print("ATT Token Good: \(status)")

                @unknown default:
                    print("Denied")
                }
            })
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        print("Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}
