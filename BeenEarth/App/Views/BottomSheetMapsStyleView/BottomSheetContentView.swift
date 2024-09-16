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
        
    @Binding var mapType: MKMapType
    @Binding var showInscriptions: Bool
    @Binding var showCaps: Bool

    @State var showSatellitePopover: Bool = false
    @State var showStreetPopover: Bool = false
    
    @State var showSatellitePopoverInscriptions: Bool = false
    @State var showSatellitePopoverCaps: Bool = false
    
    @State var showStreetPopoverInscriptions: Bool = false
    @State var showStreetPopoverCaps: Bool = false

    
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
                            showStreetPopover = false
                            showSatellitePopover.toggle()
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Streets")
                            .foregroundColor(showStreetPopover ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 18, weight: .bold))
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        VStack {
                            Image("showMiniMenu-icon")
                                .resizable()
                                .frame(width: 14, height: 10)
                        }
                        .frame(width: 20, height: 20)
                        
                        
                        Image("streets-icon")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .padding(.trailing, 5)
                            .padding(.leading, 12)
                    }
                    .onTapGesture {
                        withAnimation {
                            showSatellitePopover = false
                            showStreetPopover.toggle()
                        }
                    }
                    
                    Divider()
                }
                                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.white)
            .onTapGesture {
                withAnimation {
                    showStreetPopover = false
                    showSatellitePopover = false
                }
            }
            
            if showSatellitePopover {
                VStack {
                    HStack {
                        if showSatellitePopoverInscriptions {
                            Image("selected-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("Show inscriptions")
                            .foregroundColor(showSatellitePopoverInscriptions ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 16, weight: .semibold))

                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 3)
                    .onTapGesture {
                        showSatellitePopoverInscriptions.toggle()
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack {
                        if showSatellitePopoverCaps {
                            Image("selected-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("Show caps")
                            .foregroundColor(showSatellitePopoverCaps ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        showSatellitePopoverCaps.toggle()
                    }
                }
                .background(Color(hex: "#B5B5B5"))
                .cornerRadius(12)
                .frame(width: 240, height: 50)
                .transition(.opacity)
                .padding(.trailing, 20)
                .padding(.top, -20)
            }
            
            if showStreetPopover {
                VStack {
                    HStack {
                        if showStreetPopoverInscriptions {
                            Image("selected-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("Show inscriptions")
                            .foregroundColor(showStreetPopoverInscriptions ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 16, weight: .semibold))

                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 3)
                    .onTapGesture {
                        showStreetPopoverInscriptions.toggle()
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack {
                        
                        if showStreetPopoverCaps {
                            Image("selected-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("Show caps")
                            .foregroundColor(showStreetPopoverCaps ? Color(hex: "#2C85FF") : .black)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        showStreetPopoverCaps.toggle()
                    }
                }
                .background(Color(hex: "#B5B5B5"))
                .cornerRadius(12)
                .frame(width: 240, height: 50)
                .transition(.opacity)
                .padding(.trailing, 20)
                .padding(.top, 50)
            }
        }
    }
}
