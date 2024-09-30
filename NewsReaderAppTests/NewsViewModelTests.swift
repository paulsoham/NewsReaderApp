//
//  NewsViewModelTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import Foundation
import XCTest
import Combine
@testable import NewsReaderApp

final class NewsViewModelTests: XCTestCase {
    var viewModel: NewsViewModel!
    var mockAPIService: MockAPIService!
    var mockDatabaseService: MockDatabaseService!
    
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
    
    func testFetchNewsSuccess() async {
        let article1 = createArticle(title: "Article 1")
        let article2 = createArticle(title: "Article 2")
        
        mockAPIService.articlesToReturn = [article1, article2]
        
        await viewModel.fetchNews()
        
        await MainActor.run {
            XCTAssertEqual(viewModel.articles.count, 2)
            XCTAssertEqual(viewModel.articles[1].title, "Article 1")
            XCTAssertEqual(viewModel.articles[0].title, "Article 2")
            XCTAssertNil(viewModel.errorMessage)
        }
    }
    
    func testFetchNewsFailure() async {
        mockAPIService.shouldFail = true
        
        await viewModel.fetchNews()
        
        await MainActor.run {
            XCTAssertTrue(viewModel.articles.isEmpty)
            XCTAssertNotNil(viewModel.errorMessage)
        }
    }
    
    func testHandleBookmarkToggleAdd() async {
        let article = createArticle(title: "Article to Bookmark")
        
        await viewModel.handleBookmarkToggle(for: article)
        
        await MainActor.run {
            XCTAssertEqual(viewModel.bookmarkedArticles.count, 1)
            XCTAssertTrue(viewModel.isBookmarked(article))
            XCTAssertNil(viewModel.errorMessage)
        }
    }
    
    func testHandleBookmarkToggleRemove() async {
        let article = createArticle(title: "Article to Remove Bookmark")
        await viewModel.handleBookmarkToggle(for: article) // Add bookmark first
        
        await viewModel.handleBookmarkToggle(for: article)
        
        await MainActor.run {
            XCTAssertEqual(viewModel.bookmarkedArticles.count, 0)
            XCTAssertFalse(viewModel.isBookmarked(article))
            XCTAssertNil(viewModel.errorMessage)
        }
    }
    
    func testFetchBookmarkedArticles() async {
        let article = createArticle(title: "Bookmarked Article")
        mockDatabaseService.bookmarkedArticles = [article]
        
        await viewModel.fetchBookmarkedArticles()
        
        await MainActor.run {
            XCTAssertEqual(viewModel.bookmarkedArticles.count, 1)
            XCTAssertEqual(viewModel.bookmarkedArticles[0].title, article.title)
        }
    }
    
    func testRemoveBookmarkFailure() async {
        let article = createArticle(title: "Article to Bookmark")
        await viewModel.handleBookmarkToggle(for: article) // Bookmark first
        
        mockDatabaseService.shouldFail = true
        await viewModel.removeBookmark(article)
        
        await MainActor.run {
            XCTAssertEqual(viewModel.bookmarkedArticles.count, 1) // Should still be there
            XCTAssertNotNil(viewModel.errorMessage) // Expect error message
        }
    }
    
    // Helper method to create a NewsArticle
    private func createArticle(title: String) -> NewsArticle {
        return NewsArticle(
            id: UUID(),
            sourceName: "Sample Source",
            author: "Sample Author",
            title: title,
            articleDescription: "Description",
            url: "https://example.com",
            urlToImage: "https://example.com/image.jpg",
            publishedAt: Date(),
            content: "Sample content",
            bookmarked: true
        )
    }
}

// Mock Classes //
class MockAPIService: APIServiceProtocol {
    var shouldFail = false
    var articlesToReturn: [NewsArticle] = []
    
    func fetchArticles(category: String) async throws -> [NewsArticle] {
        if shouldFail {
            throw NSError(domain: "MockError", code: 0, userInfo: nil)
        }
        return articlesToReturn
    }
}

class MockDatabaseService: DatabaseServiceProtocol {
    var bookmarkedArticles: [NewsArticle] = []
    var shouldFail = false
    var articlesToReturn: [NewsArticle] = []
    
    func insertBookmarkedArticle(_ article: NewsArticle) async -> Result<NewsArticle, Error> {
        if shouldFail {
            return .failure(NSError(domain: "MockError", code: 0, userInfo: nil))
        }
        bookmarkedArticles.append(article)
        return .success(article)
    }
    
    func deleteBookmarkedArticle(_ article: NewsArticle) async -> Result<Void, Error> {
        if shouldFail {
            return .failure(NSError(domain: "MockError", code: 0, userInfo: nil))
        }
        bookmarkedArticles.removeAll { $0.title == article.title }
        return .success(())
    }
    
    func fetchAllBookmarkedArticles() async -> Result<[NewsArticle], Error> {
        return .success(bookmarkedArticles)
    }
    
    func fetchBookmarkedArticles() async throws -> [NewsArticle] {
        if shouldFail {
            throw NSError(domain: "MockDatabaseError", code: -1, userInfo: nil)
        }
        return articlesToReturn
    }
}
