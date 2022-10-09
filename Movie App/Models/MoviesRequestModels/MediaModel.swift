//
//  File2.swift
//  Movie App
//
//  Created by user on 10.10.2022.
//

import Foundation

//enum MediaType: String, Codable {
//    case movie
//    case tv
//
//}
//
//
//
////struct SearchResults: Codable {
////    let page: Int
////    let results: [Media]
////    let totalResults, totalPages: Int
////
////}
//
//
//protocol Media: Codable {
//    var backdrop_path: String { get }
//    var genre_ids: [Int] { get }
//    var id: Int { get }
//    var media_type: MediaType { get }
//    var original_language: String { get }
//    var overview: String { get }
//    var popularity: Double { get }
//    var poster_path: String { get }
//    var vote_average: Double { get }
//    var vote_count: Int { get }
//}
//
//
//struct TVModel: Media {
//    var backdrop_path: String
//    let first_air_date: String
//    let genre_ids: [Int]
//    let id: Int
//    var media_type: MediaType {.tv}
//    let name: String
//    let origin_country: String
//    let original_language: String
//    let original_name: String
//    let overview: String
//    let popularity: Double
//    let poster_path: String
//    let vote_average: Double
//    let vote_count: Int
//}
//
//
//struct MovieModel: Media {
//    let adult: Bool
//    let backdrop_path: String
//    let genre_ids: [Int]
//    let id: Int
//    var media_type: MediaType {.movie}
//    let original_language: String
//    let original_title: String
//    let overview: String
//    let popularity: Double
//    let poster_path: String
//    let release_date: String
//    let title: String
//    let video: String
//    let vote_average: Double
//    let vote_count: Int
//
//}
//
//struct MediaCollection: Codable {
//    var movies: [MovieModel]
//    var tv: [TVModel]
//}
//
//private extension MediaCollection {
//    struct Encoded: Decodable {
//        var media: [EncodedMedia]
//    }
//
//    struct EncodedMedia: Codable {
//        var backdrop_path: String
//        var genre_ids: [Int]
//        var id: Int
//        var media_type: MediaType
//        var original_language: String
//        var overview: String
//        var popularity: Double
//        var poster_path: String
//        var vote_average: Double
//        var vote_count: Int
//        let first_air_date: String?
//        let name: String?
//        let origin_country: String?
//        let original_name: String?
//        let release_date: String?
//        let video: String?
//
//    }
//}
