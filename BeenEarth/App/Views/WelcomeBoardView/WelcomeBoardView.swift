//
//  WelcomeBoardView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 11.09.2024.
//

import SwiftUI
import AppTrackingTransparency
import NotificationCenter

struct WelcomeBoardView: View {
    
    var didTapOkButton: (() -> Void)
    
    var body: some View {
        ZStack {
            Image("welcome_board-image")
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
                .padding(.top, 40)
                   
                Text("Travel\nthe earth")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Text("3d model of our planet, browse\nthe streets, find interesting\nplaces")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Spacer()
                
                VStack {
                    Button {
                        didTapOkButton()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "#1DA0FF"))
                            
                            Text("Go!")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 280, height: 50)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 82)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.top, 12)
            .padding(.leading, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
