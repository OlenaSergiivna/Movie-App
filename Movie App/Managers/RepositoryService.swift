//
//  RepositoryManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation

struct RepositoryService {
    
    static let shared = RepositoryService()
    
    
    // MARK: - Cashing movies from Favorites list
    
    func movieFavoritesCashing(completion: @escaping([MovieModel]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.requestFavoriteMovies { success, favorites, _, _ in
            switch success {
                
            case true:
                
                // Data saved in Realm Database
                
                if let favorites = favorites {
                    
                    RealmManager.shared.saveFavoriteMoviesInRealm(movies: favorites)
                    
                    // Data fetched from Realm Database & converted in ViewController's models
                    
                    let favoritesArray = RealmManager.shared.getFromRealm(type: .movieFavorite)
                    print("get data, saved in realm, get from realm")
                    completion(favoritesArray as! [MovieModel])
                }
                
            case false:
                
                // Data fetched from Realm Database & converted in ViewController's models
                
                let favoritesArray = RealmManager.shared.getFromRealm(type: .movieFavorite)
                print("no connection/no data, get data from realm")
                completion(favoritesArray as! [MovieModel])
            }
            
        }
        
//        { favorites, statusCode in
//            print(statusCode)
//
//        }
//
//        //        print("Internet Connection not Available!")
//        //
//        // Data fetched from Realm Database & converted in ViewController's models
//        
//        let favoritesArray = RealmManager.shared.getFromRealm(type: .movieFavorite)
//        
//        completion(favoritesArray as! [MovieModel])
//        
    }
    
    
    // MARK: - Cashing TV Shows from Favorites list
    
    func tvShowsFavoritesCashing(completion: @escaping([TVModel]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.requestFavoriteTVShows { success, favorites, _, _ in
            
            // Data saved in Realm Database
            guard let favorites = favorites else { return }
            
            RealmManager.shared.saveFavoriteTVInRealm(tvShows: favorites)
            
            // Data fetched from Realm Database & converted in ViewController's models
            
            let favoritesArray = RealmManager.shared.getFromRealm(type: .movieFavorite)
            
            completion(favoritesArray as! [TVModel])
            
        }
    }
    
    
    //  // MARK: - Cashing movies from search
    
    func movieSearchCashing(text: String, page: Int, completion: @escaping([MovieModel]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.searchMovie(with: text, page: page) { results in
            
            // Data saved in Realm Database
            
            RealmManager.shared.saveMoviesSearchResultsInRealm(movies: results)
            
            // Data fetched from Realm Database & converted in ViewController's models
            
            let searchArray = RealmManager.shared.getFromRealm(type: .movieSearch)
            
            completion(searchArray as! [MovieModel])
        }
    }
    
    
    // MARK: - Cashing TV Shows from search
    
    func tvSearchCashing(text: String, page: Int, completion: @escaping([TVModel]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.searchTV(with: text, page: page) { results in
            
            // Data saved in Realm Database
            
            RealmManager.shared.saveTVSearchResultsInRealm(tvShows: results)
            
            // Data fetched from Realm Database & converted in ViewController's models
            
            let searchArray = RealmManager.shared.getFromRealm(type: .tvSearch)
            
            completion(searchArray as! [TVModel])
        }
    }
}
