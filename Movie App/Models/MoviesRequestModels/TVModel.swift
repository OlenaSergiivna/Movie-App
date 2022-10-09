//
//  TVModel.swift
//  Movie App
//
//  Created by user on 10.10.2022.
//

import Foundation

struct ResultsTV: Codable {
    let page: Int
    let results: [TVModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TVModel: Codable {
    var backdrop_path: String?
    let first_air_date: String?
    let genre_ids: [Int]
    let id: Int
    let name: String
    let origin_country: [String]
    let original_language: String
    let original_name: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let vote_average: Double
    let vote_count: Int
}
