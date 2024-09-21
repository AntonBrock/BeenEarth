//
//  LaunchScreen.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 17.09.2024.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State private var rotation: Double = 0.0

    var needToDismissScreen: (() -> Void)
    
    var body: some View {
        ZStack {
            Image("launcher_background_icon")
                .resizable()
                .scaledToFill()
            
            VStack {
                Image("launcher_element_icon")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(rotation), anchor: .center)
                    .animation(
                        Animation.linear(duration: 15.0)
                            .repeatForever(autoreverses: false)
                    )
                    .onAppear {
                        withAnimation {
                            rotation = 360
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            
            #warning("TODO: Здесь можно задать КОГДА нужно скрывать экран Launch")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                needToDismissScreen()
            }
        }
    }
}
