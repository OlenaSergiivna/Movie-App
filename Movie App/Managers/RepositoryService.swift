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
    
    func movieFavoritesCashing(page: Int = 1, completion: @escaping([MovieModel], Int) -> Void) {
        
        // Data fetched from API
        DataManager.shared.requestFavoriteMovies(page: page) { success, totalPages, favorites, _, _  in
            switch success {
                
            case true:
                
                // Data saved in Realm Database
                guard let favorites = favorites else { return }
                
                let favoritesEnum = favorites.map({Media.movie($0)})
                RealmManager.shared.saveFavoritesInRealm(media: favoritesEnum)
                
                // Data fetched from Realm Database & converted in ViewController's models
                let favoritesArray = RealmManager.shared.getFromRealm(type: .movieFavorite)
                completion(favoritesArray as! [MovieModel], totalPages)
                
                
            case false:
                
                // Data fetched from Realm Database & converted in ViewController's models
                let favoritesArray = RealmManager.shared.getFromRealm(type: .movieFavorite)
                completion(favoritesArray as! [MovieModel], 0)
            }
        }
    }
    
    
    
    // MARK: - Cashing TV Shows from Favorites list
    
    func tvShowsFavoritesCashing(page: Int = 1, completion: @escaping([TVModel], Int) -> Void) {
        
        // Data fetched from API
        DataManager.shared.requestFavoriteTVShows(page: page) { success, totalPages, favorites, _, _ in
            switch success {
                
            case true:
                
                // Data saved in Realm Database
                guard let favorites = favorites else { return }
                
                let favoritesEnum = favorites.map({Media.tvShow($0)})
                RealmManager.shared.saveFavoritesInRealm(media: favoritesEnum)
                
                // Data fetched from Realm Database & converted in ViewController's models
                let favoritesArray = RealmManager.shared.getFromRealm(type: .tvFavorite)
                completion(favoritesArray as! [TVModel], totalPages)
                
            case false:
                
                // Data fetched from Realm Database & converted in ViewController's models
                let favoritesArray = RealmManager.shared.getFromRealm(type: .tvFavorite)
                completion(favoritesArray as! [TVModel], 0)
                
            }
        }
    }
}
