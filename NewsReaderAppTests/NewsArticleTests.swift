//
//  NewsArticleTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import XCTest
@testable import NewsReaderApp

class NewsArticleTests: XCTestCase {
    func testArticleInitialization() {
        let article = NewsArticle(
            id: UUID(),
            sourceName: "Source",
            author: "Author",
            title: "Title",
            articleDescription: "Description",
            url: "http://example.com",
            urlToImage: "http://example.com/image.jpg",
            publishedAt: Date(),
            content: "Content",
            bookmarked: false
        )
        
        XCTAssertEqual(article.sourceName, "Source")
        XCTAssertEqual(article.author, "Author")
        XCTAssertEqual(article.title, "Title")
        XCTAssertEqual(article.articleDescription, "Description")
        XCTAssertEqual(article.url, "http://example.com")
        XCTAssertEqual(article.urlToImage, "http://example.com/image.jpg")
        XCTAssertNotNil(article.publishedAt)
        XCTAssertEqual(article.content, "Content")
        XCTAssertFalse(article.isBookmarked)
    }
}
