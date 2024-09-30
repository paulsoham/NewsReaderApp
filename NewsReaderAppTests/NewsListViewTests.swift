//
//  NewsListViewTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI
import XCTest
import Combine
@testable import NewsReaderApp


final class NewsListViewTests: XCTestCase {
    var viewModel: NewsViewModel!
    var mockAPIService: MockAPIService!
    var mockDatabaseService: MockDatabaseService!
    var view: NewsListView!
    
    override func setUp() async throws {
        mockAPIService = MockAPIService()
        mockDatabaseService = MockDatabaseService()
        viewModel = await NewsViewModel(apiService: mockAPIService, databaseService: mockDatabaseService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        mockDatabaseService = nil
        super.tearDown()
    }
    
    @MainActor func testLoadingState() async {
        await Task {
            viewModel.isLoading = true
        }.value
        await Task {
            XCTAssertTrue(viewModel.isLoading)
        }.value
    }
    
    @MainActor  func testNoArticlesAvailable() async {
        await Task {
            viewModel.articles = []
        }.value
        await Task {
            XCTAssertEqual(viewModel.articles.count, 0)
        }.value
    }
    
    @MainActor func testFetchNewsSuccess() async {
        let article1 = NewsArticle(id: UUID(),
                                   sourceName: "Sample Title",
                                   author: "Sample Source",
                                   title: "Article 1",
                                   articleDescription: "Description",
                                   url: "https://example.com",
                                   urlToImage: "https://example.com/image.jpg",
                                   publishedAt: Date(),
                                   content: "Sample content",
                                   bookmarked: true)
        
        let article2 = NewsArticle(id: UUID(),
                                   sourceName: "Sample Title",
                                   author: "Sample Source",
                                   title: "Article 2",
                                   articleDescription: "Description",
                                   url: "https://example.com",
                                   urlToImage: "https://example.com/image.jpg",
                                   publishedAt: Date(),
                                   content: "Sample content",
                                   bookmarked: true)
        mockAPIService.articlesToReturn = [article1, article2]
        
        await viewModel.fetchNews()
        await Task {
            XCTAssertEqual(viewModel.articles.count, 2)
            XCTAssertEqual(viewModel.articles[1].title, "Article 1")
            XCTAssertEqual(viewModel.articles[0].title, "Article 2")
            XCTAssertNil(viewModel.errorMessage)
        }.value
    }
    
    @MainActor func testFetchNewsFailure() async {
        mockAPIService.shouldFail = true
        
        await viewModel.fetchNews()
        await Task {
            XCTAssertTrue(viewModel.articles.isEmpty)
            XCTAssertNotNil(viewModel.errorMessage)
        }.value
    }
}
