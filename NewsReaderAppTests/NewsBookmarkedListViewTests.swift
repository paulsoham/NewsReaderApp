//
//  NewsBookmarkedListViewTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI
import XCTest
import Combine
@testable import NewsReaderApp

final class NewsBookmarkedListViewTests: XCTestCase {
    var viewModel: NewsViewModel!
    var mockAPIService: MockAPIService!
    var mockDatabaseService: MockDatabaseService!
    var view: NewsBookmarkedListView!
    
    override func setUp() async throws {
        mockAPIService = MockAPIService()
        mockDatabaseService = MockDatabaseService()
        viewModel = await NewsViewModel(apiService: mockAPIService, databaseService: mockDatabaseService)
        view = await NewsBookmarkedListView()
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        mockDatabaseService = nil
        super.tearDown()
    }
    
    @MainActor func testLoadingState() async {
        viewModel.isLoading = true
        XCTAssertTrue(viewModel.isLoading)
    }
    
    @MainActor func testNoBookmarkedArticles() async {
        await Task {
            viewModel.bookmarkedArticles = []
        }.value
        
        XCTAssertTrue(viewModel.bookmarkedArticles.isEmpty)
    }
    
    @MainActor func testFetchBookmarkedArticlesSuccess() async {
        let article1 = NewsArticle(id: UUID(),
                                   sourceName: "Sample Title",
                                   author: "Sample Source",
                                   title: "Bookmarked Article 1",
                                   articleDescription: "Description",
                                   url: "https://example.com",
                                   urlToImage: "https://example.com/image.jpg",
                                   publishedAt: Date(),
                                   content: "Sample content",
                                   bookmarked: true)
        
        let article2 = NewsArticle(id: UUID(),
                                   sourceName: "Sample Title",
                                   author: "Sample Source",
                                   title: "Bookmarked Article 2",
                                   articleDescription: "Description",
                                   url: "https://example.com",
                                   urlToImage: "https://example.com/image.jpg",
                                   publishedAt: Date(),
                                   content: "Sample content",
                                   bookmarked: true)
        
        mockDatabaseService.bookmarkedArticles = [article1, article2]
        
        viewModel.isLoading = true
        await viewModel.fetchBookmarkedArticles()
        viewModel.isLoading = false
        
        XCTAssertEqual(viewModel.bookmarkedArticles.count, 2)
        XCTAssertEqual(viewModel.bookmarkedArticles[0].title, "Bookmarked Article 1")
        XCTAssertEqual(viewModel.bookmarkedArticles[1].title, "Bookmarked Article 2")
    }
    
    @MainActor func testFetchBookmarkedArticlesFailure() async {
        mockDatabaseService.shouldFail = true
        
        viewModel.isLoading = true
        await viewModel.fetchBookmarkedArticles()
        viewModel.isLoading = false
        
        XCTAssertTrue(viewModel.bookmarkedArticles.isEmpty)
    }
}
