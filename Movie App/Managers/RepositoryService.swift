//
//  RepositoryManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation
import UIKit

struct RepositoryService {
    
    static let shared = RepositoryService()
    
    func dataCashingFavorites(completion: @escaping([Movie]) -> Void) {
        
        // Data fetched from API
        
        DataManager.shared.requestFavorites { favorites in
            
            // Data saved in Realm Database
            
            RealmManager.shared.saveFavoriteInRealm(movies: favorites)
            
            // Data fetched from Realm Database
            
            let favoritesArray = RealmManager.shared.getFavoriteFromRealm()
            
            // Data converted in ViewController's models
            
            let data = RealmManager.shared.convert(to: favoritesArray)
            completion(data)
            
        }
    }
}
