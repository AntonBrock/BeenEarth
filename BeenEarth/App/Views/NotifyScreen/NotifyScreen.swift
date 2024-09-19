//
//  NotifyScreen.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 11.09.2024.
//

import SwiftUI
import AppTrackingTransparency

struct NotifyScreen: View {
    
    var okButtonDidTap: (() -> Void)
    
    @AppStorage("hasEnablePushNotification") private var hasEnablePushNotification = false
    
    @State var isNeedToShowCross: Bool = false
    
    var body: some View {
        ZStack {
            Image("notification_screen-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .padding(.top, -40)
                        
                        VStack {
                            Text("Start your journey on\nEarth!")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                                .padding(.top, 32)
                            
                            Text("Don't miss important updates, notifications about new\nfeatures and news about your notes by enabling push notifications.")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.top, -5)
                                .padding(.horizontal, 10)
                            
                            Button {
                                
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                                    
                                    if granted {
                                        DispatchQueue.main.async {
                                            UIApplication.shared.registerForRemoteNotifications()
                                            hasEnablePushNotification = true
                                            
                                            okButtonDidTap()
                                        }
                                    } else {
                                        okButtonDidTap()
                                    }                                    
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "#1DA0FF"))
                                    
                                    Text("I’m ready!!")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 240, height: 36)
                            }
                            .padding(.top, 0)
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                    .padding(.horizontal, 30)
                    
                    VStack {
                        ZStack {
                            Image("notification_screen-element-icon")
                                .resizable()
                                .frame(width: 251, height: 250)
                            
                            Image("notification_screen-notify-icon")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .padding(.top, -90)
                                .padding(.leading, 160)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 93)
                    
                    VStack {
                        Image("close-icon_white")
                            .resizable()
                            .frame(width: 39, height: 39)
                            .opacity(isNeedToShowCross ? 1 : 0)
                            .onTapGesture {
                                hasEnablePushNotification = false
                                okButtonDidTap()
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                    isNeedToShowCross = true
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 53)
                    .padding(.trailing, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}
