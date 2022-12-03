//
//  NowPlayingModels.swift
//  Movie App
//
//  Created by user on 30.10.2022.
//

import Foundation

struct NowPlayingResults: Codable {
    
    let dates: NowPlayingDates
    let page: Int
    let results: [MovieModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct NowPlayingDates: Codable {
    let maximum, minimum: String
}
