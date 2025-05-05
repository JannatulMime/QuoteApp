//
//  MainView.swift
//  Quote App
//
//  Created by Habibur Rahman on 18/4/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var vm = QuoteViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(vm.quoteList.indices, id: \.self) { index in
                        QuoteCardView(quote: vm.quoteList[index])
                        let currentQuote = vm.quoteList[index]
                        if currentQuote == vm.quoteList.last {
                            Color.clear
                                .frame(height: 1)
                                .onAppear {
                                    vm.loadMore()
                                }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Quotes")
            .background(Color(.systemGroupedBackground))
            .onAppear {
                Task {
                    await vm.fetchQuotes()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
