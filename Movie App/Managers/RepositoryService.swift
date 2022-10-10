//
//  RepositoryManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation

struct RepositoryService {
    
    static let shared = RepositoryService()
    
    func movieFavoritesCashing(completion: @escaping([MovieModel]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.requestFavorites { favorites in
            
            // Data saved in Realm Database
            
            RealmManager.shared.saveFavoriteMoviesInRealm(movies: favorites)
            
            // Data fetched from Realm Database & converted in ViewController's models
            
            let favoritesArray = RealmManager.shared.getFavoritesFromRealm(type: .movie)
            
            completion(favoritesArray as! [MovieModel])
            
        }
    }
    
    
    func tvShowsFavoritesCashing(completion: @escaping([TVModel]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.requestFavorites { favorites in
            
            // Data saved in Realm Database
            
            RealmManager.shared.saveFavoriteMoviesInRealm(movies: favorites)
            
            // Data fetched from Realm Database & converted in ViewController's models
            
            let favoritesArray = RealmManager.shared.getFavoritesFromRealm(type: .movie)
            
            completion(favoritesArray as! [TVModel])
            
        }
    }
}
