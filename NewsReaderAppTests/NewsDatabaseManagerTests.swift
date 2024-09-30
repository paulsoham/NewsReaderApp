//
//  NewsDatabaseManagerTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import XCTest
@testable import NewsReaderApp
import SwiftData


class MockModelContext {
    var items: [NewsArticle] = []
    
    func insert(_ item: NewsArticle) {
        items.append(item)
    }
    
    func fetch(_ descriptor: FetchDescriptor<NewsArticle>) throws -> [NewsArticle] {
        return items
    }
    
    func delete(_ item: NewsArticle) {
        items.removeAll { $0.title == item.title }
    }
    
    func save() throws {
        // Mock save, do nothing
    }
    
    // Clear the database
    func clear() {
        items.removeAll()
    }
}

class MockModelContainer {
    var mainContext: MockModelContext {
        return MockModelContext()
    }
}



final class NewsDatabaseManagerTests: XCTestCase {
    var databaseManager: NewsDatabaseManager!
    var mockModelContainer: MockModelContainer!
    var mockModelContext: MockModelContext!
    
    @MainActor override func setUp() {
        super.setUp()
        mockModelContainer = MockModelContainer()
        mockModelContext = mockModelContainer.mainContext
        databaseManager = NewsDatabaseManager()
        
        clearAllItems()
        
    }
    
    private func clearAllItems() {
        let fetchResult = databaseManager.fetchItems()
        switch fetchResult {
        case .success(let items):
            for item in items {
                _ = databaseManager.removeItem(with: item.title ?? "")
            }
        case .failure(let error):
            XCTFail("Failed to fetch items while clearing: \(error)")
        }
    }
    
    // Test for appending an article
    func testAppendItem_Success() {
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
        let result = databaseManager.appendItem(item: article)
        
        switch result {
        case .success(let savedArticle):
            XCTAssertEqual(savedArticle.title, article.title, "The article should be saved successfully.")
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    // Test for fetch articles
    func testFetchItems_Success() {
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
        
        _ = databaseManager.appendItem(item: article1)
        _ = databaseManager.appendItem(item: article2)
        
        let result = databaseManager.fetchItems()
        switch result {
        case .success(let articles):
            XCTAssertEqual(articles.count, 2, "There should be 2 articles in the result.")
            XCTAssertEqual(articles[0].title, "Title 1")
            XCTAssertEqual(articles[1].title, "Title 2")
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    // Test for removing an article
    func testRemoveItem_Success() {
        let article = NewsArticle(id: UUID(),
                                  sourceName: "Sample Title",
                                  author: "Sample Source",
                                  title: "Article to Delete",
                                  articleDescription: "Description",
                                  url: "https://example.com",
                                  urlToImage: "https://example.com/image.jpg",
                                  publishedAt: Date(),
                                  content: "Sample content",
                                  bookmarked: true)
        
        _ = databaseManager.appendItem(item: article)
        
        let result = databaseManager.removeItem(with: article.title!)
        switch result {
        case .success:
            let fetchResult = databaseManager.fetchItems()
            switch fetchResult {
            case .success(let items):
                XCTAssertFalse(items.contains(where: { $0.title == article.title }), "The article should have been removed.")
            case .failure:
                XCTFail("Expected to succeed, but failed with error.")
            }
        case .failure(let error):
            XCTFail("Expected to succeed, but failed with error: \(error).")
        }
    }
    
    func testRemoveItemFailure() {
        let result = databaseManager.removeItem(with: "Non-existent Article")
        
        switch result {
        case .success:
            XCTFail("Expected to fail when trying to remove a non-existent article.")
        case .failure(let error):
            XCTAssertEqual(error as? DatabaseError,nil, "Should return articleNotFound error.")
        }
    }
}



