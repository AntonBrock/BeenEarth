//
//  OnboardingScreen.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 17.09.2024.
//

import SwiftUI

struct OnboardingScreen: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    let pages: [OnboardingPage] = [
        
        OnboardingPage(title: "3D Journey Planet", description: "Your personal world navigator", imageName: "onboarding-page1-icon"),
        OnboardingPage(title: "Favorite places in your pocket", description: "Not only can you view an interactive map in the app, but you can also mark your favorite places to create unique itineraries", imageName: "onboarding-page2-icon"),
        OnboardingPage(title: "Function for viewing objects in 3D", description: "Discover cities from a new perspective with the 3D viewing feature - buildings, monuments and landmarks are in the palm of your hand..", imageName: "onboarding-page3-icon")
    ]
    
    var body: some View {
        ZStack {
            Image("onboarding-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Image("safari-icon")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 45)
                
                ZStack {
                    
                    TabView(selection: $currentPage) {
                        ForEach(pages.indices) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    .padding(.bottom, 70)

                    VStack {
                        HStack {
                            Text("Skip")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .regular))
                                .onTapGesture {
                                    hasSeenOnboarding = true
                                    dismiss()
                                }
                            
                            Spacer()
                            
                            Text("Next")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .regular))
                                .onTapGesture {
                                    withAnimation {
                                        if currentPage == 2 {
                                            hasSeenOnboarding = true
                                            dismiss()
                                        } else {
                                            currentPage += 1
                                        }
                                    }
                                }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 85)
                    .padding(.horizontal, 35)
                }
                
            }
            .padding(.leading, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack {
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 229)
            
            Text(page.title)
                .foregroundColor(.white)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 50)
            
            Text(page.description)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.white)
                .padding(.top, -10)
                .multilineTextAlignment(.center)
        }
        .padding(.top, -60)
        .padding(.horizontal, 32)
    }
}
