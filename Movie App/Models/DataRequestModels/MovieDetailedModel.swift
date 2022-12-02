//
//  MovieDetailedModel.swift
//  Movie App
//
//  Created by user on 24.11.2022.
//

import Foundation

struct MovieDetailedModel: Codable {
    
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: CollectionN?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanies]
    let productionCounries: [ProductionCountries]
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguages]
    let status: String
    let tagline: String?
    let title: String?
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCounries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct CollectionN: Codable {
    
}

struct ProductionCompanies: Codable {
    let name: String
    let id: Int
    let logoPath: String?
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct ProductionCountries: Codable {
    let iso_3166_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso_3166_1 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguages: Codable {
    let iso639_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case name
    }
    
}


