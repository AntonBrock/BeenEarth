//
//  MapsPointView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 13.09.2024.
//

import SwiftUI
import MapKit

struct MapsPointView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var savedCoordinates: [MapPoint] = []
    
    var needDismissProfile: (() -> Void)
    var needToShowPointInTheMap: ((MapPoint) -> Void)
    
    @State var didDismissByButton: Bool = false
    @State var editingModeEnable: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 19) {
                if savedCoordinates.isEmpty {
                    Text("You don't have any tags created yet")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .foregroundStyle(Color(hex: "#0A2245"))
                        .font(.system(size: 17, weight: .regular))
                    
                    Button {
                        didDismissByButton.toggle()
                        dismiss.callAsFunction()
                    } label: {
                        Text("Create now")
                            .font(.system(size: 17))
                            .foregroundStyle(Color(hex: "#2C85FF"))
                    }

                } else {
                    ForEach(savedCoordinates, id: \.id) { point in
                        HStack {
                            
                            if editingModeEnable {
                                Image("mapsPoints-doneEdit-icon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 10)
                                    .animation(.linear)
                                    .transition(.opacity)
                                    .onTapGesture {
                                        if let pointIndex = savedCoordinates.firstIndex(where: { $0.id == point.id }) {
                                            savedCoordinates.remove(at: pointIndex)                                            
                                            updateSavedPoints()
                                        }
                                    }
                            }
                            
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "#EFEFEF"))
                                .frame(height: 46)
                                .overlay(alignment: .leading) {
                                    HStack(spacing: 10) {
                                        Text("\(point.name)")
                                            .foregroundStyle(Color(hex: "#2C85FF"))
                                            .font(.system(size: 16, weight: .bold))
                                        
                                        Spacer()
                                        
                                        Image("arrow-to_view")
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                    }
                                    .padding(.leading, 18)
                                    .padding(.trailing, 9)
                                    .padding(.vertical, 9)
                                    .onTapGesture {
                                        needToShowPointInTheMap(point)
                                        dismiss.callAsFunction()
                                    }
                                }
                        }
                    }

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, 40)
            .padding(.horizontal, 45)
        }
            .navigationTitle("Map point's")
            .navigationBarItems(trailing: trailingBarButton())
            .navigationBarTitleDisplayMode(.inline)
            .background(.white)
            .onAppear {
                loadCoordinates()
            }
            .onDisappear {
                if didDismissByButton {
                    needDismissProfile()
                }
            }
    }
    
    private func updateSavedPoints() {        
        if !savedCoordinates.isEmpty {
            savedCoordinates.forEach { coordinate in
                let point = [
                    "name": coordinate.name,
                    "latitude": coordinate.latitude,
                    "longitude": coordinate.longitude
                ] as [String : Any]
                
                UserDefaults.standard.set([point], forKey: "savedCoordinatesWithNames")
            }
        } else {
            UserDefaults.standard.set([], forKey: "savedCoordinatesWithNames")
        }
    }
    
    @ViewBuilder
    private func trailingBarButton() -> some View {
        if savedCoordinates.isEmpty {
            EmptyView()
        } else {
            Button {
                withAnimation {
                    editingModeEnable.toggle()
                }
            } label: {
                if editingModeEnable {
                    Text("Done")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .regular))
                } else {
                    Text("Edit")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .regular))
                }
            }
        }
    }
    
    private func loadCoordinates() {
        if let savedData = UserDefaults.standard.array(forKey: "savedCoordinatesWithNames") as? [[String: Any]] {
            savedData.forEach { point in
                guard let name = point["name"] as? String else {
                    return
                }
                
                guard let latitude = point["latitude"] as? CLLocationDegrees else {
                    return
                }
                
                guard let longitude = point["longitude"] as? CLLocationDegrees else {
                    return
                }
                
                let point: MapPoint = MapPoint(name: name, latitude: latitude, longitude: longitude)
                
                savedCoordinates.append(point)
            }
        }
    }
}
