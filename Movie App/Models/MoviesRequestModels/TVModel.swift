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
    
    
    init(from movieRealm: FavoriteMovieRealm) {
        self.adult = movieRealm.adult
        self.backdropPath = movieRealm.backdropPath
        self.id = movieRealm.id
        self.originalLanguage = movieRealm.originalLanguage
        self.overview = movieRealm.overview
        self.posterPath = movieRealm.posterPath
        self.releaseDate = movieRealm.releaseDate
        self.genreIDS = Array(movieRealm.genreIDS)
        self.popularity = movieRealm.popularity
        self.voteAverage = movieRealm.voteAverage
        self.voteCount = movieRealm.voteCount
        self.title = movieRealm.title
        self.originalTitle = movieRealm.originalTitle
        self.video = movieRealm.video
        
        
    }
    
}
