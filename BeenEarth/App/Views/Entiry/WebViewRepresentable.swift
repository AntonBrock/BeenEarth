//
//  WebViewRepresentable.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 19.09.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Никаких обновлений не требуется
    }
}
