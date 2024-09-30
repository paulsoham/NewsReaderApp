//
//  NewsTabBarView.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI

struct NewsTabBarView: View {
    var body: some View {
        let apiService = NewsAPIService()
        let databaseService = NewsDatabaseService()
        let viewModel = NewsViewModel(apiService: apiService, databaseService: databaseService)
        
        TabView {
            NewsListView()
                .tabItem {
                    Label(NSLocalizedString("news_tab_title", comment: "Title for the News tab"), systemImage: "newspaper")
                }
            
            NewsBookmarkedListView()
                .tabItem {
                    Label(NSLocalizedString("bookmarks_tab_title", comment: "Title for the Bookmarks tab"), systemImage: "bookmark")
                }
        }
        .task {
            await viewModel.fetchNews()
            await viewModel.fetchBookmarkedArticles()
        }.environmentObject(viewModel)
    }
}
