//
//  MovieSearch.swift
//  Movie App
//
//  Created by user on 09.10.2022.
//

import Foundation

struct SearchResults: Codable {
    let page: Int
    let results: [MediaSearchResult]
    let totalResults, totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct MediaSearchResult: Codable {
    let posterPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDate, originalTitle, title: String?
    let genreIDS: [Int]?
    let id: Int?
    let mediaType: MediaType
    let originalLanguage: String?
    let backdropPath: String?
    let popularity: Double?
    let voteAverage: Double?
    let voteCount: Int?
    let video: Bool?
    let firstAirDate: String?
    let originCountry: [String]?
    let name, originalName: String?
    let profilePath: String?
    let knownFor: [KnownFor]?

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity, id, overview
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case adult
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case title, video
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

struct KnownFor: Codable {
    let posterPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDate, originalTitle, title: String?
    let genreIDS: [Int]?
    let id: Int?
    let mediaType: MediaType
    let originalLanguage: String?
    let backdropPath: String?
    let popularity: Double?
    let voteAverage: Double?
    let voteCount: Int?
    let video: Bool?
    let firstAirDate: String?
    let originCountry: [String]?
    let name, originalName: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity, id, overview
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case adult
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case title, video
        case profilePath = "profile_path"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case person = "person"
    case tv = "tv"
}
