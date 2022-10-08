//
//  SavingDataManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation
import RealmSwift

struct RealmManager {
    // try! / try?
    private var realm = try! Realm()
    
    static let shared = RealmManager()
    
    private init() { }
    
    func deleteAll() {
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    func saveFavoriteInRealm(movies: [Movie]) {
        //cast type? init?
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
    
    
    func convert(to moviesRealm: [FavoriteMovieRealm]) -> [Movie] {
        var movies = [Movie]()
    
            for movieRealm in moviesRealm {
                let movie = Movie(from: movieRealm)
                movies.append(movie)
            }

        return movies
    }
    
    
    func delete<T>(primaryKey: T, completion: @escaping() -> Void) {
        
        guard let dataToDelete = realm.object(ofType: FavoriteMovieRealm.self, forPrimaryKey: primaryKey) else {
            return
        }
        
        try? realm.write {
            realm.delete(dataToDelete)
        }
        completion()
    }
    
}
