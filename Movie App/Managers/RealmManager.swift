//
//  SavingDataManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    private var realm = try! Realm()
    
    static let shared = RealmManager()
    
    func deleteAll() {
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    func saveFavoriteInRealm(movies: [Movie]) {
        
        for movie in movies {
            
            let movieRealm = FavoriteMovieRealm()
            
            movieRealm.adult = movie.adult
            movieRealm.backdropPath = movie.backdropPath
            movieRealm.genreIDS.append(objectsIn: movie.genreIDS)
            movieRealm.id = movie.id
            movieRealm.originalLanguage = movie.originalLanguage
            movieRealm.originalTitle = movie.originalTitle
            movieRealm.overview = movie.overview
            movieRealm.popularity = movie.popularity
            movieRealm.posterPath = movie.posterPath
            movieRealm.releaseDate = movie.releaseDate
            movieRealm.title = movie.title
            movieRealm.video = movie.video
            movieRealm.voteAverage = movie.voteAverage
            movieRealm.voteCount = movie.voteCount
            
            try? realm.write {
                realm.add(movieRealm, update: .all)
                
            }
        }
    }
    
    func getFavoriteFromRealm() -> [FavoriteMovieRealm] {
        
        let result = realm.objects(FavoriteMovieRealm.self)
        return Array(result)
    }
    
}
