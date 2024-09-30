//
//  NewsFilterView.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import SwiftUI

struct NewsFilterView: View {
    @EnvironmentObject var viewModel: NewsViewModel
    
    let categories = [
        NSLocalizedString("category_general", comment: ""),
        NSLocalizedString("category_business", comment: ""),
        NSLocalizedString("category_technology", comment: ""),
        NSLocalizedString("category_health", comment: ""),
        NSLocalizedString("category_science", comment: ""),
        NSLocalizedString("category_sports", comment: ""),
        NSLocalizedString("category_entertainment", comment: "")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.capitalized)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(viewModel.selectedCategory == category ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                viewModel.selectedCategory = category
                                Task {
                                    await viewModel.fetchNews()
                                }
                            }
                    }
                }
                .padding()
            }
            .frame(height: 44)
            
        }
        .padding(.top, 0)
        .navigationBarTitle(NSLocalizedString("news_title", comment: ""), displayMode: .inline)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(NSLocalizedString("news_title", comment: ""))
                    .font(.headline)
                    .foregroundColor(Color(red: 0.25, green: 0.47, blue: 0.75))
            }
        }
    }
}
