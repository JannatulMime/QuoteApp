//
//  QuoteModel.swift
//  Quote App
//
//  Created by Habibur Rahman on 18/4/25.
//

import Foundation

struct Quote: Identifiable, Codable , Equatable{
    let id: Int?
    let quote: String?
    let author: String?
}

struct QuoteResponse: Codable {
    let quotes: [Quote]?
    let total: Int?
    let skip: Int?
    let limit: Int?
}
