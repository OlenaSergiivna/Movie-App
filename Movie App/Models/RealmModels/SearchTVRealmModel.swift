//
//  SearchTVRealmModel.swift
//  Movie App
//
//  Created by user on 12.10.2022.
//

import Foundation
import RealmSwift

class SearchTVRealmModel: Object {
    
    @Persisted var page: Int
    @Persisted var results: List<SearchTVRealm>
    @Persisted var totalPages: Int
    @Persisted var totalResults: Int
}

class SearchTVRealm: Object {
    
    @Persisted var backdropPath: String?
    @Persisted var firstAirDate: String?
    @Persisted var genreIDS: List<Int>
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var originCountry: List<String>
    @Persisted var originalLanguage: String
    @Persisted var originalName: String
    @Persisted var overview: String
    @Persisted var popularity: Double
    @Persisted var posterPath: String?
    @Persisted var voteAverage: Double
    @Persisted var voteCount: Int
}
