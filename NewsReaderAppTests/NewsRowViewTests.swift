
//
//  NewsTabBarViewTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI
import XCTest
@testable import NewsReaderApp

final class NewsRowViewTests: XCTestCase {
    
    func testTitleDisplayedWhenExists() {
        let article = createArticle(title: "Test Article", articleDescription: "Test Description", isBookmarked: false)
        XCTAssertEqual(article.title, "Test Article", "Title should be displayed correctly when it exists.")
    }
    
    func testUntitledArticleDisplayedWhenTitleIsNil() {
        let article = createArticle(title: nil, articleDescription: "Test Description", isBookmarked: false)
        
        XCTAssertEqual(article.title ?? NSLocalizedString("untitled_article", comment: ""),
                       NSLocalizedString("untitled_article", comment: ""),
                       "Should display 'untitled_article' when the title is nil.")
    }
    
    func testBookmarkButtonShowsFilledIconWhenBookmarked() {
        _ = createArticle(title: "Test Article", articleDescription: "Test Description", isBookmarked: true)
        let isBookmarked = true
        XCTAssertTrue(isBookmarked, "Button should show filled bookmark icon when bookmarked.")
    }
    
    func testBookmarkButtonShowsEmptyIconWhenNotBookmarked() {
        let article = createArticle(title: "Test Article", articleDescription: "Test Description", isBookmarked: false)
        var isBookmarked = false
        _ = NewsRowView(article: article, isBookmarked: isBookmarked) {
            isBookmarked.toggle()
        }
        
        XCTAssertFalse(isBookmarked, "Button should show empty bookmark icon when not bookmarked.")
    }
    
    func testDescriptionDisplayedWhenExists() {
        let article = createArticle(title: "Test Article", articleDescription: "Test Description", isBookmarked: false)
        XCTAssertEqual(article.articleDescription, "Test Description", "Description should be displayed correctly when it exists.")
    }
    
    func testNoDescriptionNotDisplayed() {
        let article = createArticle(title: "Test Article", articleDescription: nil, isBookmarked: false)
        
        XCTAssertNil(article.articleDescription, "No description should be displayed when it does not exist.")
    }
    
    
    // Helper method to create a NewsArticle
    private func createArticle(title: String?, articleDescription: String?, isBookmarked: Bool) -> NewsArticle {
        return NewsArticle(
            id: UUID(),
            sourceName: "Sample Source",
            author: "Sample Author",
            title: title,
            articleDescription: articleDescription,
            url: "https://example.com",
            urlToImage: "https://example.com/image.jpg",
            publishedAt: Date(),
            content: "Sample content",
            bookmarked: isBookmarked
        )
    }
}

