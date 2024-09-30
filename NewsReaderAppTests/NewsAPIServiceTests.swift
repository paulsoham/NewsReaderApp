//
//  NewsAPIServiceTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import XCTest
import Combine
@testable import NewsReaderApp

class NewsAPIServiceTests: XCTestCase {
    var apiService: NewsAPIService!
    
    override func setUp() {
        super.setUp()
        apiService = NewsAPIService(newsBaseURL: "https://newsapi.org/v2")
    }
    
    func testFetchArticlesSuccess() async throws {
        let articles = try await apiService.fetchArticles(category: "general")
        XCTAssertFalse(articles.isEmpty)
        XCTAssertNotNil(articles.first?.title)
    }
    
    
    func testFetchArticlesWithValidCategory() async throws {
        let category = "technology"
        do {
            let articles = try await apiService.fetchArticles(category: category)
            XCTAssertNotNil(articles, "Articles should not be nil")
            XCTAssertGreaterThan(articles.count, 0, "Articles count should be greater than 0")
        } catch {
            XCTFail("Expected to fetch articles successfully, but failed with error: \(error)")
        }
    }
    
    func testFetchArticlesWithInvalidURL() async {
        let invalidURLService = NewsAPIService(newsBaseURL: "invalid_url")
        do {
            _ = try await invalidURLService.fetchArticles(category: "technology")
            XCTFail("Expected to fail with invalid URL error, but succeeded")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.invalidURL("invalid_url/top-headlines?category=technology&apiKey=eb9ecaa858b84eb58f8f33ca5da08b6f"))
        } catch {
            XCTFail("Expected invalid URL error, but got a different error: \(error)")
        }
    }
    
    
    func testFetchArticlesWithNetworkError() async {
        let networkErrorService = NewsAPIService(newsBaseURL: "https://newsapi.org/v2")
        do {
            _ = try await networkErrorService.fetchArticles(category: "technology")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.networkError(URLError(.notConnectedToInternet)))
        } catch {
            XCTFail("Expected network error, but got different error: \(error)")
        }
    }
    
    func testFetchArticlesWithDecodingError() async {
        let decodingErrorService = NewsAPIService(newsBaseURL: "https://newsapi.org/v2")
        do {
            _ = try await decodingErrorService.fetchArticles(category: "technology")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid JSON"))))
        } catch {
            XCTFail("Expected decoding error, but got different error: \(error)")
        }
    }
    
    
    func testFetchArticlesNetworkError() async throws {
        let invalidService = NewsAPIService(newsBaseURL: "https://nonexistentnewsapi.com")
        do {
            _ = try await invalidService.fetchArticles(category: "general")
            XCTFail("Expected a network error but got success.")
        } catch let error as APIError {
            XCTAssertEqual(error, .unknownError, "Expected network error but got \(error)")
        } catch {
            XCTFail("Expected APIError but got \(type(of: error))")
        }
    }
    
    
}
