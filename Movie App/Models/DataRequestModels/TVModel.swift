//
//  TVModel.swift
//  Movie App
//
//  Created by user on 10.10.2022.
//

import Foundation

struct ResultsTV: Codable {
    let page: Int
    let tvShows: [TVModel]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case tvShows = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TVModel: Codable, Hashable {
    var backdropPath: String?
    let firstAirDate: String?
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
}


extension TVModel {
    
    init(from tvRealm: FavoriteTVRealm) {
        
        self.backdropPath = tvRealm.backdropPath
        self.firstAirDate = tvRealm.firstAirDate
        self.genreIDS = Array(tvRealm.genreIDS)
        self.id = tvRealm.id
        self.name = tvRealm.name
        self.originCountry = Array(tvRealm.originCountry)
        self.originalLanguage = tvRealm.originalLanguage
        self.originalName = tvRealm.originalName
        self.overview = tvRealm.overview
        self.popularity = tvRealm.popularity
        self.posterPath = tvRealm.posterPath
        self.voteAverage = tvRealm.voteAverage
        self.voteCount = tvRealm.voteCount
    }
    
    
    init(from tvRealm: SearchTVRealm) {
        
        self.backdropPath = tvRealm.backdropPath
        self.firstAirDate = tvRealm.firstAirDate
        self.genreIDS = Array(tvRealm.genreIDS)
        self.id = tvRealm.id
        self.name = tvRealm.name
        self.originCountry = Array(tvRealm.originCountry)
        self.originalLanguage = tvRealm.originalLanguage
        self.originalName = tvRealm.originalName
        self.overview = tvRealm.overview
        self.popularity = tvRealm.popularity
        self.posterPath = tvRealm.posterPath
        self.voteAverage = tvRealm.voteAverage
        self.voteCount = tvRealm.voteCount
    }
    
    
    init(from trendyMedia: TrendyMedia) {
        
        self.backdropPath = trendyMedia.backdropPath
        self.firstAirDate = trendyMedia.firstAirDate
        self.genreIDS = trendyMedia.genreIDS
        self.id = trendyMedia.id
        self.name = trendyMedia.name ?? ""
        self.originCountry = trendyMedia.originCountry ?? []
        self.originalLanguage = trendyMedia.originalLanguage
        self.originalName = trendyMedia.originalName ?? ""
        self.overview = trendyMedia.overview ?? ""
        self.popularity = trendyMedia.popularity
        self.posterPath = trendyMedia.posterPath
        self.voteAverage = trendyMedia.voteAverage
        self.voteCount = trendyMedia.voteCount
        
    }
}
