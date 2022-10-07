//
//  FavoriteMoviesRealmModel.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation
import RealmSwift

class FavoritesRealm: Object {
    
    @Persisted var page: Int
    @Persisted var results: List<FavoriteMovieRealm>
    @Persisted var totalPages: Int
    @Persisted var totalResults: Int
}

class FavoriteMovieRealm: Object {
    
    @Persisted var adult: Bool
    @Persisted var backdropPath: String?
    @Persisted var genreIDS: List<Int>
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var originalLanguage: String
    @Persisted var originalTitle: String?
    @Persisted var overview: String?
    @Persisted var popularity: Double
    @Persisted var posterPath: String?
    @Persisted var releaseDate: String?
    @Persisted var title: String?
    @Persisted var video: Bool?
    @Persisted var voteAverage: Double
    @Persisted var voteCount: Int
}


