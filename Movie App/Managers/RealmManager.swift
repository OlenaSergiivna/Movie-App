//
//  SavingDataManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation
import RealmSwift
import Realm

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
    
    //MARK: - Save movies in Realm
    
    func saveFavoriteMoviesInRealm(movies: [MovieModel]) {
        
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
    
    //MARK: - Save tv shows in Realm
    
    func saveFavoriteTVInRealm(tvShows: [TVModel]) {
        
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
                realm.add(tvRealm, update: .all)
                
            }
        }
    }
    
    
    enum MediaType {
        case movieFavorite
        case tvFavorite
        case movieSearch
        case tvSearch
    }
    
    //MARK: - Get from Realm
    
    func getFromRealm(type: MediaType) -> Any {
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
            
        case .movieSearch:
            
            let moviesRealm = realm.objects(SearchMovieRealm.self)
            
            var movies = [MovieModel]()
            
            for movieRealm in moviesRealm {
                let movie = MovieModel(from: movieRealm)
            }
            return (Array(movies))
            
        case .tvSearch:
            let tvRealm = realm.objects(SearchTVRealm.self)
            
            var tvShows = [TVModel]()
            
            for tv in tvRealm {
                let tv = TVModel(from: tv)
                tvShows.append(tv)
            }
            
            return (Array(tvShows))
        }
    }
    
    //MARK: - Delete object from Realm
    
    func delete<T>(type: RealmSwiftObject.Type, primaryKey: T, completion: @escaping() -> Void) {
        
        guard let dataToDelete = realm.object(ofType: type, forPrimaryKey: primaryKey) else {
            return
        }
        
        try? realm.write {
            realm.delete(dataToDelete)
        }
        completion()
    }
    
    
    func saveMoviesSearchResultsInRealm(movies: [MovieModel]) {
        
        for movie in movies {
            
            let movieRealm = SearchMovieRealm()
            
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
    
    
    func saveTVSearchResultsInRealm(tvShows: [TVModel]) {
        
        for tv in tvShows {
            
            let tvRealm = SearchTVRealm()
            
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
                realm.add(tvRealm, update: .all)
                
            }
        }
    }
}
