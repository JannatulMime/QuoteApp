//
//  ApiService.swift
//  Quote App
//
//  Created by Habibur Rahman on 18/4/25.
//

import Foundation

@MainActor
class QuoteViewModel: ObservableObject {
    @Published var quoteList: [Quote] = []
    private var currentPage = 0
    private let limit = 10 // Number of quotes per page
    private var isLoading = false
    private var hasMorePages = true
    let manager = CoreDataManager.instance
    
    init() {
           loadSavedQuotes() 
       }

       func loadSavedQuotes() {
           quoteList = manager.loadSavedQuotes()
       }

    
    func fetchQuotes() async {
      
        if isLoading && hasMorePages == false {
            return
        }

        isLoading = true
        let skip = currentPage * limit

        let urlString = "https://dummyjson.com/quotes?limit=\(limit)&skip=\(skip)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // Optional: print JSON prettily
            if let prettyStr = prettyPrintedJSONString(from: data) {
                print("Response is ->   \(prettyStr)")
            }

            let decodedQuotes = try JSONDecoder().decode(QuoteResponse.self, from: data)
            let quotes = decodedQuotes.quotes ?? []

            if quotes.isEmpty {
                hasMorePages = false
            } else {
                quoteList.append(contentsOf: quotes)
                currentPage += 1
                manager.saveQuotesToCoreData(quotes)
            }
        } catch {
            print("Error fetching or decoding quotes:", error)
        }

        isLoading = false
    }
    

    func loadMore (){
        print("U>> last item Load more ")
       // currentPage += 1
        Task{
            await fetchQuotes()
        }
       
    }
}


func prettyPrintedJSONString(from data: Data) -> String? {
    // 1. Deserialize into a JSON object
    guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
          // 2. Re‑serialize with pretty‐print formatting
          let prettyData = try? JSONSerialization.data(
              withJSONObject: object,
              options: [.prettyPrinted]
          ),
          // 3. Convert back to String
          let prettyString = String(data: prettyData, encoding: .utf8)
    else {
        return nil
    }
    return prettyString
}
