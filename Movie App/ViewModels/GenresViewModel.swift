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
            
            Globals.movieGenres.append(contentsOf: data)
            
//            DispatchQueue.main.async { [weak self] in
//                guard let self else {
//                    return
//                }
//
//                movieTableView.reloadData()
//                print("genres fetched")
//            }
        }
    }
    
}

