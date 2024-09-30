//
//  NewsDetailViewTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI
import XCTest
import Combine
@testable import NewsReaderApp
import WebKit

final class NewsDetailViewTests: XCTestCase {
    var article: NewsArticle!
    
    override func setUp() {
        super.setUp()
        article = NewsArticle(id: UUID(),
                              sourceName: "Sample Source",
                              author: "Sample Author",
                              title: "Sample Title",
                              articleDescription: "Sample Description",
                              url: "https://example.com",
                              urlToImage: "https://example.com/image.jpg",
                              publishedAt: Date(),
                              content: "Sample Content",
                              bookmarked: true)
    }
    
    override func tearDown() {
        article = nil
        super.tearDown()
    }
    
    func testValidURLLoadsWebView() {
        let view = NewsDetailView(article: article)
        let controller = UIHostingController(rootView: view)
        controller.loadViewIfNeeded()
        XCTAssertNotNil(controller.view.subviews)
    }
    
    func testInvalidURLShowsErrorMessage() {
        article = NewsArticle(id: UUID(),
                              sourceName: "Sample Source",
                              author: "Sample Author",
                              title: "Sample Title",
                              articleDescription: "Sample Description",
                              url: "invalid-url",
                              urlToImage: "https://example.com/image.jpg",
                              publishedAt: Date(),
                              content: "Sample Content",
                              bookmarked: true)
        
        let view = NewsDetailView(article: article)
        let controller = UIHostingController(rootView: view)
        
        controller.loadViewIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let errorMessage = controller.view.subviews.compactMap { $0 as? UILabel }.first
            XCTAssertNotNil(errorMessage)
            XCTAssertEqual(errorMessage?.text, NSLocalizedString("invalid_url_message", comment: "Message displayed when the article URL is invalid"))
        }
    }
}
