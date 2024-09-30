//
//  NewsArticle.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import Foundation
import SwiftData

@Model
class NewsArticle : Identifiable {
    var id: UUID
    var sourceName: String?
    var author: String?
    var title: String?
    var articleDescription: String?
    var url: String
    var urlToImage: String?
    var publishedAt: Date
    var content: String?
    var isBookmarked: Bool
    
    init(id: UUID, sourceName: String?, author: String?, title: String?, articleDescription: String?, url: String, urlToImage: String?, publishedAt: Date, content: String?, bookmarked: Bool) {
        self.id = id
        self.sourceName = sourceName
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.isBookmarked = bookmarked
    }
    
    func cleanUpText() {
        let removedTexts = Set(["[Removed]"])
        if removedTexts.contains(title ?? "") {
            title = nil
        }
        if removedTexts.contains(articleDescription ?? "") {
            articleDescription = nil
        }
    }
}


struct ArticleResponse: Codable {
    let status: String
    var totalResults: Int? = 0
    let articles: [ArticleData]
    
    struct ArticleData: Codable {
        let source: Source?
        let author: String?
        let title: String
        let description: String?
        let url: String
        let urlToImage: String?
        let publishedAt: String
        let content: String?
        
        struct Source: Codable {
            let id: String?
            let name: String?
        }
    }
}

