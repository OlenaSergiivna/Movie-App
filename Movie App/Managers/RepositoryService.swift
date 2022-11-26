//
//  RepositoryManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation

struct RepositoryService {
    
    static let shared = RepositoryService()
    
    private init() {}
    
    // MARK: - Cashing movies from Favorites list
    
    func movieFavoritesCashing(completion: @escaping([MovieModel]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.requestFavoriteMovies { success, favorites, _, _ in
            switch success {
                
            case true:
                
                // Data saved in Realm Database
                
                guard let favorites = favorites else { return }
                
                RealmManager.shared.saveFavoriteMoviesInRealm(movies: favorites)
                
                // Data fetched from Realm Database & converted in ViewController's models
                
                let favoritesArray = RealmManager.shared.getFromRealm(type: .movieFavorite)
                completion(favoritesArray as! [MovieModel])
                
                
            case false:
                
                // Data fetched from Realm Database & converted in ViewController's models
                
                let favoritesArray = RealmManager.shared.getFromRealm(type: .movieFavorite)
                completion(favoritesArray as! [MovieModel])
            }
        }
    }
    
    
    
    // MARK: - Cashing TV Shows from Favorites list
    
    func tvShowsFavoritesCashing(completion: @escaping([TVModel]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.requestFavoriteTVShows { success, favorites, _, _ in
            switch success {
            case true:
                
                // Data saved in Realm Database
                
                guard let favorites = favorites else { return }
                
                RealmManager.shared.saveFavoriteTVInRealm(tvShows: favorites)
                
                // Data fetched from Realm Database & converted in ViewController's models
                
                let favoritesArray = RealmManager.shared.getFromRealm(type: .tvFavorite)
                completion(favoritesArray as! [TVModel])
                
                
                
            case false:
                
                // Data fetched from Realm Database & converted in ViewController's models
                
                let favoritesArray = RealmManager.shared.getFromRealm(type: .tvFavorite)
                completion(favoritesArray as! [TVModel])
                
            }
        }
    }
}
