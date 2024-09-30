//
//  NewsTabBarViewTests.swift
//  NewsReaderAppTests
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI
import XCTest
@testable import NewsReaderApp

class NewsTabBarViewTests: XCTestCase {
    
    var apiService: NewsAPIService!
    var databaseService: NewsDatabaseService!
    var viewModel: NewsViewModel!
    
    @MainActor override func setUp() {
        super.setUp()
        apiService = NewsAPIService()
        databaseService = NewsDatabaseService()
        viewModel = NewsViewModel(apiService: apiService, databaseService: databaseService)
    }
    
    override func tearDown() {
        apiService = nil
        databaseService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialization() {
        let view = NewsTabBarView()
        XCTAssertNotNil(view)
    }
    
    @MainActor func testNewsTabBarView_initialState() {
        let viewModel = NewsViewModel(apiService: apiService, databaseService: databaseService)
        let view = NewsTabBarView().environmentObject(viewModel)
        let hostingController = UIHostingController(rootView: view)
        XCTAssertNotNil(hostingController)
        XCTAssertEqual(viewModel.articles.count, 0)
        XCTAssertEqual(viewModel.bookmarkedArticles.count, 0)
    }
    
    @MainActor func testNewsTabBarView_fetchNews() async {
        let viewModel = NewsViewModel(apiService: apiService, databaseService: databaseService)
        _ = NewsTabBarView().environmentObject(viewModel)
        await viewModel.fetchNews()
        XCTAssertGreaterThan(viewModel.articles.count, 0)
    }
    
    @MainActor func testNewsTabBarView_fetchBookmarkedArticles() async {
        let viewModel = NewsViewModel(apiService: apiService, databaseService: databaseService)
        let view = NewsTabBarView().environmentObject(viewModel)
        await viewModel.fetchBookmarkedArticles()
        XCTAssertNotNil(viewModel.bookmarkedArticles)
    }
    
    
}
