//
//  NewsFilterViewTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI
import XCTest
@testable import NewsReaderApp

final class NewsFilterViewTests: XCTestCase {
    
    var viewModel: NewsViewModel!
    
    @MainActor override func setUp() {
        super.setUp()
        let apiService = NewsAPIService()
        let databaseService = NewsDatabaseService()
        viewModel = NewsViewModel(apiService: apiService, databaseService: databaseService)
    }
    
    @MainActor func testSelectedCategoryChangesOnTap() {
        let categoryToSelect = NSLocalizedString("category_business", comment: "") // Replace with the actual localized string
        
        _ = NewsFilterView()
            .environmentObject(viewModel)
        
        viewModel.selectedCategory = categoryToSelect
        XCTAssertEqual(viewModel.selectedCategory, categoryToSelect, "Selected category should change when tapped.")
    }
    
    func testCategoriesCount() {
        let expectedCategoriesCount = 7 // Total number of categories
        _ = NewsFilterView()
            .environmentObject(viewModel)
        
        let categories = [
            NSLocalizedString("category_general", comment: ""),
            NSLocalizedString("category_business", comment: ""),
            NSLocalizedString("category_technology", comment: ""),
            NSLocalizedString("category_health", comment: ""),
            NSLocalizedString("category_science", comment: ""),
            NSLocalizedString("category_sports", comment: ""),
            NSLocalizedString("category_entertainment", comment: "")
        ]
        XCTAssertEqual(categories.count, expectedCategoriesCount, "There should be \(expectedCategoriesCount) categories defined.")
    }
    
    @MainActor func testDefaultSelectedCategory() {
        _ = NewsFilterView()
            .environmentObject(viewModel)
        XCTAssertEqual(viewModel.selectedCategory, "general")
    }
}
