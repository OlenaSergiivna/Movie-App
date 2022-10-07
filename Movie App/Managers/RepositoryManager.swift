//
//  RepositoryManager.swift
//  Movie App
//
//  Created by user on 07.10.2022.
//

import Foundation
import UIKit

struct Repository {
    
    static let shared = Repository()
    
    // MARK: -
    
    func dataCashingFavorites(completion: @escaping([Movie]) -> Void) {
        
        DataManager.shared.requestFavorites { favorites in
            
            RealmManager.shared.saveFavoriteInRealm(movies: favorites)
            
            let favoritesArray = RealmManager.shared.getFavoriteFromRealm()
            
           
           let data = RealmManager.shared.convert(to: favoritesArray)
            completion(data)
            
        }
        
        
    
    }
}
