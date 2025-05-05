//
//  QuoteCardView.swift
//  Quote App
//
//  Created by Habibur Rahman on 20/4/25.
//

import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
       
       var body: some View {
           VStack(alignment: .leading, spacing: 12) {
               Text(quote.quote ?? "")
                   .font(.system(size: 20, weight: .medium, design: .serif))
                   .multilineTextAlignment(.leading)

               Text(quote.author ?? "")
                   .font(.subheadline)
                   .foregroundColor(.secondary)
                   .frame(maxWidth: .infinity, alignment: .trailing)
           }
           .padding()
           .background(
               RoundedRectangle(cornerRadius: 16)
                   .fill(Color(.systemBackground))
                   .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
           )
           .padding(.horizontal)
       }
}

#Preview {
    QuoteCardView(quote: Quote(id: 0, quote: "quote", author: "author"))
}
