//
//  MoviesByGenreModel.swift
//  Movie App
//
//  Created by user on 28.09.2022.
//

import Foundation

struct ResultsMovie: Codable {
    let page: Int
    let results: [MovieModel]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct MovieModel: Codable, Hashable {
    
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String?
    let popularity: Double
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    
    
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case title
        case originalTitle = "original_title"
        case video
    }
}


extension MovieModel {
    
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
    
    
    init(from movieRealm: SearchMovieRealm) {
        
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
