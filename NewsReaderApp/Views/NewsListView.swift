//
//  NewsListView.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI

struct NewsListView: View {
    @EnvironmentObject var viewModel: NewsViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NewsFilterView()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .zIndex(1)
                
                if viewModel.isLoading {
                    ProgressView(NSLocalizedString("loading_articles", comment: "Loading articles message"))
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .frame(maxHeight: .infinity, alignment: .center)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    if viewModel.articles.isEmpty {
                        Text(NSLocalizedString("no_articles_available", comment: "No articles available message"))
                            .padding()
                            .frame(maxHeight: .infinity, alignment: .center)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.articles, id: \.title) { article in
                                    NavigationLink(destination: NewsDetailView(article: article)) {
                                        NewsRowView(
                                            article: article,
                                            isBookmarked: viewModel.isBookmarked(article),
                                            onBookmarkToggle: {
                                                Task {
                                                    await viewModel.handleBookmarkToggle(for: article)
                                                }
                                            }
                                        )
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle(NSLocalizedString("trending_news", comment: "Trending news title"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.fetchNews()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
