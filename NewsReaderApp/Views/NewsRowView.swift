//
//  NewsRowView.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI

struct NewsRowView: View {
    let article: NewsArticle
    let isBookmarked: Bool
    let onBookmarkToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let title = article.title {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1))) 
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                } else {
                    Text(NSLocalizedString("untitled_article", comment: "Displayed when the article has no title"))
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                
                Spacer()
                
                Button(action: onBookmarkToggle) {
                    ZStack {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(isBookmarked ? .red : .clear)
                            .frame(width: 24, height: 24) // Set icon size
                        
                        Image(systemName: "bookmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 24, height: 24) 
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            if let description = article.articleDescription {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 8)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color(UIColor(red: 0.95, green: 0.98, blue: 1.0, alpha: 1)))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
