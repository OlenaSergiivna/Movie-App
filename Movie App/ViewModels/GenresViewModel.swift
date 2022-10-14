//
//  GenresViewModel.swift
//  Movie App
//
//  Created by user on 05.10.2022.
//

import UIKit

private class ViewModel {
    
    let movieGenres: Binder<[Genre]> = Binder([])
    
    func requestMovies() {
        
        DataManager.shared.requestMovieGenres { data, code in
            
            Globals.genres.append(contentsOf: data)
            
//            DispatchQueue.main.async { [weak self] in
//                guard let self else {
//                    return
//                }
//
//                genresTableView.reloadData()
//                print("genres fetched")
//            }
        }
    }
    
}

