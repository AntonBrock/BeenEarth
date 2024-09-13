//
//  MapsPointView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 13.09.2024.
//

import SwiftUI

#warning("TODO: Нужно доставать из хранилища точки")

struct MapsPointView: View {
    @State var mapPoints: [String] = []
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 19) {
                if mapPoints.isEmpty {
                    Spacer()
                    
                    Text("Not saved point's")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .foregroundStyle(Color(hex: "#053048"))
                        .font(.system(size: 32, weight: .bold))
                    
                } else {
                    ForEach(mapPoints, id: \.self) { element in
                        HStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "#EFEFEF"))
                                .frame(height: 46)
                                .overlay(alignment: .leading) {
                                    HStack(spacing: 10) {
                                        Text("\(element)")
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
            .navigationBarTitleDisplayMode(.inline)
            .background(.white)
    }
}
