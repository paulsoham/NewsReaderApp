//
//  NewsBookmarkedListView.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI

struct NewsBookmarkedListView: View {
    @EnvironmentObject var viewModel: NewsViewModel
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView(NSLocalizedString("loading_message", comment: ""))
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if viewModel.bookmarkedArticles.isEmpty {
                    Text(NSLocalizedString("no_bookmarked_articles", comment: ""))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.bookmarkedArticles, id: \.id) { article in
                                NavigationLink(destination: NewsDetailView(article: article)) {
                                    NewsRowView(
                                        article: article,
                                        isBookmarked: viewModel.isBookmarked(article),
                                        onBookmarkToggle: {
                                            if viewModel.networkMonitor.isConnected {
                                                Task {
                                                    await viewModel.handleBookmarkToggle(for: article)
                                                }
                                            } else {
                                                showAlert = true
                                            }
                                        }
                                    )
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle(NSLocalizedString("app_title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("app_title", comment: ""))
                        .font(.headline)
                        .foregroundColor(Color(red: 0.25, green: 0.47, blue: 0.75))
                }
            }
            .onAppear {
                Task {
                    viewModel.isLoading = true
                    await viewModel.fetchBookmarkedArticles()
                    viewModel.isLoading = false
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(NSLocalizedString("no_internet_message", comment: "")),
                    message: Text(NSLocalizedString("check_internet_message", comment: "")),
                    dismissButton: .default(Text(NSLocalizedString("ok_button", comment: "")))
                )
            }
        }
    }
}

