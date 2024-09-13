//
//  BottomSheetContentView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 13.09.2024.
//

import SwiftUI
import MapKit

struct BottomSheetContentView: View {
    @Binding var mapType: MKMapType
    @Binding var showInscriptions: Bool
    @Binding var showCaps: Bool

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                HStack {
                    Text("Satellite")
                    Spacer()
                    Button {
                        mapType = .satellite
                    } label: {
                        Image(systemName: mapType == .satellite ? "checkmark.circle.fill" : "circle")
                    }
                }
                
                HStack {
                    Text("Streets")
                    Spacer()
                    Button {
                        mapType = .standard
                    } label: {
                        Image(systemName: mapType == .standard ? "checkmark.circle.fill" : "circle")
                    }
                }
                
                Toggle(isOn: $showInscriptions) {
                    Text("Show inscriptions")
                }
                
                Toggle(isOn: $showCaps) {
                    Text("Show caps")
                }
            }
            .background(Color(hex: "#E3E3E3"))
        }
        .frame(maxHeight: 300)
    }
}
