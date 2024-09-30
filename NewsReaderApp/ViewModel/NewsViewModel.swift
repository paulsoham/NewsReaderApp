//
//  NewsViewModel.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var bookmarkedArticles: [NewsArticle] = []
    @Published var selectedCategory: String = "general"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let apiService: APIServiceProtocol
    private let databaseService: DatabaseServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    let networkMonitor = NewsNetworkMonitor()
    
    init(apiService: APIServiceProtocol, databaseService: DatabaseServiceProtocol) {
        self.apiService = apiService
        self.databaseService = databaseService
        monitorNetwork()
    }
    
    func fetchNews() async {
        guard networkMonitor.isConnected else {
            errorMessage = NSLocalizedString("no_internet_connection", comment: "Displayed when there is no internet connection")
            return
        }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedArticles = try await apiService.fetchArticles(category: selectedCategory)
            self.articles = fetchedArticles
            self.articles.sort { $0.publishedAt > $1.publishedAt }
            updateBookmarkStatuses()
        } catch {
            errorMessage = String(format: NSLocalizedString("failed_to_fetch_articles", comment: "Displayed when fetching articles fails"), error.localizedDescription)
        }
    }
    
    func monitorNetwork() {
        networkMonitor.$isConnected
            .sink { isConnected in
                if !isConnected {
                    self.errorMessage = NSLocalizedString("no_internet_connection", comment: "Displayed when there is no internet connection")
                }else {
                    self.errorMessage = nil
                }
            }
            .store(in: &cancellables)
        
    }
    
    func isBookmarked(_ article: NewsArticle) -> Bool {
        bookmarkedArticles.contains(where: { $0.title == article.title })
    }
    
    func updateBookmarkStatuses() {
        for article in articles {
            article.isBookmarked = bookmarkedArticles.contains { $0.title == article.title }
        }
    }
    
    func handleBookmarkToggle(for article: NewsArticle) async {
        if isBookmarked(article) {
            let result = await databaseService.deleteBookmarkedArticle(article)
            switch result {
            case .success:
                if let index = bookmarkedArticles.firstIndex(where: { $0.title == article.title }) {
                    bookmarkedArticles.remove(at: index)
                }
                updateArticleBookmarkStatus(for: article, isBookmarked: false)
            case .failure(let error):
                print("Error removing bookmark: \(error.localizedDescription)")
            }
        } else {
            let result = await databaseService.insertBookmarkedArticle(article)
            switch result {
            case .success(let savedArticle):
                bookmarkedArticles.append(savedArticle)
                updateArticleBookmarkStatus(for: article, isBookmarked: true)
            case .failure(let error):
                print("Error adding bookmark: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateArticleBookmarkStatus(for article: NewsArticle, isBookmarked: Bool) {
        if let index = articles.firstIndex(where: { $0.title == article.title }) {
            articles[index].isBookmarked = isBookmarked
        }
    }
    
    func fetchBookmarkedArticles() async {
        let result = await databaseService.fetchAllBookmarkedArticles()
        switch result {
        case .success(let articles):
            self.bookmarkedArticles = articles
            updateBookmarkStatuses()
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_fetching_bookmarked_articles", comment: "Displayed when fetching bookmarked articles fails"), error.localizedDescription)
        }
    }
    
    func addBookmark(_ article: NewsArticle) async {
        let result = await databaseService.insertBookmarkedArticle(article)
        switch result {
        case .success(let savedArticle):
            // print("Article bookmarked: \(savedArticle.title ?? "Unknown Title")")
            bookmarkedArticles.append(savedArticle)
            updateArticleBookmarkStatus(for: savedArticle, isBookmarked: true)
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_bookmarking_article", comment: "Displayed when bookmarking an article fails"), error.localizedDescription)
        }
    }
    
    func removeBookmark(_ article: NewsArticle) async {
        let result = await databaseService.deleteBookmarkedArticle(article)
        switch result {
        case .success:
            // print("Article removed from bookmarks.")
            bookmarkedArticles.removeAll { $0.title == article.title }
            updateArticleBookmarkStatus(for: article, isBookmarked: false)
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_removing_article_from_bookmarks", comment: "Displayed when removing an article from bookmarks fails"), error.localizedDescription)
        }
    }
}
