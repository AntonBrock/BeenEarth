//
//  MainScreenView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 11.09.2024.
//

import SwiftUI
import MapKit
import Foundation

struct MainScreenView: View {
    
    @State var globalMap = GlobeMapView()
    
    @State private var isNeedToOpenProfileScreen: Bool = false
    @State private var isNeedToOpenFeedbackScreen: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                globalMap
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 24) {
                            NavigationLink(isActive: $isNeedToOpenProfileScreen) {
                                ProfileView {
                                    print("Hidden")
                                }
                            } label: {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        Image("mainScreen-settings-icon")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .background(Color.white)
                                    }
                                    .onTapGesture {
                                        isNeedToOpenProfileScreen.toggle()
                                    }
                            }
                            
                            NavigationLink(destination: FeedbackView(), isActive: $isNeedToOpenFeedbackScreen) {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        Image("mainScreen-layers-icon")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .background(Color.white)
                                    }
                                    .onTapGesture {
                                        isNeedToOpenFeedbackScreen.toggle()
                                    }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    globalMap.resetCamera()
                                }
                            }) {
                                Image("mainScreen-backToDefault-icon")
                                    .resizable()
                                    .frame(width: 50, height: 52)
                            }
                            .frame(width: 60, height: 60)
                        }
                        .padding(.trailing, 15)
                    }
                    
                }
                .padding(.top, 60)
                .padding(.horizontal, 15)
            }
        }
        .tint(.black)
    }
}


struct GlobeMapView: UIViewRepresentable {
    let mapView = MKMapView(frame: .zero)

    func makeUIView(context: Context) -> MKMapView {
        mapView.mapType = .satelliteFlyover
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsBuildings = true
        
        resetCamera()
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Обновление карты при изменениях, если нужно
    }
    
    func resetCamera() {
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        camera.centerCoordinateDistance = 10000000000
        camera.pitch = 0
        
        mapView.setCamera(camera, animated: true)
    }
}
