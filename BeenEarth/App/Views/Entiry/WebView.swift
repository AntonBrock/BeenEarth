//
//  WebView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 19.09.2024.
//

import SwiftUI

struct WebViewScreen: View {
    
    var link: String
    var navTitle: String
    
    var body: some View {
        VStack {
            WebView(url: URL(string: "\(link)")!)
                .clipped()
                .edgesIgnoringSafeArea([.bottom, .horizontal])
        }
        .navigationBarTitle("\(navTitle)", displayMode: .inline)
        .navigationBarBackButtonHidden(false)
    }
}
