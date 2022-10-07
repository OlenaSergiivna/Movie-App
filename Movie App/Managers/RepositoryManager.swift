//
//  RepositoryManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation

struct Repository {
    
    //static let shared = Repository()
    
    // MARK: -
    
    func getData() -> [FavoriteMovieRealm] {
        
        var favoritesArray: [FavoriteMovieRealm] = []
        
        DataManager.shared.requestFavorites { favorites in
            
            RealmManager.shared.saveFavoriteInRealm(movies: favorites)
            favoritesArray = RealmManager.shared.getFavoriteFromRealm()
            
        }
        
        return favoritesArray
    }
}
