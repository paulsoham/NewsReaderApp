//
//  NewsDatabaseService.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import SwiftData
import Combine
import SwiftUI
import Foundation

protocol DatabaseServiceProtocol {
    func insertBookmarkedArticle(_ article: NewsArticle) async -> Result<NewsArticle, Error>
    func deleteBookmarkedArticle(_ article: NewsArticle) async -> Result<Void, Error>
    func fetchAllBookmarkedArticles() async -> Result<[NewsArticle], Error>
}

@Observable
class NewsDatabaseService: DatabaseServiceProtocol {
    
    @ObservationIgnored
    private let dataSource: NewsDatabaseManagerProtocol
    
    @MainActor
    init(dataSource: NewsDatabaseManagerProtocol = NewsDatabaseManager.shared) {
            self.dataSource = dataSource
    }
    
    func insertBookmarkedArticle(_ article: NewsArticle) async -> Result<NewsArticle, Error> {
        let saveResult = dataSource.appendItem(item: article)
          switch saveResult {
           case .success(let savedArticle):
               return .success(savedArticle)
           case .failure(let error):
               return .failure(error)
           }
    }
    
    func deleteBookmarkedArticle(_ article: NewsArticle) async -> Result<Void, Error> {
        if let title = article.title {
            let deleteResult = dataSource.removeItem(with:title)
            switch deleteResult {
            case .success:
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        }else {
            return .failure(DatabaseError.articleNotFound)
        }
    }
    
    func fetchAllBookmarkedArticles() async -> Result<[NewsArticle], Error> {
        let fetchResult = dataSource.fetchItems()
        switch fetchResult {
        case .success(let articles):
            // Remove duplicates by title
            let uniqueArticles = removeDuplicates(by: \.title, from: articles)
            return .success(uniqueArticles)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func removeDuplicates<T, U: Hashable>(by keyPath: KeyPath<T, U>, from items: [T]) -> [T] {
        var seenTitles: Set<U> = []
        return items.compactMap { item in
            let title = item[keyPath: keyPath]
            if seenTitles.insert(title).inserted {
                return item
            }
            return nil
        }
    }
    
    
}

