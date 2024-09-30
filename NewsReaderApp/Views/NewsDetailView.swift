//
//  NewsDetailView.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI
import WebKit

struct NewsDetailView: View {
    let article: NewsArticle
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            if let articleURL = URL(string: article.url) {
                WebView(url: articleURL)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text(NSLocalizedString("invalid_url_message", comment: "Message displayed when the article URL is invalid"))
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.5)))
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding([.top, .leading], 16)
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}



// WKWebView wrapper using WebKit for SwiftUI
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
