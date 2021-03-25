//
//  NewsJSONStruct.swift
//  UseWebAPIs
//
//  Created by Никита Полыко on 25.03.21.
//

import Foundation

struct TotalInformation: Decodable {
    let totalResults: Int
    let articles: [Articles]
}

struct Articles: Decodable {
    let source: Source
    let author: String?
    let title: String
    let description: String
    let publishedAt: String
}

struct Source: Decodable {
    let name: String
}
