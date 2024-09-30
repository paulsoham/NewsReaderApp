//
//  NewsDatabaseServiceTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import XCTest
@testable import NewsReaderApp

final class NewsDatabaseServiceTests: XCTestCase {
    
    var mockDatabaseManager: MockDatabaseManager!
    var newsDatabaseService: NewsDatabaseService!
    
    @MainActor override func setUp() {
        super.setUp()
        mockDatabaseManager = MockDatabaseManager()
        newsDatabaseService = NewsDatabaseService(dataSource: mockDatabaseManager)
    }
    
    override func tearDown() {
        mockDatabaseManager = nil
        newsDatabaseService = nil
        super.tearDown()
    }
    
    func testInsertBookmarkedArticleSuccess() async {
        let article = NewsArticle(id: UUID(),
                                  sourceName: "Sample Title",
                                  author: "Sample Source",
                                  title: "John Doe",
                                  articleDescription: "Description",
                                  url: "https://example.com",
                                  urlToImage: "https://example.com/image.jpg",
                                  publishedAt: Date(),
                                  content: "Sample content",
                                  bookmarked: true)
        
        mockDatabaseManager.appendItemResult = .success(article)
        
        let result = await newsDatabaseService.insertBookmarkedArticle(article)
        
        switch result {
        case .success(let savedArticle):
            XCTAssertEqual(savedArticle.title, "John Doe")
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func testInsertBookmarkedArticleFailure() async {
        let article = NewsArticle(id: UUID(),
                                  sourceName: "Sample Title",
                                  author: "Sample Source",
                                  title: "John Doe",
                                  articleDescription: "Description",
                                  url: "https://example.com",
                                  urlToImage: "https://example.com/image.jpg",
                                  publishedAt: Date(),
                                  content: "Sample content",
                                  bookmarked: true)
        
        mockDatabaseManager.appendItemResult = .failure(DatabaseError.generalError)
        
        let result = await newsDatabaseService.insertBookmarkedArticle(article)
        
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error as? DatabaseError, DatabaseError.generalError)
        }
    }
    
    func testFetchAllBookmarkedArticlesSuccess() async {
        let article1 = NewsArticle(id: UUID(),
                                   sourceName: "Sample Title",
                                   author: "Sample Source",
                                   title: "Title 1",
                                   articleDescription: "Description",
                                   url: "https://example.com",
                                   urlToImage: "https://example.com/image.jpg",
                                   publishedAt: Date(),
                                   content: "Sample content",
                                   bookmarked: true)
        
        let article2 = NewsArticle(id: UUID(),
                                   sourceName: "Sample Title",
                                   author: "Sample Source",
                                   title: "Title 2",
                                   articleDescription: "Description",
                                   url: "https://example.com",
                                   urlToImage: "https://example.com/image.jpg",
                                   publishedAt: Date(),
                                   content: "Sample content",
                                   bookmarked: true)
        
        mockDatabaseManager.fetchItemsResult = .success([article1, article2])
        
        let result = await newsDatabaseService.fetchAllBookmarkedArticles()
        
        switch result {
        case .success(let articles):
            XCTAssertEqual(articles.count, 2)
            XCTAssertEqual(articles.first?.title, "Title 1")
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func testDeleteBookmarkedArticleSuccess() async {
        let article = NewsArticle(id: UUID(),
                                  sourceName: "Sample Title",
                                  author: "Sample Source",
                                  title: "John Doe",
                                  articleDescription: "Description",
                                  url: "https://example.com",
                                  urlToImage: "https://example.com/image.jpg",
                                  publishedAt: Date(),
                                  content: "Sample content",
                                  bookmarked: true)
        
        mockDatabaseManager.removeItemResult = .success(())
        
        let result = await newsDatabaseService.deleteBookmarkedArticle(article)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func testDeleteBookmarkedArticleFailure() async {
        let article = NewsArticle(id: UUID(),
                                  sourceName: "Sample Title",
                                  author: "Sample Source",
                                  title: "John Doe",
                                  articleDescription: "Description",
                                  url: "https://example.com",
                                  urlToImage: "https://example.com/image.jpg",
                                  publishedAt: Date(),
                                  content: "Sample content",
                                  bookmarked: true)
        
        mockDatabaseManager.removeItemResult = .failure(DatabaseError.articleNotFound)
        
        let result = await newsDatabaseService.deleteBookmarkedArticle(article)
        
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error as? DatabaseError, DatabaseError.articleNotFound)
        }
    }
}


// Mock Database Manager for Testing
class MockDatabaseManager: NewsDatabaseManagerProtocol {
    var appendItemResult: Result<NewsArticle, Error> = .failure(DatabaseError.generalError)
    var removeItemResult: Result<Void, Error> = .failure(DatabaseError.generalError)
    var fetchItemsResult: Result<[NewsArticle], Error> = .failure(DatabaseError.generalError)
    
    func appendItem(item: NewsArticle) -> Result<NewsArticle, Error> {
        return appendItemResult
    }
    
    func removeItem(with title: String) -> Result<Void, Error> {
        return removeItemResult
    }
    
    func fetchItems() -> Result<[NewsArticle], Error> {
        return fetchItemsResult
    }
}



// Define DatabaseError for error handling
enum DatabaseError: Error {
    case insertFailed
    case fetchFailed
    case articleNotFound
    case generalError
    
}
