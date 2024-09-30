//
//  NewsAPIService.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import Foundation

enum APIError: Error, LocalizedError, Equatable {
    case invalidURL(String)
    case networkError(URLError)
    case decodingError(DecodingError)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return String(format: NSLocalizedString("invalid_url_error", comment: "Displayed when an invalid URL is encountered."), url)
        case .networkError(let error):
            return String(format: NSLocalizedString("network_error", comment: "Displayed when a network error occurs."), error.localizedDescription)
        case .decodingError(let error):
            return error.localizedDescription
        case .unknownError:
            return NSLocalizedString("unknown_error", comment: "Displayed when an unknown error occurs.")
        }
    }
    
    static func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL(let lhsURL), .invalidURL(let rhsURL)):
            return lhsURL == rhsURL
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError == rhsError
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.unknownError, .unknownError):
            return true
        default:
            return false
        }
    }
}


protocol APIServiceProtocol {
    func fetchArticles(category: String) async throws -> [NewsArticle]
}

final class NewsAPIService: APIServiceProtocol {
    private let apiKey = "06828e4a608f45deb3b45babcefeddfb"
    private var baseURL = "https://newsapi.org/v2"
    private let endpoint = "/top-headlines"
    
    init(newsBaseURL: String = "https://newsapi.org/v2") {
        self.baseURL = newsBaseURL
    }
    
    func fetchArticles(category: String) async throws -> [NewsArticle] {
        
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            throw APIError.invalidURL(baseURL + endpoint)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL("Invalid URL Components")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let apiResponse = try decoder.decode(ArticleResponse.self, from: data)
            
            guard !apiResponse.articles.isEmpty else {
                //print("No articles found for category: \(category)")
                return []
            }
            
            return apiResponse.articles.compactMap { mapToNewsArticle(article: $0) }
            
        } catch let urlError as URLError where urlError.code == .unsupportedURL {
            throw APIError.invalidURL(url.absoluteString)
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError)
        } catch {
            throw APIError.unknownError
        }
    }
    
    private func mapToNewsArticle(article: ArticleResponse.ArticleData) -> NewsArticle? {
        guard let publishedDate = ISO8601DateFormatter().date(from: article.publishedAt) else { return nil }
        
        let newsArticleID =  UUID(uuidString: article.source?.id ?? "")
        let newsArticle = NewsArticle(
            id: newsArticleID ?? UUID(),
            sourceName: article.source?.name,
            author: article.author,
            title: article.title,
            articleDescription: article.description,
            url: article.url,
            urlToImage: article.urlToImage,
            publishedAt: publishedDate,
            content: article.content,
            bookmarked: false
        )
        
        // Clean up the article's title and description
        newsArticle.cleanUpText()
        return newsArticle
    }
    
    private func logDecodingError(_ error: DecodingError) {
        switch error {
        case .typeMismatch(let type, let context):
            print("Type mismatch for type \(type) in context: \(context.debugDescription)")
        case .valueNotFound(let value, let context):
            print("Value not found for \(value) in context: \(context.debugDescription)")
        case .keyNotFound(let key, let context):
            print("Key \(key) not found in context: \(context.debugDescription)")
        case .dataCorrupted(let context):
            print("Data corrupted in context: \(context.debugDescription)")
        @unknown default:
            print("Unknown Error")
        }
    }
}

