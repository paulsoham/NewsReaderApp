//
//  NewsDatabaseManager.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import Foundation
import SwiftData


protocol NewsDatabaseManagerProtocol {
    func appendItem(item: NewsArticle) -> Result<NewsArticle, Error>
    func removeItem(with title: String) -> Result<Void, Error>
    func fetchItems() -> Result<[NewsArticle], Error>
}
extension NewsDatabaseManager: NewsDatabaseManagerProtocol { }





enum DatabaseError: Error {
    case articleNotFound
    case deletionFailed(String)
}

final class NewsDatabaseManager {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = NewsDatabaseManager()
    
    @MainActor
    init() {
        do {
            self.modelContainer = try ModelContainer(for: NewsArticle.self)
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    func appendItem(item: NewsArticle) -> Result<NewsArticle, Error> {
        modelContext.insert(item)
        do {
            try modelContext.save()
            return Result.success(item)
        } catch {
            // let localizedError = String(format: NSLocalizedString("failed_to_save_article", comment: ""), error.localizedDescription)
            //print(localizedError)
            return Result.failure(error)
        }
    }
    
    func fetchItems() -> Result<[NewsArticle], Error> {
        let fetchDescriptor = FetchDescriptor<NewsArticle>()
        do {
            let items = try modelContext.fetch(fetchDescriptor)
            // print("Fetched \(items.count) articles from the database.")
            return .success(items)
        } catch {
            // let localizedError = String(format: NSLocalizedString("failed_to_fetch_articles", comment: ""), error.localizedDescription)
            //print(localizedError)
            return .failure(error)
        }
    }
    
    func removeItem(with id: String) -> Result<Void, Error> {
        let fetchDescriptor = FetchDescriptor<NewsArticle>()
        do {
            let items: [NewsArticle] = try modelContext.fetch(fetchDescriptor)
            guard let itemToDelete = items.first(where: { $0.title == id }) else {
                // let localizedError = NSLocalizedString("article_not_found", comment: "")
                return .failure(DatabaseError.articleNotFound)
            }
            modelContext.delete(itemToDelete)
            try modelContext.save()
            // let successMessage = String(format: NSLocalizedString("successfully_removed_article", comment: ""), id)
            // print(successMessage)
            return .success(())
        } catch {
            // let localizedError = String(format: NSLocalizedString("deletion_failed", comment: ""), error.localizedDescription)
            //print(localizedError)
            return .failure(error)
        }
    }
}
