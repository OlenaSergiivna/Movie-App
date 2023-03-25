//
//  SavingDataManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation
import RealmSwift
import Realm

enum MediaRealm {
    case movieFavorite
    case tvFavorite
}


struct RealmManager {
    // try! / try?
    private var realm = try! Realm()
    
    static let shared = RealmManager()
    
    private init() {}
    
    // MARK: - Delete all data from Realm
    
    func deleteAll() {
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    func saveFavoritesInRealm(media: [Media]) {
        
        media.forEach { media in
            
            switch media {
                
            case .movie(let movie):
                var movies: [MovieModel] = []
                movies.append(movie)
                saveFavoriteMoviesInRealm(movies: movies)
                
            case .tvShow(let tvShow):
                var tvShows: [TVModel] = []
                tvShows.append(tvShow)
                saveFavoriteTVInRealm(tvShows: tvShows)
            }
        }
    }
    
    
    //MARK: - Save favorite movies in Realm
    
    private func saveFavoriteMoviesInRealm(movies: [MovieModel]) {
        
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
                realm.add(movieRealm, update: .modified)
                
            }
        }
    }
    
    
    //MARK: - Save favorite TV Shows in Realm
    
    private func saveFavoriteTVInRealm(tvShows: [TVModel]) {
        
        for tv in tvShows {
            
            let tvRealm = FavoriteTVRealm()
            
            tvRealm.backdropPath = tv.backdropPath
            tvRealm.firstAirDate = tv.firstAirDate
            tvRealm.genreIDS.append(objectsIn: tv.genreIDS)
            tvRealm.id = tv.id
            tvRealm.name = tv.name
            tvRealm.originCountry.append(objectsIn: tv.originCountry)
            tvRealm.originalLanguage = tv.originalLanguage
            tvRealm.originalName = tv.originalName
            tvRealm.overview = tv.overview
            tvRealm.popularity = tv.popularity
            tvRealm.posterPath = tv.posterPath
            tvRealm.voteAverage = tv.voteAverage
            tvRealm.voteCount = tv.voteCount
            
            try? realm.write {
                realm.add(tvRealm, update: .modified)
                
            }
        }
    }
    
    
    //MARK: - Get from Realm
    
    func getFromRealm(type: MediaRealm) -> Any {
        switch type {
            
        case .movieFavorite:
            let moviesRealm = realm.objects(FavoriteMovieRealm.self)
            var movies = [MovieModel]()
            
            for movieRealm in moviesRealm {
                let movie = MovieModel(from: movieRealm)
                movies.append(movie)
            }
            return (Array(movies))
            
        case .tvFavorite:
            let tvRealm = realm.objects(FavoriteTVRealm.self)
            var tvShows = [TVModel]()
            
            for tv in tvRealm {
                let tv = TVModel(from: tv)
                tvShows.append(tv)
            }
            return (Array(tvShows))
        }
    }
    
    
    //MARK: - Delete object of specific type from Realm
    
    func deleteFromRealm<T>(type: RealmSwiftObject.Type, primaryKey: T, completion: @escaping() -> Void) {
        
        guard let dataToDelete = realm.object(ofType: type, forPrimaryKey: primaryKey) else {
            return
        }
        
        try? realm.write {
            realm.delete(dataToDelete)
        }
        completion()
    }
}
