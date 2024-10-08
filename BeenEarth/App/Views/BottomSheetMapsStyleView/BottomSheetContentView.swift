//
//  BottomSheetContentView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 13.09.2024.
//

import SwiftUI
import MapKit

struct BottomSheetContentView: View {
    
    var dismiss: (() -> Void)
    var didChange: ((MapStyle) -> Void)
        
    @Binding var mapType: MKMapType
    @Binding var showInscriptions: Bool
    @Binding var showCaps: Bool

    @State var showSatellitePopover: Bool = false
//    @State var showStreetPopover: Bool = false
    
    @State var showSatellitePopoverSatellite: Bool = false
    @State var showSatellitePopoverStandard: Bool = false
    @State var showSatellitePopoverHybrid: Bool = false
    @State var showSatellitePopoverFlyover: Bool = false

//    @State var showSatellitePopoverCaps: Bool = false
    
//    @State var showStreetPopoverInscriptions: Bool = false
//    @State var showStreetPopoverCaps: Bool = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Choose map style")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.black)
                        .font(.system(size: 24, weight: .semibold))
                    
                    VStack {
                        Image("close-icon")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                    .frame(width: 44, height: 44)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        dismiss()
                    }
                }
                
                VStack {
                    HStack {
                        Text("Satellite")
                            .padding(.leading, 10)
                            .foregroundColor(showSatellitePopover ? Color(hex: "#2C85FF")  : .black)
                            .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                        
                        VStack {
                            Image("showMiniMenu-icon")
                                .resizable()
                                .frame(width: 14, height: 10)
                        }
                        .frame(width: 20, height: 20)
                        
                        Image("satellite-icon")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .padding(.trailing, 5)
                            .padding(.leading, 12)
                    }
                    .onTapGesture {
                        withAnimation {
//                            showStreetPopover = false
                            showSatellitePopover.toggle()
                        }
                    }
                    
                    Divider()
                    
//                    HStack {
//                        Text("Streets")
//                            .foregroundColor(showStreetPopover ? Color(hex: "#2C85FF") : .black)
//                            .font(.system(size: 18, weight: .bold))
//                            .padding(.leading, 10)
//                        
//                        Spacer()
//                        
//                        VStack {
//                            Image("showMiniMenu-icon")
//                                .resizable()
//                                .frame(width: 14, height: 10)
//                        }
//                        .frame(width: 20, height: 20)
//                        
//                        
//                        Image("streets-icon")
//                            .resizable()
//                            .frame(width: 48, height: 48)
//                            .padding(.trailing, 5)
//                            .padding(.leading, 12)
//                    }
//                    .onTapGesture {
//                        withAnimation {
//                            showSatellitePopover = false
//                            showStreetPopover.toggle()
//                        }
//                    }
//                    
//                    Divider()
                }
                                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.white)
            .onTapGesture {
                withAnimation {
//                    showStreetPopover = false
                    showSatellitePopover = false
                }
            }
            
            if showSatellitePopover {
                VStack {
                    HStack {
                        if showSatellitePopoverSatellite {
                            Image("selected-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("Satellite")
                            .foregroundColor(showSatellitePopoverSatellite ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 16, weight: .semibold))

                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 3)
                    .onTapGesture {
                        showSatellitePopoverSatellite = true
                        showSatellitePopoverStandard = false
                        showSatellitePopoverHybrid = false
                        showSatellitePopoverFlyover = false
                        
                        didChange(.satellite)
                    }
                    
                    HStack {
                        if showSatellitePopoverStandard {
                            Image("selected-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("Standard")
                            .foregroundColor(showSatellitePopoverStandard ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 16, weight: .semibold))

                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 3)
                    .onTapGesture {
                        showSatellitePopoverStandard = true
                        showSatellitePopoverSatellite = false
                        showSatellitePopoverHybrid = false
                        showSatellitePopoverFlyover = false
                        
                        didChange(.standard)
                    }
                    
                    HStack {
                        if showSatellitePopoverHybrid {
                            Image("selected-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("Hybrid")
                            .foregroundColor(showSatellitePopoverHybrid ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 16, weight: .semibold))

                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 3)
                    .onTapGesture {
                        showSatellitePopoverSatellite = false
                        showSatellitePopoverStandard = false
                        showSatellitePopoverHybrid = true
                        showSatellitePopoverFlyover = false
                        
                        didChange(.hybrid)
                    }
                    
                    HStack {
                        if showSatellitePopoverFlyover {
                            Image("selected-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("Hyybrid Flyover")
                            .foregroundColor(showSatellitePopoverFlyover ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 16, weight: .semibold))

                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 3)
                    .onTapGesture {
                        showSatellitePopoverSatellite = false
                        showSatellitePopoverStandard = false
                        showSatellitePopoverHybrid = false
                        showSatellitePopoverFlyover = true
                        
                        didChange(.hybridFlyover)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
//                    HStack {
//                        if showSatellitePopoverCaps {
//                            Image("selected-icon")
//                                .resizable()
//                                .frame(width: 16, height: 16)
//                        }
//                        
//                        Text("Show caps")
//                            .foregroundColor(showSatellitePopoverCaps ? Color(hex: "#2C85FF") : .black)
//                            .font(.system(size: 16, weight: .semibold))
//                        
//                        Spacer()
//                    }
//                    .padding(.top, 8)
//                    .padding(.horizontal, 10)
//                    .padding(.bottom, 10)
//                    .onTapGesture {
//                        showSatellitePopoverCaps.toggle()
//                    }
                }
                .background(Color(hex: "#B5B5B5"))
                .cornerRadius(12)
                .frame(width: 240, height: 100)
                .transition(.opacity)
                .padding(.trailing, 20)
                .padding(.top, -20)
            }
            
//            if showStreetPopover {
//                VStack {
//                    HStack {
//                        if showStreetPopoverInscriptions {
//                            Image("selected-icon")
//                                .resizable()
//                                .frame(width: 16, height: 16)
//                        }
//                        
//                        Text("Show inscriptions")
//                            .foregroundColor(showStreetPopoverInscriptions ? Color(hex: "#2C85FF") : .black)
//                            .font(.system(size: 16, weight: .semibold))
//
//                        Spacer()
//                    }
//                    .padding(.top, 8)
//                    .padding(.horizontal, 10)
//                    .padding(.bottom, 3)
//                    .onTapGesture {
//                        showStreetPopoverInscriptions.toggle()
//                    }
//                    
//                    Divider()
//                        .padding(.horizontal)
//                    
//                    HStack {
//                        
//                        if showStreetPopoverCaps {
//                            Image("selected-icon")
//                                .resizable()
//                                .frame(width: 16, height: 16)
//                        }
//                        
//                        Text("Show caps")
//                            .foregroundColor(showStreetPopoverCaps ? Color(hex: "#2C85FF") : .black)
//                            .font(.system(size: 16, weight: .semibold))
//                        
//                        Spacer()
//                    }
//                    .padding(.top, 8)
//                    .padding(.horizontal, 10)
//                    .padding(.bottom, 10)
//                    .onTapGesture {
//                        showStreetPopoverCaps.toggle()
//                    }
//                }
//                .background(Color(hex: "#B5B5B5"))
//                .cornerRadius(12)
//                .frame(width: 240, height: 50)
//                .transition(.opacity)
//                .padding(.trailing, 20)
//                .padding(.top, 50)
//            }
        }
        .onAppear {
            let savedMapStyle = UserDefaults.standard.string(forKey: "savedMapStyle")

            if savedMapStyle == "satellite" {
                self.mapType = .satellite
                showSatellitePopoverSatellite = true
            }
            
            if savedMapStyle == "standard" {
                self.mapType = .standard
                showSatellitePopoverStandard = true
            }
            
            if savedMapStyle == "hybrid" {
                self.mapType = .hybrid
                showSatellitePopoverHybrid = true
            }
            
            if savedMapStyle == "hybridFlyover" {
                self.mapType = .hybridFlyover
                showSatellitePopoverFlyover = true
            }
            
        }
        .onChange(of: mapType) { newValue in
            if newValue == .satellite {
                showSatellitePopoverSatellite = true
                UserDefaults.standard.set("satellite", forKey: "savedMapStyle")
            }
            
            if newValue == .standard {
                showSatellitePopoverStandard = true
                UserDefaults.standard.set("standard", forKey: "savedMapStyle")
            }
            
            if newValue == .hybrid {
                showSatellitePopoverHybrid = true
                UserDefaults.standard.set("hybrid", forKey: "savedMapStyle")
            }
            
            if newValue == .hybridFlyover {
                showSatellitePopoverFlyover = true
                UserDefaults.standard.set("hybridFlyover", forKey: "savedMapStyle")
            }
        }
    }
}
