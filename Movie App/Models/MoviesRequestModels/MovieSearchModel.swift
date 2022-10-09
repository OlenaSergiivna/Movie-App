//
//  MovieSearch.swift
//  Movie App
//
//  Created by user on 09.10.2022.
//

import Foundation

struct SearchResults: Codable {
    
    let page: Int
    let results: [MovieSearch]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct MovieSearch: Codable {
    let backdropPath: String?
    let firstAirDate: String?
    let genreIDS: [Int]?
    let id: Int
    let mediaType: MediaType
    let name: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName, overview: String?
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let adult: Bool?
    let originalTitle, releaseDate, title: String?
    let video: Bool?
    let gender: Int?
    let knownFor: [KnownFor]?
    let knownForDepartment, profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case adult
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case title, video, gender
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
}

// Movie model ?

struct KnownFor: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let mediaType: MediaType
    let originalLanguage: String
    let originalTitle, overview, posterPath, releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case person = "person"
    case tv = "tv"
}
